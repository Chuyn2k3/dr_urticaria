import 'package:dr_urticaria/core/services/medical_record_service.dart';
import 'package:dr_urticaria/models/vital_indicator_model.dart';
import 'package:dr_urticaria/models/vital_value_model.dart';

class VitalRecordItem {
  final VitalValueModel value;
  final VitalIndicatorModel indicator;
  VitalRecordItem({required this.value, required this.indicator});
}

class VitalRecordGroup {
  final VitalGroupModel group;
  final List<VitalRecordItem> items;
  VitalRecordGroup({required this.group, required this.items});
}

abstract class VitalRecordRepository {
  Future<List<VitalRecordItem>> fetchVitalItems(int medicalRecordId);
  Future<List<VitalRecordGroup>> fetchVitalGroups(int medicalRecordId);

  Future<List<VitalValueModel>> updateVitalValues({
    required int medicalRecordId,
    required Map<String, dynamic> vitalValues,
  });
}

class VitalRecordRepositoryImpl implements VitalRecordRepository {
  final MedicalRecordService service;
  VitalRecordRepositoryImpl({required this.service});

  @override
  Future<List<VitalRecordItem>> fetchVitalItems(int medicalRecordId) async {
    final valuesRes = await service.getVitalValues(medicalRecordId);
    final values = valuesRes.data;
    print(values.length);
    // Fetch indicators in parallel
    final futures = <Future<VitalRecordItem>>[];
    for (final v in values) {
      futures.add(_attachIndicator(v));
    }
    final items = await Future.wait(futures);
    return items;
  }

  Future<VitalRecordItem> _attachIndicator(VitalValueModel v) async {
    try {
      final indicatorRes = await service.getIndicator(v.vitalIndicatorId);
      final indicator = indicatorRes.data;
      print(indicator == null ? true : false);
      return VitalRecordItem(value: v, indicator: indicator!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<VitalRecordGroup>> fetchVitalGroups(int medicalRecordId) async {
    final items = await fetchVitalItems(medicalRecordId);
    final Map<int, VitalRecordGroup> grouped = {};

    for (final item in items) {
      final g = item.indicator.group;
      if (g == null) {
        // Put ungrouped in a pseudo group
        final pseudo = VitalGroupModel(
          id: -1,
          name: 'Khác',
          description: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        grouped.putIfAbsent(
            -1, () => VitalRecordGroup(group: pseudo, items: []));
        grouped[-1]!.items.add(item);
        continue;
      }
      grouped.putIfAbsent(g.id, () => VitalRecordGroup(group: g, items: []));
      grouped[g.id]?.items.add(item);
    }
    return grouped.values.toList()
      ..sort((a, b) => a.group.name.compareTo(b.group.name));
  }

  @override
  Future<List<VitalValueModel>> updateVitalValues({
    required int medicalRecordId,
    required Map<String, dynamic> vitalValues,
  }) async {
    final res = await service.updateVitalValues(medicalRecordId, vitalValues);
    return res.data;
  }
}
