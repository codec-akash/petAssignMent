import 'package:pettest/model/post_model.dart';
// part of 'asset_bloc.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostFailedError extends PostState {
  final String message;
  PostFailedError({required this.message});
}

class PostLoaded extends PostState {
  final List<PostDataModel> postData;
  PostLoaded({required this.postData});
}
