import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettest/bloc/post_bloc/post_state.dart';
import 'package:pettest/model/post_model.dart';
import 'package:pettest/repo/post_repo.dart';

part "post_event.dart";

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepo postRepo;

  PostBloc({required this.postRepo}) : super(PostInitial()) {
    on<LoadPost>((event, emit) async {
      await _loadPost(event, emit);
    });
  }

  Future<void> _loadPost(LoadPost event, Emitter<PostState> emit) async {
    emit(PostLoading());
    try {
      List<PostDataModel> postModelList = await postRepo.loadPost();
      emit(PostLoaded(postData: postModelList));
    } catch (e) {
      emit(PostFailedError(message: e.toString()));
    }
  }
}
