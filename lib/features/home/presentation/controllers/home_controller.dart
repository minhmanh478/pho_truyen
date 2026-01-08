import 'package:get/get.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/home/domain/usecases/get_home_usecase.dart';

class HomeController extends GetxController {
  final GetHomeUseCase _getHomeUseCase;

  HomeController({GetHomeUseCase? getHomeUseCase})
    : _getHomeUseCase = getHomeUseCase ?? GetHomeUseCase();

  final Rx<GetHomeResponse?> homeData = Rx<GetHomeResponse?>(null);

  Future<GetHomeResponse?> getHomeData() async {
    try {
      final response = await _getHomeUseCase();
      homeData.value = response;
      return response;
    } catch (e) {
      // Log error or rethrow if needed
      print("Error fetching home data: $e");
      return null;
    }
  }
}
