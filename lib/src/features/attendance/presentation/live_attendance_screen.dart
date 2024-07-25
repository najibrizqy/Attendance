import 'dart:async';
import 'dart:developer';

import 'package:attendance/src/common_widgets/custom_alert_widget.dart';
import 'package:attendance/src/common_widgets/home_app_bar_widget.dart';
import 'package:attendance/src/features/attendance/domain/attendance.dart';
import 'package:attendance/src/features/attendance/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendance/src/features/attendance/presentation/set_master_location_screen.dart';
import 'package:attendance/src/services/shared_preferences_service.dart';
import 'package:attendance/src/theme_manager/color_manager.dart';
import 'package:attendance/src/theme_manager/font_manager.dart';
import 'package:attendance/src/theme_manager/style_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';

class LiveAttendanceScreen extends StatefulWidget {
  static const String routeName = './live-attendance';
  const LiveAttendanceScreen({super.key});

  @override
  State<LiveAttendanceScreen> createState() => _LiveAttendanceScreenState();
}

class _LiveAttendanceScreenState extends State<LiveAttendanceScreen> {
  double lat = 0;
  double long = 0;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late LatLng circleCenter = const LatLng(37.42249578578477, -122.08371801993);

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  BitmapDescriptor? customIcon;
  bool isLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _renderMarker();
    _determinePosition();
  }

  Future<void> _loadMasterLocation() async {
    Map<String, double?> latLong =
        await SharedPreferenceService().getMasterLocation();

    if (latLong['latitude'] == null) {
      _saveLatLong(lat, long);
    } else {
      log('latitude ${latLong['latitude']} - longitude ${latLong['longitude']}');
      setState(() {
        circleCenter = LatLng(latLong['latitude']!, latLong['longitude']!);
      });
    }
  }

  Future<void> _saveLatLong(lat, long) async {
    await SharedPreferenceService().saveMasterLocation(lat, long);
  }

  Future<void> _renderMarker() async {
    BitmapDescriptor.asset(
            const ImageConfiguration(
              size: Size(40, 40),
            ),
            'assets/images/marker.png')
        .then((d) {
      customIcon = d;
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {});
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {});
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {});
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      isLocationEnabled = true;
    });

    _updateCameraPosition();
    _loadMasterLocation();
  }

  Future<void> _updateCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 17.6746,
        ),
      ),
    );
  }

  Future<void> _checkDistance() async {
    double distanceInMeters = Geolocator.distanceBetween(
        lat, long, circleCenter.latitude, circleCenter.longitude);

    if (distanceInMeters > 50) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Warning',
            content:
                'You are outside the coverage area. You must be within a 50 meter radius of the location point.',
            onOkPressed: () => Navigator.of(context).pop(),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Success',
            content:
                'You have successfully checked in. You can see the history by clicking the icon in the top right.',
            onOkPressed: () {
              Attendance attendance = Attendance(
                checkinDate: DateTime.now(),
                latitude: lat.toString(),
                longitude: long.toString(),
                distance: distanceInMeters.toStringAsFixed(2),
              );
              context.read<AttendanceBloc>().add(
                    AddAttendance(
                      attendance: attendance,
                    ),
                  );
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeAppBarWidget(
                title: 'Live Attendance',
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: isLocationEnabled,
                      initialCameraPosition: kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      circles: {
                        Circle(
                          circleId: const CircleId('CircleId'),
                          center: circleCenter,
                          radius: 50,
                          strokeColor: ColorManager.primary,
                          strokeWidth: 1,
                          fillColor: const Color.fromRGBO(66, 150, 210, 0.4),
                        ),
                      },
                      markers: {
                        if (customIcon != null)
                          Marker(
                            markerId: const MarkerId('MarkerId'),
                            position: circleCenter,
                            anchor: const Offset(0.5, 0.5),
                            icon: customIcon!,
                            consumeTapEvents: true,
                            draggable: false,
                          ),
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                        top: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: ColorManager.grey.withOpacity(0.2),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        child: ElevatedButton(
                          style: btnWhiteStyle,
                          onPressed: () {
                            Navigator.pushNamed(
                                    context, SetMasterLocationScreen.routeName)
                                .then((value) {
                              _loadMasterLocation();
                            });
                          },
                          child: Text(
                            'Set master location',
                            style: getBlackTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeighManager.semiBold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Schedule Today',
                      style: getBlackTextStyle(),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${Jiffy.now().format(pattern: 'EEEE, dd MMMM yyyy')} / 9:00 AM - 17:00 PM',
                      style: getBlackTextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: btnPrimaryStyle,
                        onPressed: _checkDistance,
                        child: Text(
                          'Check in',
                          style: getWhiteTextStyle(
                              fontWeight: FontWeighManager.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
