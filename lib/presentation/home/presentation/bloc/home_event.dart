part of 'home_bloc.dart';

/// Home Events - Presentation Layer
///
/// These events represent user actions and system events that can occur
/// in the home feature. They follow the BLoC pattern for state management.
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

/// Event to load home data
class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

/// Event to refresh home data
class RefreshHomeDataEvent extends HomeEvent {
  const RefreshHomeDataEvent();
}

/// Event to update home data
class UpdateHomeDataEvent extends HomeEvent {
  final String title;
  final String description;
  final int itemCount;

  const UpdateHomeDataEvent({
    required this.title,
    required this.description,
    required this.itemCount,
  });

  @override
  List<Object> get props => [title, description, itemCount];
}

/// Event to increment item count
class IncrementItemCountEvent extends HomeEvent {
  const IncrementItemCountEvent();
}

/// Event to decrement item count
class DecrementItemCountEvent extends HomeEvent {
  const DecrementItemCountEvent();
}
