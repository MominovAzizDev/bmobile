import '../../core/client.dart';
import '../models/auth_models/home_model.dart';

class HomeRepository {
  final ApiClient client;

  HomeRepository({required this.client});

  Future<HomeResponse> fetchHome() async {
    return await client.fetchHome(); // client fetchHome() allaqachon HomeResponse qaytaradi
  }
}
