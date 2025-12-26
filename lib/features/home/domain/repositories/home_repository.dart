import 'package:pho_truyen/features/home/data/models/home_model.dart';

abstract class HomeRepository {
  Future<GetHomeResponse> getHome();
}
