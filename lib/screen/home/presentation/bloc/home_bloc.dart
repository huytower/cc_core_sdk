import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import '../../domain/usecases/update_home_data_usecase.dart';
import '../../domain/usecases/refresh_home_data_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

/// Home BLoC - Presentation Layer
/// 
/// This BLoC manages the state of the home feature by handling events
/// and coordinating with use cases. It follows the BLoC pattern and
/// the Single Responsibility Principle.
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  final UpdateHomeDataUseCase _updateHomeDataUseCase;
  final RefreshHomeDataUseCase _refreshHomeDataUseCase;

  HomeBloc({
    required GetHomeDataUseCase getHomeDataUseCase,
    required UpdateHomeDataUseCase updateHomeDataUseCase,
    required RefreshHomeDataUseCase refreshHomeDataUseCase,
  })  : _getHomeDataUseCase = getHomeDataUseCase,
        _updateHomeDataUseCase = updateHomeDataUseCase,
        _refreshHomeDataUseCase = refreshHomeDataUseCase,
        super(HomeInitial()) {
    
    // Register event handlers
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
    on<UpdateHomeDataEvent>(_onUpdateHomeData);
    on<IncrementItemCountEvent>(_onIncrementItemCount);
    on<DecrementItemCountEvent>(_onDecrementItemCount);
  }

  /// Handles loading home data
  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    
    try {
      final homeData = await _getHomeDataUseCase();
      emit(HomeLoaded(homeData: homeData));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  /// Handles refreshing home data
  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(HomeRefreshing(homeData: currentState.homeData));
      
      try {
        final refreshedData = await _refreshHomeDataUseCase();
        emit(HomeLoaded(homeData: refreshedData));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    }
  }

  /// Handles updating home data
  Future<void> _onUpdateHomeData(
    UpdateHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(HomeUpdating(homeData: currentState.homeData));
      
      try {
        final updatedData = currentState.homeData.copyWith(
          title: event.title,
          description: event.description,
          itemCount: event.itemCount,
          lastUpdated: DateTime.now(),
        );
        
        final result = await _updateHomeDataUseCase(updatedData);
        emit(HomeLoaded(homeData: result));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    }
  }

  /// Handles incrementing item count
  Future<void> _onIncrementItemCount(
    IncrementItemCountEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(HomeUpdating(homeData: currentState.homeData));
      
      try {
        final updatedData = currentState.homeData.copyWith(
          itemCount: currentState.homeData.itemCount + 1,
          lastUpdated: DateTime.now(),
        );
        
        final result = await _updateHomeDataUseCase(updatedData);
        emit(HomeLoaded(homeData: result));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    }
  }

  /// Handles decrementing item count
  Future<void> _onDecrementItemCount(
    DecrementItemCountEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(HomeUpdating(homeData: currentState.homeData));
      
      try {
        final newCount = (currentState.homeData.itemCount - 1).clamp(0, double.infinity).toInt();
        final updatedData = currentState.homeData.copyWith(
          itemCount: newCount,
          lastUpdated: DateTime.now(),
        );
        
        final result = await _updateHomeDataUseCase(updatedData);
        emit(HomeLoaded(homeData: result));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    }
  }
}
