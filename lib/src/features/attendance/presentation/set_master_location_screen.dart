// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:attendance/src/common_widgets/app_bar_widget.dart';
import 'package:attendance/src/services/shared_preferences_service.dart';
import 'package:attendance/src/theme_manager/color_manager.dart';
import 'package:attendance/src/theme_manager/font_manager.dart';
import 'package:attendance/src/theme_manager/style_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetMasterLocationScreen extends StatefulWidget {
  static const String routeName = './set-master-location';
  const SetMasterLocationScreen({super.key});

  @override
  State<SetMasterLocationScreen> createState() =>
      _SetMasterLocationScreenState();
}

class _SetMasterLocationScreenState extends State<SetMasterLocationScreen> {
  double lat = 0;
  double long = 0;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng _lastMapPosition = const LatLng(45.343434, -122.545454);
  String _address = 'Fetching address...';

  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _loadMasterLocation();
  }

  Future<void> _loadMasterLocation() async {
    Map<String, double?> latLong =
        await SharedPreferenceService().getMasterLocation();

    setState(() {
      lat = latLong['latitude']!;
      long = latLong['longitude']!;
    });

    _updateCameraPosition();
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

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastMapPosition = position.target;
    });
  }

  void _onCameraIdle() {
    _getAddressFromLatLng(
        _lastMapPosition.latitude, _lastMapPosition.longitude);
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];

      log('address ${jsonEncode(place)}');

      setState(() {
        _address =
            '${place.street}, ${place.locality}, ${place.subAdministrativeArea}, ${place.postalCode}, ${place.country}';
      });
    } catch (e) {
      setState(() {
        _address = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          Column(
            children: [
              const AppBarWidget(
                title: 'Set Master Location',
              ),
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      initialCameraPosition: kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMove: _onCameraMove,
                      onCameraIdle: _onCameraIdle,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        CupertinoIcons.map_pin,
                        size: 30,
                        color: ColorManager.primary,
                      ),
                    ),
                  ),
                ],
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
                      _address,
                      style: getBlackTextStyle(),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: btnPrimaryStyle,
                        onPressed: () async {
                          await SharedPreferenceService().saveMasterLocation(
                              _lastMapPosition.latitude,
                              _lastMapPosition.longitude);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Set Location',
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
