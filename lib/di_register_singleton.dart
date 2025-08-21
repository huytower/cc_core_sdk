import 'package:data/model/device/device_model.dart';
import 'package:data/model/sample/sample_model_watch_it.dart';
import 'package:data/model/sample/sample_model_watch_it_v2.dart';
import 'package:data/repositories/comment/comment_repositories.dart';

import 'core/di/inject/app_inject.dart';
import 'screen/getx/comment/get_x/comment_controller.dart';
import 'screen/getx/web/get_x/web_controller.dart';

void registerSingletonApp() {
  registerSingletonAppController();
  registerSingletonAppModel();
}

/// Model
void registerSingletonAppModel() {
  getIt.registerLazySingleton(() => SampleModelWatchItV2Notifier());
  getIt.registerLazySingleton(() => SampleModelWatchItNotifier());
  getIt.registerLazySingleton(() => DeviceModelNotifier());
}

/// Controller
void registerSingletonAppController() {
  getIt.registerLazySingleton(() => WebController());
  getIt.registerLazySingleton(() => CommentController(getIt<CommentRepository>()));
}
