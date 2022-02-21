import 'package:unsplash_client_the_sequel/data/models/image_info_model.dart';
import 'package:unsplash_client_the_sequel/domain/entities/image_info_entity.dart';

abstract class ImageInfoMapper {
  static ImageInfoEntity map(ImageInfoModel model) {
    return ImageInfoEntity(
      model.width,
      model.height,
      model.urlRaw,
      model.urlFull,
      model.urlRegular,
      model.urlSmall,
      model.urlThumb,
      model.urlSmallS3,
      model.userUsername,
      model.username,
      model.userPpSmall,
      model.userPpMedium,
      model.userPpLarge,
    );
  }
}
