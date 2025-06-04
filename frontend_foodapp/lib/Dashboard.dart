// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_foodapp/Cart.dart';
import 'package:frontend_foodapp/UserProfile.dart';
import 'package:frontend_foodapp/history.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'home_page.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;
  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _currentAddress = "Fetching location...";
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = "Location service off";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (!mounted) return;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (!mounted) return;
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      if (!mounted) return;
      setState(() {
        _currentAddress = "Permission denied";
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (!mounted) return;

      Placemark place = placemarks.first;
      setState(() {
        _currentAddress = "${place.locality}, ${place.subLocality}";
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentAddress = "Location fetch failed";
      });
    }
  }

  PreferredSizeWidget? _buildAppBar() {
    if (_currentIndex != 0) return null;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.location_on, color: Colors.black),
                onPressed: () async {
                  await _getLocation();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Location updated')),
                  );
                },
              ),
              SizedBox(
                width: 80,
                child: Text(
                  _currentAddress,
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(initialIndex: 3),
                ),
              );
            },
          ),
        ],
      ),
      toolbarHeight: 90,
      backgroundColor: Colors.orange,
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return CartScreen(deliveryLocation: _currentAddress);
      case 2:
        return const History();
      case 3:
        return const Userprofile();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _getBody(),
      bottomNavigationBar:
          (_currentIndex == 0 || _currentIndex == 2)
              ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.orange,
                backgroundColor: Colors.yellow,
                unselectedItemColor: Colors.black,
                elevation: 10,
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart),
                    label: 'Cart',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              )
              : null,
    );
  }
}
