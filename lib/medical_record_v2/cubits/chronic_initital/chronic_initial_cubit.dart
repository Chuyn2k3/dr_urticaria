import 'package:dr_urticaria/medical_record_v2/models/chronic_urticaria_initial_record.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chronic_initial_state.dart';

class ChronicInitialCubit extends Cubit<ChronicInitialState> {
  ChronicInitialCubit() : super(ChronicInitialInitial());

  Future<void> submitForm(ChronicUrticariaInitialRecord record) async {
    emit(ChronicInitialSubmitting());

    // final result = await _repository.submitChronicInitialForm(record);

    // result.when(
    //   success: (data, message) {
    emit(ChronicInitialSubmitted(
      formId: "",
      message: 'Bệnh án mãn tính lần 1 đã được gửi thành công!',
    ));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(ChronicInitialError(message));
    //   },
    //   loading: () {
    //     emit(ChronicInitialSubmitting());
    //   },
    // );
  }

  Future<void> loadForm(String id) async {
    // emit(ChronicInitialLoading());

    // final result = await _repository.getChronicInitialForm(id);

    // result.when(
    //   success: (data, message) {
    //     emit(ChronicInitialLoaded(record: data));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(ChronicInitialError(message));
    //   },
    //   loading: () {
    //     emit(ChronicInitialLoading());
    //   },
    // );
  }

  Future<void> updateForm(
      String id, ChronicUrticariaInitialRecord record) async {
    emit(ChronicInitialSubmitting());

    // final result = await _repository.updateChronicInitialForm(id, record);

    // result.when(
    //   success: (data, message) {
    //     emit(ChronicInitialSubmitted(
    //       formId: data.id,
    //       message: message ?? 'Bệnh án đã được cập nhật thành công!',
    //     ));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(ChronicInitialError(message));
    //   },
    //   loading: () {
    //     emit(ChronicInitialSubmitting());
    //   },
    // );
  }

  Future<void> uploadImages(List<String> imagePaths, String fieldName,
      {String? formId}) async {
    emit(ChronicInitialUploading());

    // final result =
    //     await _repository.uploadImages(imagePaths, fieldName, formId: formId);

    // result.when(
    //   success: (data, message) {
    //     emit(ChronicInitialImagesUploaded(imageUrls: data));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(ChronicInitialError(message));
    //   },
    //   loading: () {
    //     emit(ChronicInitialUploading());
    //   },
    // );
  }

  void resetState() {
    // emit(ChronicInitialInitial());
  }
}
