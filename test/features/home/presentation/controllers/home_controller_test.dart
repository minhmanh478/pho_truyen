import 'package:flutter_test/flutter_test.dart';

import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/home/domain/usecases/get_home_usecase.dart';
import 'package:pho_truyen/features/home/presentation/controllers/home_controller.dart';

// Manual Mock
class MockGetHomeUseCase implements GetHomeUseCase {
  bool shouldThrow = false;
  GetHomeResponse? responseToReturn;

  @override
  Future<GetHomeResponse> call() async {
    if (shouldThrow) {
      throw Exception('Error');
    }
    return responseToReturn!;
  }
}

void main() {
  late HomeController controller;
  late MockGetHomeUseCase mockGetHomeUseCase;

  setUp(() {
    mockGetHomeUseCase = MockGetHomeUseCase();
    controller = HomeController(getHomeUseCase: mockGetHomeUseCase);
  });

  test('getHomeData success', () async {
    final response = GetHomeResponse(
      code: 'success',
      message: 'OK',
      data: HomeData(listHome: []),
    );
    mockGetHomeUseCase.responseToReturn = response;

    final result = await controller.getHomeData();

    expect(result, response);
  });

  test('getHomeData failure', () async {
    mockGetHomeUseCase.shouldThrow = true;

    final result = await controller.getHomeData();

    expect(result, null);
  });
}
