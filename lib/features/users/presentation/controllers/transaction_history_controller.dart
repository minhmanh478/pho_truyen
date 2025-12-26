import 'package:get/get.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/models/transaction_model.dart';
import 'package:pho_truyen/core/error/failures.dart';

class TransactionHistoryController extends GetxController {
  final UserRepository userRepository;

  TransactionHistoryController({required this.userRepository});

  final transactions = <TransactionModel>[].obs;
  final isLoading = false.obs;
  final offset = 0.obs;
  final limit = 20;
  final hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions({bool isRefresh = false}) async {
    if (isRefresh) {
      offset.value = 0;
      hasMore.value = true;
      transactions.clear();
    }

    if (!hasMore.value && !isRefresh) return;

    isLoading.value = true;

    final result = await userRepository.getTransactionHistory(
      offset: offset.value,
      limit: limit,
    );

    result.fold(
      (failure) {
        Get.snackbar('Error', _mapFailureToMessage(failure));
      },
      (data) {
        if (data.length < limit) {
          hasMore.value = false;
        }
        transactions.addAll(data);
        offset.value += data.length;
      },
    );

    isLoading.value = false;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return 'Cache Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
