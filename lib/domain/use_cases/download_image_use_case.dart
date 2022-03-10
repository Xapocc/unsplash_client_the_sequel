import 'package:unsplash_client_the_sequel/domain/entities/download_image_entity.dart';
import 'package:unsplash_client_the_sequel/domain/repository_interfaces/download_image_repository_interface.dart';

class DownloadImageUseCase {
  DownloadImageUseCase(this._repository);

  final IDownloadImageRepository _repository;

  Future<DownloadImageEntity> downloadImage(String url) => _repository.downloadImage(url);
}
