import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/common/extensions/tracking_log_extension.dart';
import 'simple_cubit_interface.dart';
import 'simple_cubit_state.dart';

/// A simple cubit that demonstrates basic state management with loading states
/// and error handling.
@LazySingleton(as: SimpleCubitInterface)
class SimpleCubit extends SimpleCubitInterface {
  @factoryMethod
  SimpleCubit() : super(SimpleCubitState.init());

  /// Increases the counter by 1
  Future<void> increase() async {
    try {
      // Show loading state
      emit(state.copyWith(isLoading: true));

      // Simulate an async operation
      await Future.delayed(const Duration(milliseconds: 300));

      // Update state with new counter value
      emit(
        state.copyWith(
          counter: state.counter + 1,
          isLoading: false,
        ),
      );
    } catch (e, stackTrace) {
      // Handle error and update state
      final errorMessage = 'Failed to increase counter: ${e.toString()}\nStack trace: $stackTrace';
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
        ),
      );
      errorMessage.addAppTrackingLog();
    }
  }

  /// Resets the counter to 0
  Future<void> reset() async {
    try {
      // Show loading state
      emit(state.copyWith(isLoading: true));

      // Simulate an async operation
      await Future.delayed(const Duration(milliseconds: 300));

      // Reset state
      emit(
        state.copyWith(
          counter: 0,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } catch (e, stackTrace) {
      // Handle error and update state
      final errorMessage = 'Failed to reset counter: ${e.toString()}\nStack trace: $stackTrace';
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
        ),
      );
      errorMessage.addAppTrackingLog();
    }
  }

  /// Clears any error message
  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }
}
