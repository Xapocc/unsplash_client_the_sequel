import 'package:unsplash_client_the_sequel/domain/entities/download_image_entity.dart';

abstract class IDownloadImageRepository {
  Future<DownloadImageEntity> downloadImage(String url);
}