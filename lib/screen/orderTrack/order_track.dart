import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class OrderTracking extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderTracking({Key? key, required this.orderData}) : super(key: key);

  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  late GoogleMapController mapController;
  LatLng? userLocation;
  LatLng? storeLocation;
  Marker? userMarker;
  Marker? storeMarker;
  Marker? deliveryMarker;
  Polyline? routePolyline;
  Timer? timer;
  double deliveryProgress = 0.0;
  static const int deliveryDuration = 2000; // Duration in seconds for delivery
  BitmapDescriptor? deliveryIcon; // For custom delivery icon

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _fetchOrderDetails();
    _loadCustomMarker(); // Load custom marker icon
  }

  Future<void> _loadCustomMarker() async {
    deliveryIcon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(48, 48)), // Specify the size of the icon
      'images/delivery_bike.png',
    );
    // Path to your image
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> _fetchOrderDetails() async {
    // Get the user's address from the order data
    final address = widget.orderData['address'];
    final storeLat = double.parse(
        widget.orderData['storeLocation']['lat'].replaceAll(',', ''));
    final storeLng = double.parse(widget.orderData['storeLocation']['lng']);
    storeLocation = LatLng(storeLat, storeLng);

    // Get user location from the address
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      userLocation =
          LatLng(locations.first.latitude, locations.first.longitude);
    }

    // Initialize markers
    storeMarker = Marker(
      markerId: MarkerId('store'),
      position: storeLocation!,
      infoWindow: InfoWindow(title: 'Store Location'),
    );

    userMarker = Marker(
      markerId: MarkerId('user'),
      position: userLocation!,
      infoWindow: InfoWindow(title: 'User Location'),
    );

    // Draw route
    _drawRoute();

    // Start moving the delivery marker
    _startDeliveryAnimation();
    setState(() {});
  }

  void _drawRoute() {
    if (userLocation != null && storeLocation != null) {
      routePolyline = Polyline(
        polylineId: PolylineId('route'),
        points: [storeLocation!, userLocation!],
        color: Colors.blue,
        width: 4,
      );
    }
  }

  void _startDeliveryAnimation() {
    timer?.cancel();
    deliveryProgress = 0.0;

    timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (deliveryProgress < 1.0) {
        deliveryProgress += 0.005;
        double lat = storeLocation!.latitude +
            (userLocation!.latitude - storeLocation!.latitude) *
                deliveryProgress;
        double lng = storeLocation!.longitude +
            (userLocation!.longitude - storeLocation!.longitude) *
                deliveryProgress;

        deliveryMarker = Marker(
          markerId: MarkerId('delivery'),
          position: LatLng(lat, lng),
          icon: deliveryIcon!, // Use the custom icon
          infoWindow: InfoWindow(title: 'Delivery Person'),
        );

        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      body: storeLocation == null || userLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: userLocation!,
                zoom: 14,
              ),
              markers: {
                if (storeMarker != null) storeMarker!,
                if (userMarker != null) userMarker!,
                if (deliveryMarker != null) deliveryMarker!,
              },
              polylines: {
                if (routePolyline != null) routePolyline!,
              },
            ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
