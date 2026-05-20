import 'dart:async';

import 'package:data/data/model/user/res_user.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:json_annotation/json_annotation.dart';

import '../cc_hive_box.dart';

part 'cc_app_storage.g.dart';

///
///[example update]-------------------------------------------------------------
///   CcAppStorage.instance.accessToken = "token_123";
///   CcAppStorage.instance.userRole = "admin";
///   CcAppStorage.instance.save();
///
///[example logger]-------------------------------------------------------------
///   CcAppStorage.instance.Log();
///

@JsonSerializable()
@HiveType(typeId: CcHiveBox.APP_STORAGE_TYPE_ID)
class CcAppStorage extends HiveObject {
  static late CcAppStorage instance;

  static Future<CcAppStorage?> register() async {
    Hive.registerAdapter(CcAppStorageAdapter());
    Box<CcAppStorage> box = await Hive.openBox<CcAppStorage>(
      CcHiveBox.APP_BOX_NAME,
    );
    CcAppStorage? model = box.get(CcHiveBox.keyDefault);

    /// is it existed? if not, init it
    if (model == null) {
      model = CcAppStorage();
      box.put(CcHiveBox.keyDefault, model);
    }
    instance = model;
    return model;
  }

  @HiveField(0)
  String? accessToken;

  @HiveField(1)
  String? fcmToken;

  @HiveField(2)
  String? gpsLocation;

  @HiveField(3)
  String? userRole;

  CcAppStorage({
    this.accessToken,
    this.fcmToken,
    this.gpsLocation,
    this.userRole,
  });

  ///
  ResUser? user = ResUser();
}
