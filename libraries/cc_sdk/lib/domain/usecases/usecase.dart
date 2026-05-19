import 'package:cc_sdk/core/failure/failure.dart';
import 'package:multiple_result/multiple_result.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type, Failure>> call(Params params);
}

class NoParams {}

class Params<T> {
  final T data;

  const Params(this.data);
}
