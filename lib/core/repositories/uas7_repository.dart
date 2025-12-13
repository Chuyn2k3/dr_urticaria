import 'package:dr_urticaria/core/services/uas7_service.dart';
import 'package:dr_urticaria/models/uas7/uas7_daily_model.dart';

abstract class Uas7Repository {
  Future<List<Uas7DailyModel>> getDailyByPatient({
    required int patientId,
    required DateTime from,
    required DateTime to,
  });

  Future<Uas7DailyModel> updateDaily({
    required int id,
    required int itchLevel,
    required int whealLevel,
    String? note,
  });
}

class Uas7RepositoryImpl implements Uas7Repository {
  final Uas7Service service;

  Uas7RepositoryImpl({required this.service});

  String _date(DateTime d) => d.toIso8601String().split('T').first;

  @override
  Future<List<Uas7DailyModel>> getDailyByPatient({
    required int patientId,
    required DateTime from,
    required DateTime to,
  }) async {
    final res = await service.getDailyByPatient(
      patientId,
      recordDateFrom: _date(from),
      recordDateTo: _date(to),
    );
    return res.data ?? <Uas7DailyModel>[];
  }

  @override
  Future<Uas7DailyModel> updateDaily({
    required int id,
    required int itchLevel,
    required int whealLevel,
    String? note,
  }) async {
    final body = <String, dynamic>{
      'itchLevel': itchLevel,
      'whealLevel': whealLevel,
      if (note != null) 'note': note,
    };

    final res = await service.updateDaily(id, body);
    if (res.data == null) {
      throw Exception('Không nhận được dữ liệu UAS7 sau khi cập nhật');
    }
    return res.data!;
  }
}
