part of 'home_bloc.dart';

/// Home States - Presentation Layer
/// 
/// These states represent the different UI states that can occur
/// in the home feature. They follow the BLoC pattern for state management.
abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

/// Initial state when the home feature is first loaded
class HomeInitial extends HomeState {}

/// Loading state when data is being fetched
class HomeLoading extends HomeState {}

/// Success state when data has been loaded successfully
class HomeLoaded extends HomeState {
  final HomeEntity homeData;

  const HomeLoaded({required this.homeData});

  @override
  List<Object> get props => [homeData];
}

/// Error state when something goes wrong
class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Refreshing state when data is being refreshed
class HomeRefreshing extends HomeState {
  final HomeEntity homeData;

  const HomeRefreshing({required this.homeData});

  @override
  List<Object> get props => [homeData];
}

/// Updating state when data is being updated
class HomeUpdating extends HomeState {
  final HomeEntity homeData;

  const HomeUpdating({required this.homeData});

  @override
  List<Object> get props => [homeData];
}
