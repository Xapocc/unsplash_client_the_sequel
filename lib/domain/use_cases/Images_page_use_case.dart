import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';
import 'package:unsplash_client_the_sequel/domain/repository_interfaces/images_page_repository_interface.dart';

class ImagesPageUseCase {
  const ImagesPageUseCase(this._repository);

  final IImagesPageRepository _repository;

  IImagesPageRepository get repository => _repository;

  Future<List<ImageInfoEntity>> getImagesPage(
          {String? query, int page = 1, int perPage = 10}) =>
      _repository.getImagesPage(query: query, page: page, perPage: perPage);
}
