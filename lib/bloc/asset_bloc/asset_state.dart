import 'package:pettest/model/asset_model.dart';
// part of 'asset_bloc.dart';

abstract class AssetState {}

class AssetInitial extends AssetState {}

class AssetLoading extends AssetState {}

class AssetFailedError extends AssetState {
  final String message;
  AssetFailedError({required this.message});
}

class AssetLoaded extends AssetState {
  final AssetModel assetModel;
  AssetLoaded({required this.assetModel});
}
