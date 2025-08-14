import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/counter_entity.dart';
import '../../domain/usecases/get_counter_use_case.dart';
import '../../domain/usecases/increment_counter_use_case.dart';

part 'counter_event.dart';
part 'counter_state.dart';

@injectable
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final GetCounterUseCase getCounterUseCase;
  final IncrementCounterUseCase incrementCounterUseCase;

  CounterBloc({
    required this.getCounterUseCase,
    required this.incrementCounterUseCase,
  }) : super(CounterInitial()) {
    on<LoadCounterEvent>(_onLoadCounter);
    on<IncrementCounterEvent>(_onIncrementCounter);
  }

  Future<void> _onLoadCounter(
    LoadCounterEvent event,
    Emitter<CounterState> emit,
  ) async {
    emit(CounterLoading());
    try {
      final counter = await getCounterUseCase();
      emit(CounterLoaded(counter: counter));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  Future<void> _onIncrementCounter(
    IncrementCounterEvent event,
    Emitter<CounterState> emit,
  ) async {
    final currentState = state;
    if (currentState is CounterLoaded) {
      try {
        final updatedCounter = await incrementCounterUseCase(currentState.counter);
        emit(CounterLoaded(counter: updatedCounter));
      } catch (e) {
        emit(CounterError(message: e.toString()));
      }
    }
  }
}
