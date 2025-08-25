import 'package:dr_urticaria/medical_record_v2/models/chronic_urticaria_followup_record.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../acute_urticaria/acute_urticaria_cubit.dart';
import 'chronic_followup_state.dart';

class ChronicFollowupCubit extends Cubit<ChronicFollowupState> {
  ChronicFollowupCubit() : super(ChronicFollowupInitial());

  Future<void> submitForm(ChronicUrticariaFollowupRecord record) async {
    emit(ChronicFollowupSubmitting());

    // final result = await _repository.submitChronicFollowupForm(record);

    // result.when(
    //   success: (data, message) {
    emit(ChronicFollowupSubmitted(
      formId: "",
      message: 'Bệnh án tái khám đã được gửi thành công!',
    ));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(ChronicFollowupError(message));
    //   },
    //   loading: () {
    //     emit(ChronicFollowupSubmitting());
    //   },
    // );
  }

  Future<void> loadForm(String id) async {
    // emit(ChronicFollowupLoading());

    // final result = await _repository.getChronicFollowupForm(id);

    // result.when(
    //   success: (data, message) {
    //     emit(ChronicFollowupLoaded(record: data));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(ChronicFollowupError(message));
    //   },
    //   loading: () {
    //     emit(ChronicFollowupLoading());
    //   },
    // );
  }

  Future<void> updateForm(
      String id, ChronicUrticariaFollowupRecord record) async {
    // emit(ChronicFollowupSubmitting());

    // final result = await _repository.updateChronicFollowupForm(id, record);

    // result.when(
    //   success: (data, message) {
    //     emit(ChronicFollowupSubmitted(
    //       formId: data.id,
    //       message: message ?? 'Bệnh án đã được cập nhật thành công!',
    //     ));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(ChronicFollowupError(message));
    //   },
    //   loading: () {
    //     emit(ChronicFollowupSubmitting());
    //   },
    // );
  }

  Future<void> uploadImages(List<String> imagePaths, String fieldName,
      {String? formId}) async {
    // emit(ChronicFollowupUploading());

    // final result =
    //     await _repository.uploadImages(imagePaths, fieldName, formId: formId);

    // result.when(
    //   success: (data, message) {
    //     emit(ChronicFollowupImagesUploaded(imageUrls: data));
    //   },
    //   failure: (message, statusCode, error) {
    //     emit(ChronicFollowupError(message));
    //   },
    //   loading: () {
    //     emit(ChronicFollowupUploading());
    //   },
    // );
  }

  void resetState() {
    // emit(ChronicFollowupInitial());
  }
}
