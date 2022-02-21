import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';

abstract class IImagesPageRepository {
  Future<List<ImageInfoEntity>> getImagesPage({String? query, int page = 1, int perPage = 10});
}