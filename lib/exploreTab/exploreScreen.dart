import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'exploreModel.dart';
import 'package:el_paso_events/data/hardcoded_places.dart';

final Color mainColor = Color(0xFFF5E9DC);

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(31.7619, -106.4850); // El Paso center

  final List<ExploreModel> locations = [
    ExploreModel(
      name: 'Coldplay Concert',
      latitude: 31.7733,
      longitude: -106.5079,
      type: 'event',
      description: 'Live at Sun Bowl',
    ),
    ...restaurants,
    ...bars,
  ];

  Set<Marker> _buildMarkers() {
    return locations.map((location) {
      return Marker(
        markerId: MarkerId(location.name),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.description ?? '',
          onTap: () => _launchDirections(location),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          location.type == 'event'
              ? BitmapDescriptor.hueAzure
              : location.type == 'bar'
              ? BitmapDescriptor.hueRose
              : BitmapDescriptor.hueOrange,
        ),
      );
    }).toSet();
  }

  void _launchDirections(ExploreModel location) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open directions')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 12.0),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        markers: _buildMarkers(),
      ),
    );
  }
}
