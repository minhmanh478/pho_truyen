import 'package:pho_truyen/features/home/data/datasources/home_remote_data_source.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({HomeRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? HomeRemoteDataSourceImpl();

  @override
  Future<GetHomeResponse> getHome() async {
    return await _remoteDataSource.getHome();
  }
}
