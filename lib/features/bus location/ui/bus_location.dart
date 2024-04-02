import 'package:erp_teacher/features/bus%20location/bloc/bus_location_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class BusLocation extends StatefulWidget {
  const BusLocation({super.key});

  @override
  State<BusLocation> createState() => _BusLocationState();
}

class _BusLocationState extends State<BusLocation> {
  late BusLocationBloc _busLocationBloc;
  MapController? _mapController;

  @override
  void initState() {
    _mapController = MapController();
    _busLocationBloc = BusLocationBloc();
    FirebaseMessaging.onMessage.listen((message){
      _busLocationBloc.add(BusLocationStartEvent(message));
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Live Location"),
        ),
        body: BlocBuilder(
            bloc: _busLocationBloc,
            builder: (context, state) {
              if (state is BusLocationStartState) {
                return FlutterMap(
                  mapController: _mapController,
                  options:  MapOptions(
                    center: state.latLng,
                    zoom: 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(markers: [
                      Marker(point: state.latLng, child: const Icon(Icons.directions_bus_outlined,color: Colors.red,size: 30,))
                    ]),
                  ],
                );
              }
              return const Center(child: Text("Service not Started from Driver's end"));
            }));
  }
}
