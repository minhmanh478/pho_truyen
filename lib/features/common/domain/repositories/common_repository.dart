import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/uploaded_file.dart';

abstract class CommonRepository {
  Future<Either<Failure, UploadedFile>> uploadImage(File file);
}
