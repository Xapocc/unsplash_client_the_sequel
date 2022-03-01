import 'package:equatable/equatable.dart';

abstract class RouterState extends Equatable{
  @override
  List<Object?> get props => [];
}

class HomeScreenRouterState extends RouterState{}

class PicturePreviewScreenRouterState extends RouterState{}