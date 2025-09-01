import '../../../core/exports.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repo;

  HomeBloc({required HomeRepository repo}) : _repo = repo, super(HomeState.initial()) {
    on<LoadHome>(_onLoad);
  }

  Future<void> _onLoad(LoadHome event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final response = await _repo.fetchHome();
      emit(state.copyWith(status: HomeStatus.idle, model: response.list));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }
}
