part of 'bus_location_bloc.dart';

@immutable
sealed class BusLocationState {}

final class BusLocationInitial extends BusLocationState {}

final class BusLocationStartState extends BusLocationState{
  final LatLng latLng;
  BusLocationStartState(this.latLng);
}