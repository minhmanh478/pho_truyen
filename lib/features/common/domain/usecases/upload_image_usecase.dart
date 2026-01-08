import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/uploaded_file.dart';
import '../repositories/common_repository.dart';

class UploadImageUseCase {
  final CommonRepository repository;

  UploadImageUseCase(this.repository);

  Future<Either<Failure, UploadedFile>> call(File file) {
    return repository.uploadImage(file);
  }
}
