import 'package:attendance_app/teacher_ui/teacher_page.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/mapview.dart';

class SeeMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String studentName;

  const SeeMap({Key key, this.latitude, this.longitude, this.studentName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Set<Marker> marker = {};
    final LatLng currentPosition = LatLng(latitude, longitude);

    marker.add(
      Marker(
        markerId: MarkerId('${latitude},${longitude}'),
        position: currentPosition,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    Color colorBlue = Colors.blue[900];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: colorBlue,
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return TeacherPage();
                },
              ),
            );
          },
        ),
        title: Text(
          studentName,
          style: TextStyle(
            color: colorBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: currentPosition,
          zoom: 15,
        ),
        markers: marker,
      ),
      // HereMap(
      //   onMapCreated: onMapCreated,
      // ),
    );
  }

  // Future<void> drawDot(HereMapController hereMapController, int drawOrder,
  //     GeoCoordinates geoCoordinates) async {
  //   ByteData fileData = await rootBundle.load('assets/img/circle.png');
  //   Uint8List pixelData = fileData.buffer.asUint8List();
  //   MapImage mapImage =
  //       MapImage.withPixelDataAndImageFormat(pixelData, ImageFormat.png);
  //   MapMarker mapMarker = MapMarker(geoCoordinates, mapImage);
  //   mapMarker.drawOrder = drawOrder;
  //   hereMapController.mapScene.addMapMarker(mapMarker);
  // }

  // Future<void> drawPin(HereMapController hereMapController, int drawOrder,
  //     GeoCoordinates geoCoordinates) async {
  //   ByteData fileData = await rootBundle.load('assets/img/poi.png');
  //   Uint8List pixelData = fileData.buffer.asUint8List();
  //   MapImage mapImage =
  //       MapImage.withPixelDataAndImageFormat(pixelData, ImageFormat.png);
  //   Anchor2D anchor2d = Anchor2D.withHorizontalAndVertical(0.5, 1);
  //   MapMarker mapMarker =
  //       MapMarker.withAnchor(geoCoordinates, mapImage, anchor2d);
  //   mapMarker.drawOrder = drawOrder;
  //   hereMapController.mapScene.addMapMarker(mapMarker);
  // }

  // void onMapCreated(HereMapController hereMapController) {
  //   hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
  //       (error) {
  //     if (error != null) {
  //       print('Error : ' + error.toString());
  //       return;
  //     }
  //   });

  //   drawDot(hereMapController, 0, GeoCoordinates(latitude, longitude));
  //   drawPin(hereMapController, 1, GeoCoordinates(latitude, longitude));

  //   double distanceToEarthInMeter = 8000;
  //   hereMapController.camera.lookAtPointWithDistance(
  //       GeoCoordinates(latitude, longitude), distanceToEarthInMeter);
  // }
}
