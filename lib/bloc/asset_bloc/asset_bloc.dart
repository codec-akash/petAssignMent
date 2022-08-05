import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettest/bloc/asset_bloc/asset_state.dart';
import 'package:pettest/model/asset_model.dart';
import 'package:pettest/repo/asset_repo.dart';

part 'asset_event.dart';
// part 'asset_state.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  final AssetRepo assetRepo;

  AssetBloc({required this.assetRepo}) : super(AssetInitial()) {
    on<LoadAsset>((event, emit) async {
      await _loadAsset(event, emit);
    });
  }

  Future<void> _loadAsset(LoadAsset event, Emitter<AssetState> emit) async {
    emit(AssetLoading());
    try {
      AssetModel assetModel = await assetRepo.loadAsset();
      emit(AssetLoaded(assetModel: assetModel));
    } catch (e) {
      emit(AssetFailedError(message: e.toString()));
    }
  }
}
