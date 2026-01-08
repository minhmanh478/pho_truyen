import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/uploaded_file.dart';
import '../../domain/repositories/common_repository.dart';
import '../datasources/common_remote_datasource.dart';

class CommonRepositoryImpl implements CommonRepository {
  final CommonRemoteDataSource remoteDataSource;

  CommonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UploadedFile>> uploadImage(File file) async {
    try {
      // nén ảnh
      File fileToUpload = file;
      try {
        final filePath = file.absolute.path;
        final lastIndex = filePath.lastIndexOf(RegExp(r'\.'));
        if (lastIndex > -1) {
          final targetPath = "${filePath.substring(0, lastIndex)}_out.jpg";
          final compressedXFile = await FlutterImageCompress.compressAndGetFile(
            filePath,
            targetPath,
            quality: 70,
            minWidth: 1024,
            minHeight: 1024,
          );
          if (compressedXFile != null) {
            fileToUpload = File(compressedXFile.path);
          }
        }
      } catch (e) {
        print("Compression failed: $e");
      }

      final result = await remoteDataSource.uploadImage(fileToUpload);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.error?.toString() ?? 'Có lỗi xảy ra'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
