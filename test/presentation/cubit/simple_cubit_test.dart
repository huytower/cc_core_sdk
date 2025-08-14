import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_flutter_template/presentation/sample_code/bloc_simple_page/cubit/simple/simple_cubit.dart';
import 'package:mobile_flutter_template/presentation/sample_code/bloc_simple_page/cubit/simple/simple_cubit_interface.dart';
import 'package:mobile_flutter_template/presentation/sample_code/bloc_simple_page/cubit/simple/simple_cubit_state.dart';

// Mock class for SimpleCubitInterface
class MockSimpleCubit extends MockCubit<SimpleCubitState> implements SimpleCubit {}

void main() {
  group('SimpleCubit Tests', () {
    late SimpleCubit cubit;

    setUp(() {
      cubit = SimpleCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is correct', () {
      expect(
        cubit.state,
        const SimpleCubitState(
          counter: 0,
          isLoading: false,
          errorMessage: null,
        ),
      );
    });

    group('increase()', () {
      blocTest<SimpleCubit, SimpleCubitState>(
        'emits [loading, success] when increase is called',
        build: () => cubit,
        act: (cubit) => cubit.increase(),
        expect: () => [
          // Loading state
          const SimpleCubitState(
            counter: 0,
            isLoading: true,
            errorMessage: null,
          ),
          // Success state
          const SimpleCubitState(
            counter: 1,
            isLoading: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('reset()', () {
      blocTest<SimpleCubit, SimpleCubitState>(
        'resets counter to 0',
        build: () => cubit,
        seed: () => const SimpleCubitState(
          counter: 5,
          isLoading: false,
          errorMessage: null,
        ),
        act: (cubit) => cubit.reset(),
        expect: () => [
          // Loading state
          const SimpleCubitState(
            counter: 5,
            isLoading: true,
            errorMessage: null,
          ),
          // Reset state
          const SimpleCubitState(
            counter: 0,
            isLoading: false,
            errorMessage: null,
          ),
        ],
      );
    });

    group('clearError()', () {
      blocTest<SimpleCubit, SimpleCubitState>(
        'clears error message when one exists',
        build: () => cubit,
        seed: () => const SimpleCubitState(
          counter: 0,
          isLoading: false,
          errorMessage: 'Some error',
        ),
        act: (cubit) => cubit.clearError(),
        expect: () => [
          const SimpleCubitState(
            counter: 0,
            isLoading: false,
            errorMessage: null,
          ),
        ],
      );
    });
  });

  group('SimpleCubitInterface Tests', () {
    test('SimpleCubit implements SimpleCubitInterface', () {
      final cubit = SimpleCubit();
      expect(cubit, isA<SimpleCubitInterface>());
      cubit.close();
    });

    test('MockSimpleCubit can be used as SimpleCubitInterface', () {
      final mockCubit = MockSimpleCubit();
      expect(mockCubit, isA<SimpleCubitInterface>());
    });
  });
}
