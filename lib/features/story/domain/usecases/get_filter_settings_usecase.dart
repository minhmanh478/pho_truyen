import 'package:pho_truyen/features/story/data/models/filter_settings_model.dart';
import 'package:pho_truyen/features/story/domain/repositories/comic_repository.dart';

class GetFilterSettingsUseCase {
  final ComicRepository repository;

  GetFilterSettingsUseCase({required this.repository});

  Future<FilterSettingsModel> call() async {
    return await repository.getFilterSettings();
  }
}
