class ImageInfoEntity {
  final double _width;
  final double _height;

  final String _urlRaw;
  final String _urlFull;
  final String _urlRegular;
  final String _urlSmall;
  final String _urlThumb;
  final String _urlSmallS3;

  final String _userUsername;
  final String _username;

  final String _userPpSmall;
  final String _userPpMedium;
  final String _userPpLarge;

  double get width => _width;

  double get height => _height;

  String get urlRaw => _urlRaw;

  String get urlFull => _urlFull;

  String get urlRegular => _urlRegular;

  String get urlSmall => _urlSmall;

  String get urlThumb => _urlThumb;

  String get urlSmallS3 => _urlSmallS3;

  String get userUsername => _userUsername;

  String get username => _username;

  String get userPpSmall => _userPpSmall;

  String get userPpMedium => _userPpMedium;

  String get userPpLarge => _userPpLarge;

  ImageInfoEntity(
    this._width,
    this._height,
    this._urlRaw,
    this._urlFull,
    this._urlRegular,
    this._urlSmall,
    this._urlThumb,
    this._urlSmallS3,
    this._userUsername,
    this._username,
    this._userPpSmall,
    this._userPpMedium,
    this._userPpLarge,
  );
}
