import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gazobeton/data/models/auth_models/home_model.dart';

part 'home_state.freezed.dart';

enum HomeStatus { idle, loading, error }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    required List<HomeCategoryModel> model,
    required HomeStatus? status,
  }) = _HomeState;

  factory HomeState.initial() {
    return HomeState(
      model: [],
      status: HomeStatus.loading,
    );
  }
}
