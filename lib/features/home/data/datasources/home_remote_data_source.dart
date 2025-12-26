import 'package:pho_truyen/core/network/api_client.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<GetHomeResponse> getHome();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient _dioClient;

  HomeRemoteDataSourceImpl({DioClient? dioClient})
    : _dioClient = dioClient ?? DioClient();

  @override
  Future<GetHomeResponse> getHome() async {
    try {
      final response = await _dioClient.dio.get('/api/home/show');
      return GetHomeResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
