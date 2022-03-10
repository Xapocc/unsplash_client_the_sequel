import 'package:unsplash_client_the_sequel/data/models/download_image_model.dart';
import 'package:unsplash_client_the_sequel/domain/entities/download_image_entity.dart';

abstract class DownloadImageMapper {
  static DownloadImageEntity map(DownloadImageModel model) {
    return DownloadImageEntity(
      model.filePath,
    );
  }
}
