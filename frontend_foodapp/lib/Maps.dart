import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  LatLng _selectedPosition = const LatLng(
    27.7172,
    85.3240,
  ); // Default Kathmandu
  GoogleMapController? _mapController;
  String? _errorMessage;

  Future<void> _fetchAddressFromCoordinates(LatLng position) async {
    final apiKey =
        'AIzaSyCf895ueNnZLqvoeQGqVAHE3j5bonnPlLs'; // <-- Replace with your actual API key
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['results'][0]['formatted_address'];
        print('Address: $address');
      } else {
        print('Error fetching address: ${response.body}');
      }
    } catch (e) {
      print('Failed to fetch address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick a Location")),
      body:
          _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Stack(
                children: [
                  _buildMap(),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, _selectedPosition);
                      },
                      child: const Text("Confirm Location"),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildMap() {
    try {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedPosition,
          zoom: 15,
        ),
        onTap: (position) {
          setState(() {
            _selectedPosition = position;
          });
          _fetchAddressFromCoordinates(position); // Optional API usage
        },
        markers: {
          Marker(
            markerId: const MarkerId("selected"),
            position: _selectedPosition,
          ),
        },
        onMapCreated: (controller) => _mapController = controller,
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading map: $e";
      });
      return const Center(child: Text("Map could not be loaded"));
    }
  }
}
