import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_tracking.dart';
import '../models/service_request.dart';
import '../providers/api_service_provider.dart';
import '../utils/app_constants.dart';

class LiveTrackingMap extends ConsumerStatefulWidget {
  final String? requestId;
  final bool isProviderContext;
  const LiveTrackingMap({super.key, this.requestId, this.isProviderContext = false});

  @override
  ConsumerState<LiveTrackingMap> createState() => _LiveTrackingMapState();
}

class _LiveTrackingMapState extends ConsumerState<LiveTrackingMap> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Timer? _pollTimer;
  String? _activeRequestId;
  LocationDetails? _pickup;
  LocationDetails? _destination;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
    zoom: 12.5,
  );

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final api = ref.read(apiServiceProvider);
    String? requestId = widget.requestId;
    if (requestId == null || requestId.isEmpty) {
      if (widget.isProviderContext) {
        final res = await api.getAssignedToMeRequests(status: 'in_progress', limit: 1);
        if (!res.success || res.data == null || res.data!.isEmpty) {
          final fallback = await api.getAssignedToMeRequests(status: 'assigned', limit: 1);
          if (fallback.success && fallback.data != null && fallback.data!.isNotEmpty) {
            requestId = fallback.data!.first.id;
            _pickup = fallback.data!.first.pickupLocation;
            _destination = fallback.data!.first.destinationLocation;
          }
        } else {
          requestId = res.data!.first.id;
          _pickup = res.data!.first.pickupLocation;
          _destination = res.data!.first.destinationLocation;
        }
      } else {
        final res = await api.getMyServiceRequests(status: 'in_progress', limit: 1);
        if (!res.success || res.data == null || res.data!.isEmpty) {
          final fallback = await api.getMyServiceRequests(status: 'assigned', limit: 1);
          if (fallback.success && fallback.data != null && fallback.data!.isNotEmpty) {
            requestId = fallback.data!.first.id;
            _pickup = fallback.data!.first.pickupLocation;
            _destination = fallback.data!.first.destinationLocation;
          }
        } else {
          requestId = res.data!.first.id;
          _pickup = res.data!.first.pickupLocation;
          _destination = res.data!.first.destinationLocation;
        }
      }
    }
    if (requestId != null) {
      setState(() => _activeRequestId = requestId);
      _renderStaticMarkers();
      _startPolling();
    }
  }

  void _renderStaticMarkers() {
    final markers = <Marker>{};
    if (_pickup != null) {
      markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(_pickup!.latitude, _pickup!.longitude),
        infoWindow: const InfoWindow(title: 'Pickup'),
      ));
    }
    if (_destination != null) {
      markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(_destination!.latitude, _destination!.longitude),
        infoWindow: const InfoWindow(title: 'Destination'),
      ));
    }
    setState(() => _markers = markers);
    _fitCameraToMarkers();
  }

  void _fitCameraToMarkers() {
    if (_controller == null || _markers.isEmpty) return;
    var minLat = double.infinity, maxLat = -double.infinity;
    var minLng = double.infinity, maxLng = -double.infinity;
    for (final m in _markers) {
      minLat = m.position.latitude < minLat ? m.position.latitude : minLat;
      maxLat = m.position.latitude > maxLat ? m.position.latitude : maxLat;
      minLng = m.position.longitude < minLng ? m.position.longitude : minLng;
      maxLng = m.position.longitude > maxLng ? m.position.longitude : maxLng;
    }
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
    });
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _refreshTracks());
    _refreshTracks();
  }

  Future<void> _refreshTracks() async {
    final reqId = _activeRequestId;
    if (reqId == null) return;
    final api = ref.read(apiServiceProvider);
    final res = await api.getRequestLocationHistory(reqId, limit: 20);
    if (!mounted) return;
    if (res.success && res.data != null) {
      final items = res.data!;
      if (items.isNotEmpty) {
        final latest = items.last;
        final providerMarker = Marker(
          markerId: const MarkerId('provider'),
          position: LatLng(latest.latitude, latest.longitude),
          infoWindow: const InfoWindow(title: 'Provider'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        );
        final path = items.map((e) => LatLng(e.latitude, e.longitude)).toList();
        setState(() {
          _markers = {
            ..._markers.where((m) => m.markerId.value != 'provider'),
            providerMarker,
          };
          _polylines = {
            Polyline(polylineId: const PolylineId('history'), points: path, color: const Color(0xFF1B7B8C), width: 4),
          };
        });
        _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: providerMarker.position, zoom: 14)));
      }
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialCamera,
      markers: _markers,
      polylines: _polylines,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      onMapCreated: (c) => _controller = c,
    );
  }
}