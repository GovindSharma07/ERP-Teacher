import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

part 'bus_location_event.dart';
part 'bus_location_state.dart';

class BusLocationBloc extends Bloc<BusLocationEvent, BusLocationState> {
  BusLocationBloc() : super(BusLocationInitial()) {
    on<BusLocationStartEvent>(_busLocationStartEvent);
  }

  FutureOr<void> _busLocationStartEvent(BusLocationStartEvent event, Emitter<BusLocationState> emit) {
  LatLng busLocation = LatLng(double.parse(event._message.data["lat"]), double.parse(event._message.data["lng"]));
  emit(BusLocationStartState(busLocation));
  }
}
