import 'package:dr_urticaria/core/api_result.dart';
import 'package:dr_urticaria/medical_record_v2/models/acute_urticaria_record.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'acute_urticaria_state.dart';

class AcuteUrticariaCubit extends Cubit<AcuteUrticariaState> {
  // final UrticariaRepository _repository;

  AcuteUrticariaCubit() : super(AcuteUrticariaInitial());

  Future<void> submitForm(AcuteUrticariaRecord record) async {
    emit(AcuteUrticariaSubmitting());

    // final result = await _repository.submitAcuteForm(record);

    // result.when(
    //   success: (data, message) {
    print("hehe");
    emit(AcuteUrticariaSubmitted(
      formId: "",
      message: 'Bệnh án cấp tính đã được gửi thành công!',
    ));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(AcuteUrticariaError(message));
    //   },
    //   loading: () {
    //     emit(AcuteUrticariaSubmitting());
    //   },
    // );
  }

  Future<void> loadForm(String id) async {
    // emit(AcuteUrticariaLoading());

    // final result = await _repository.getAcuteForm(id);

    // result.when(
    //   success: (data, message) {
    //     emit(AcuteUrticariaLoaded(record: data));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(AcuteUrticariaError(message));
    //   },
    //   loading: () {
    //     emit(AcuteUrticariaLoading());
    //   },
    // );
  }

  Future<void> updateForm(String id, AcuteUrticariaRecord record) async {
    // emit(AcuteUrticariaSubmitting());

    // final result = await _repository.updateAcuteForm(id, record);

    // result.when(
    //   success: (data, message) {
    //     emit(AcuteUrticariaSubmitted(
    //       formId: data.id,
    //       message: message ?? 'Bệnh án đã được cập nhật thành công!',
    //     ));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(AcuteUrticariaError(message));
    //   },
    //   loading: () {
    //     emit(AcuteUrticariaSubmitting());
    //   },
    // );
  }

  Future<void> uploadImages(List<String> imagePaths, String fieldName,
      {String? formId}) async {
    // emit(AcuteUrticariaUploading());

    // final result =
    //     await _repository.uploadImages(imagePaths, fieldName, formId: formId);

    // result.when(
    //   success: (data, message) {
    //     emit(AcuteUrticariaImagesUploaded(imageUrls: data));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(AcuteUrticariaError(message));
    //   },
    //   loading: () {
    //     emit(AcuteUrticariaUploading());
    //   },
    // );
  }

  void resetState() {
    // emit(AcuteUrticariaInitial());
  }
}

extension ApiResultExtension<T> on ApiResult<T> {
  void when({
    required Function(T data, String? message) success,
    required Function(String message, int? statusCode, dynamic error) failure,
    required Function() loading,
  }) {
    if (this is ApiSuccess<T>) {
      final result = this as ApiSuccess<T>;
      success(result.data, result.message);
    } else if (this is ApiFailure<T>) {
      final result = this as ApiFailure<T>;
      failure(result.message, result.statusCode, result.error);
    } else if (this is ApiLoading<T>) {
      loading();
    }
  }
}
