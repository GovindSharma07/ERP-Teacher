part of 'bus_location_bloc.dart';

@immutable
sealed class BusLocationEvent {}

final class BusLocationStartEvent extends BusLocationEvent{
  final RemoteMessage _message;
  BusLocationStartEvent(this._message);
}
