import 'package:equatable/equatable.dart';

abstract class LiveLocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLocationEvent extends LiveLocationEvent {}
