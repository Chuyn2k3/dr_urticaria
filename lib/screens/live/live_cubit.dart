import 'package:dio/dio.dart';
import 'package:dr_urticaria/core/data/model/create_live_payload.dart';
import 'package:dr_urticaria/core/data/model/create_live_response.dart';
import 'package:dr_urticaria/screens/live/agora_config.dart';

const token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50SWQiOjE1LCJ0b2tlblR5cGUiOjIsIm1ldGFkYXRhIjp7InVzZXJuYW1lIjoiY2h1eWVuIiwiZnVsbG5hbWUiOiJjaHV5ZW5keiIsInJvbGUiOjF9LCJpYXQiOjE3NTc1MTc5NDksImV4cCI6MTc1NzYwNDM0OX0.wTiyi9AJHcAbYiCzcNph1DwASFgnXcLlyCO1At3uVA0";

class LiveApi {
  final Dio _dio;

  LiveApi()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://hospital.huyit.lat/api/v1',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );

  /// POST /livestream
  Future<CreateLiveResponse?> createLive(
    String title,
  ) async {
    try {
      final response = await _dio.post(
        '/live',
        data: CreateLivePayload(title: title).toJson(),
      );
      return CreateLiveResponse.fromJson(response.data);
    } on Exception catch (e) {
      print("POST error: ${e}");
      return null;
    }
  }

  Future<AgoraConfig?> joinLive(
    int liveId,
    int doctorId,
    String channelName,
  ) async {
    try {
      final response = await _dio.get(
        '/live/$liveId/join',
      );
      return AgoraConfig.fromJson(response.data).copyWith(
        channelName: channelName,
        doctorId: doctorId,
        liveId: liveId
      );
    } on Exception catch (e) {
      print("POST error: ${e}");
      return null;
    }
  }

  Future<AgoraConfig?> endLive(
    int liveId
  ) async {
    try {
      await _dio.delete(
        '/live/$liveId',
      );
    } on Exception catch (e) {
      print("POST error: ${e}");
      return null;
    }
  }
}
