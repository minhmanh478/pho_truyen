import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/home/data/repositories/home_repository_impl.dart';
import 'package:pho_truyen/features/home/domain/repositories/home_repository.dart';

class GetHomeUseCase {
  final HomeRepository _repository;

  GetHomeUseCase({HomeRepository? repository})
    : _repository = repository ?? HomeRepositoryImpl();

  Future<GetHomeResponse> call() async {
    return await _repository.getHome();
  }
}
