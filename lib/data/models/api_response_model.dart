import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

@JsonSerializable()
class ApiResponseModel {
  final double width;
  final double height;

  final Map<String, String> urls;
  final Map<String, dynamic> user;

  String get urlRaw => urls["Raw"] ?? "";

  String get urlFull => urls["full"] ?? "";

  String get urlRegular => urls["regular"] ?? "";

  String get urlSmall => urls["small"] ?? "";

  String get urlThumb => urls["thumb"] ?? "";

  String get urlSmallS3 => urls["small_s3"] ?? "";

  String get userUsername => user["username"] ?? "no_name";

  String get username => user["name"] ?? "no_name";

  String get userPpSmall => user["profile_image"]["small"] ?? "";

  String get userPpMedium => user["profile_image"]["medium"] ?? "";

  String get userPpLarge => user["profile_image"]["large"] ?? "";

  ApiResponseModel({
    required this.width,
    required this.height,
    required this.urls,
    required this.user,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseModelToJson(this);
}
