import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../domain/entities/home/read_by_id/res_read_by_id_entity.dart';

part 'home_remote.g.dart';

@injectable
@RestApi()
abstract class HomeRemote {
  @factoryMethod
  factory HomeRemote(@Named('baseDio') Dio dio) = _HomeRemote;

  @POST('/api/PoemAlbums/ReadByIDs')
  Future<List<ResReadByIdEntity>> readIds(@Body() dynamic body);
}
