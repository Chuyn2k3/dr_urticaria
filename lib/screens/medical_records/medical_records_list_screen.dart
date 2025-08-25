import 'package:dr_urticaria/screens/medical_records/medical_record_detail_screen%20copy.dart';
import 'package:flutter/material.dart';

class MedicalRecordItem {
  final String id;
  final String type; // 'acute', 'chronic_initial', 'chronic_followup'
  final String status; // 'completed', 'pending', 'in_progress'
  final DateTime createdDate;
  final String doctorName;
  final Map<String, dynamic> data;

  MedicalRecordItem({
    required this.id,
    required this.type,
    required this.status,
    required this.createdDate,
    required this.doctorName,
    required this.data,
  });
}

class MedicalRecordsListScreen extends StatelessWidget {
  const MedicalRecordsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = _getMockRecords();

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách bệnh án'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return _buildRecordCard(context, record);
        },
      ),
    );
  }

  Widget _buildRecordCard(BuildContext context, MedicalRecordItem record) {
    final typeInfo = _getTypeInfo(record.type);
    final statusInfo = _getStatusInfo(record.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicalRecordDetailScreen(record: record),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: typeInfo['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      typeInfo['icon'],
                      color: typeInfo['color'],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeInfo['label'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          record.data['fullName'] ?? 'Chưa có tên',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusInfo['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusInfo['icon'],
                          color: statusInfo['color'],
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusInfo['label'],
                          style: TextStyle(
                            fontSize: 12,
                            color: statusInfo['color'],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'CCCD: ${record.data['nationalId'] ?? 'Chưa có'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    record.data['phoneNumber'] ?? 'Chưa có SĐT',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.medical_services,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'BS: ${record.doctorName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(record.createdDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<MedicalRecordItem> _getMockRecords() {
    return [
      // Acute Urticaria Record
      MedicalRecordItem(
        id: '1',
        type: 'acute',
        status: 'completed',
        createdDate: DateTime.now().subtract(const Duration(days: 2)),
        doctorName: 'BS. Nguyễn Văn An',
        data: _getAcuteMockData(),
      ),
      // Chronic Initial Record
      MedicalRecordItem(
        id: '2',
        type: 'chronic_initial',
        status: 'completed',
        createdDate: DateTime.now().subtract(const Duration(days: 5)),
        doctorName: 'BS. Trần Thị Bình',
        data: _getChronicInitialMockData(),
      ),
      // Chronic Followup Record
      MedicalRecordItem(
        id: '3',
        type: 'chronic_followup',
        status: 'completed',
        createdDate: DateTime.now().subtract(const Duration(days: 1)),
        doctorName: 'BS. Lê Văn Cường',
        data: _getChronicFollowupMockData(),
      ),
      // Additional records for variety
      MedicalRecordItem(
        id: '4',
        type: 'acute',
        status: 'pending',
        createdDate: DateTime.now().subtract(const Duration(hours: 3)),
        doctorName: 'BS. Phạm Thị Dung',
        data: _getAcuteMockData2(),
      ),
    ];
  }

  Map<String, dynamic> _getAcuteMockData() {
    return {
      // Thông tin cơ bản
      'fullName': 'Nguyễn Văn Minh',
      'nationalId': '001234567890',
      'age': '28',
      'gender': '0', // Nam
      'phoneNumber': '0912345678',
      'addressArea': 'Thành thị',
      'occupation': 'Cán bộ công chức',
      'exposureHistory': 'Hóa chất',
      'recordOpenDate': '15/01/2024',
      'examinationDate': '15/01/2024',

      // Bệnh án cấp tính - phần chung
      'rashOrAngioedema': 'Cả hai',
      'firstOutbreakSinceWeeks': '3',
      'outbreakCount': '5',

      // Đợt 1
      'outbreak1StartMonth': '10',
      'outbreak1StartYear': '2023',
      'outbreak1EndMonth': '11',
      'outbreak1EndYear': '2023',
      'outbreak1TreatmentReceived': 'Có',
      'outbreak1DrugResponse': 'Giảm',
      'outbreak1DrugResponseSymptom': 'Cả hai',

      // Đợt 2
      'outbreak2StartMonth': '12',
      'outbreak2StartYear': '2023',
      'outbreak2EndMonth': '12',
      'outbreak2EndYear': '2023',
      'outbreak2TreatmentReceived': 'Có',
      'outbreak2DrugResponse': 'Khỏi hoàn toàn',
      'outbreak2DrugResponseSymptom': '',

      // Đợt 3
      'outbreak3StartMonth': '01',
      'outbreak3StartYear': '2024',
      'outbreak3EndMonth': '01',
      'outbreak3EndYear': '2024',
      'outbreak3TreatmentReceived': 'Không',
      'outbreak3DrugResponse': '',
      'outbreak3DrugResponseSymptom': '',

      // Đợt hiện tại
      'currentOutbreakStartMonth': '01',
      'currentOutbreakStartYear': '2024',
      'currentOutbreakEndMonth': '01',
      'currentOutbreakEndYear': '2024',
      'currentOutbreakWeeks': '2',
      'currentTreatmentReceived': 'Có',
      'currentDrugResponse': 'Giảm',
      'currentDrugResponseSymptom': 'Ngứa',

      // Thông tin thuốc
      'drugName': 'Cetirizine 10mg, Loratadine 10mg',
      'drugDuration': '2 tuần',
      'drugDosage': 'Cetirizine: 1 viên/ngày, Loratadine: 1 viên/ngày',

      // Sẩn phù
      'rashAppearanceTime': 'Khi có các yếu tố kích thích',
      'rashTriggerFactors': [
        'Gãi, chà xát, sau tắm',
        'Ra mồ hôi, +/- vận động'
      ],
      'rashWorseningFactors': ['Stress', 'Thức ăn'],
      'rashFoodTriggerDetail': 'Tôm, cua, các loại hải sản',
      'rashDrugTriggerDetail': '',
      'rashLocation': ['Mặt', 'Thân', 'Cánh tay'],
      'rashLocationImages': {
        'Mặt': ['/placeholder.svg?height=200&width=200'],
        'Thân': ['/placeholder.svg?height=200&width=200'],
        'Cánh tay': ['/placeholder.svg?height=200&width=200']
      },
      'rashSizeOnTreatment': '3-10mm',
      'rashSizeNoTreatment': '10-50mm',
      'rashBorder': 'Có bờ',
      'rashShape': 'Tròn/Oval',
      'rashColor': 'Đỏ hồng',
      'rashDurationOnTreatment': '1h-6h',
      'rashDurationNoTreatment': '6h-12h',
      'rashSurface': ['Không vảy', 'Không mụn nước'],
      'rashTimeOfDay': 'Tối',
      'rashCountPerDay': '21-50',
      'rashSensation': 'Ngứa',

      // Phù mạch
      'angioedemaCount': '3',
      'angioedemaLocation': ['Mắt', 'Môi'],
      'angioedemaLocationImages': {
        'Mắt': ['/placeholder.svg?height=200&width=200'],
        'Môi': ['/placeholder.svg?height=200&width=200']
      },
      'angioedemaSurface': ['Không vảy', 'Không mụn nước'],
      'angioedemaDurationOnTreatment': '6h-12h',
      'angioedemaDurationNoTreatment': '12h-24h',
      'angioedemaTimeOfDay': 'Sáng',
      'angioedemaSensation': 'Tức',

      // Yếu tố khởi phát & Tiền sử
      'triggerInfection': 'Không',
      'triggerFood': 'Có',
      'triggerDrug': 'Không',
      'triggerInsectBite': 'Không',
      'triggerOther': '',
      'personalAllergyHistory': 'Có',
      'personalDrugHistory': 'Không',
      'personalUrticariaHistory': 'Có',
      'personalOtherHistory': 'Viêm mũi dị ứng',

      // Khám thực thể
      'fever': '0',
      'feverTemperature': '',
      'pulseRate': '78',
      'bloodPressure': '120/80',

      // Chẩn đoán & Xét nghiệm
      'preliminaryDiagnosis': 'Mày đay cấp tính',
      'wbc': '7.2',
      'neu': '65',
      'crp': '2.1',
      'totalIgE': '180',
      'otherLabTests': 'Không có',
      'finalDiagnosis': 'Mày đay cấp tính do thức ăn',

      // Điều trị & Hẹn tái khám
      'antihistamineH1': 'Cetirizine 10mg 1x1',
      'corticosteroidSystemic': 'Không',
      'hospitalization': 'Không',
      'followUpDate': '22/01/2024',
    };
  }

  Map<String, dynamic> _getAcuteMockData2() {
    return {
      'fullName': 'Trần Thị Lan',
      'nationalId': '001987654321',
      'age': '35',
      'gender': '1', // Nữ
      'phoneNumber': '0987654321',
      'addressArea': 'Nông thôn',
      'occupation': 'Nông dân',
      'exposureHistory': 'Bụi',
      'recordOpenDate': '17/01/2024',
      'examinationDate': '17/01/2024',
      'rashOrAngioedema': 'Sẩn phù',
      'firstOutbreakSinceWeeks': '1',
      'currentOutbreakStartMonth': '01',
      'currentOutbreakStartYear': '2024',
      'currentOutbreakWeeks': '1',
      'rashLocation': ['Bàn tay', 'Cẳng tay'],
      'rashLocationImages': {
        'Bàn tay': ['/placeholder.svg?height=200&width=200'],
        'Cẳng tay': ['/placeholder.svg?height=200&width=200']
      },
      'finalDiagnosis': 'Mày đay cấp tính nguyên nhân chưa rõ',
    };
  }

  Map<String, dynamic> _getChronicInitialMockData() {
    return {
      // Thông tin cơ bản
      'fullName': 'Lê Thị Hoa',
      'nationalId': '001122334455',
      'age': '42',
      'gender': '1', // Nữ
      'phoneNumber': '0901234567',
      'addressArea': 'Thành thị',
      'occupation': 'Công nhân',
      'exposureHistory': 'Hóa chất',
      'recordOpenDate': '10/01/2024',
      'examinationDate': '10/01/2024',

      // Bệnh án mãn tính lần 1 - phần chung
      'rashOrAngioedema': 'Cả hai',
      'firstOutbreakSinceWeeks': '12',
      'outbreakCount': '15',

      // Các đợt bệnh (giống acute nhưng có thêm thông tin)
      'outbreak1StartMonth': '06',
      'outbreak1StartYear': '2023',
      'outbreak1EndMonth': '08',
      'outbreak1EndYear': '2023',
      'outbreak1TreatmentReceived': 'Có',
      'outbreak1DrugResponse': 'Giảm',
      'outbreak1DrugResponseSymptom': 'Ngứa',

      'outbreak2StartMonth': '09',
      'outbreak2StartYear': '2023',
      'outbreak2EndMonth': '10',
      'outbreak2EndYear': '2023',
      'outbreak2TreatmentReceived': 'Có',
      'outbreak2DrugResponse': 'Không khỏi',
      'outbreak2DrugResponseSymptom': '',

      'outbreak3StartMonth': '11',
      'outbreak3StartYear': '2023',
      'outbreak3EndMonth': '12',
      'outbreak3EndYear': '2023',
      'outbreak3TreatmentReceived': 'Có',
      'outbreak3DrugResponse': 'Giảm',
      'outbreak3DrugResponseSymptom': 'Cả hai',

      'currentOutbreakStartMonth': '12',
      'currentOutbreakStartYear': '2023',
      'currentOutbreakEndMonth': '01',
      'currentOutbreakEndYear': '2024',
      'currentOutbreakWeeks': '4',
      'currentTreatmentReceived': 'Có',
      'currentDrugResponse': 'Giảm',
      'currentDrugResponseSymptom': 'Nốt đỏ',

      // Sẩn phù (giống acute)
      'rashAppearanceTime': 'Một cách ngẫu nhiên',
      'rashTriggerFactors': [],
      'rashWorseningFactors': ['Stress', 'Chống viêm, giảm đau'],
      'rashFoodTriggerDetail': '',
      'rashDrugTriggerDetail': 'Aspirin, Ibuprofen',
      'rashLocation': ['Mặt', 'Thân', 'Cánh tay', 'Đùi'],
      'rashLocationImages': {
        'Mặt': ['/placeholder.svg?height=200&width=200'],
        'Thân': ['/placeholder.svg?height=200&width=200'],
        'Cánh tay': ['/placeholder.svg?height=200&width=200'],
        'Đùi': ['/placeholder.svg?height=200&width=200']
      },
      'rashSizeOnTreatment': '10-50mm',
      'rashSizeNoTreatment': '>50mm',
      'rashBorder': 'Có bờ',
      'rashShape': 'Dài',
      'rashColor': 'Có quầng trắng xung quanh nốt đỏ',
      'rashDurationOnTreatment': '6h-12h',
      'rashDurationNoTreatment': '12h-24h',
      'rashSurface': ['Không vảy', 'Không mụn nước', 'Có giãn mạch'],
      'rashTimeOfDay': 'Không có thời điểm cụ thể',
      'rashCountPerDay': '>50',
      'rashSensation': 'Ngứa',

      // Phù mạch
      'angioedemaCount': '8',
      'angioedemaLocation': ['Mắt', 'Môi', 'Lưỡi'],
      'angioedemaLocationImages': {
        'Mắt': ['/placeholder.svg?height=200&width=200'],
        'Môi': ['/placeholder.svg?height=200&width=200'],
        'Lưỡi': ['/placeholder.svg?height=200&width=200']
      },
      'angioedemaSurface': ['Không vảy', 'Không mụn nước'],
      'angioedemaDurationOnTreatment': '12h-24h',
      'angioedemaDurationNoTreatment': '24h-48h',
      'angioedemaTimeOfDay': 'Sáng',
      'angioedemaSensation': 'Tức',
      'emergencyVisitHistory': 'Rồi',
      'breathingDifficultyHistory': 'Có',

      // Tiền sử - Bệnh sử (mở rộng cho chronic)
      'pastOutbreakHistory':
          'Bệnh nhân có tiền sử mày đay từ năm 2020, thường xuyên tái phát 2-3 lần/năm',
      'previousTreatment': 'Có',
      'previousTreatmentDetails':
          'Đã dùng Cetirizine 10mg 1x1, Loratadine 10mg 1x1, đáp ứng một phần',
      'personalAtopyHistory': 'Có',
      'personalThyroidDiseaseHistory': 'Không rõ',
      'personalAutoimmuneHistory': 'Không',
      'personalOtherDiseaseHistory': 'Viêm mũi dị ứng, hen phế quản',
      'personalDrugFoodAllergyHistory': 'Dị ứng Aspirin, tôm cua',
      'personalAnaphylaxisHistory': 'Không',
      'familyChronicUrticariaHistory': 'Có',
      'familyAtopyHistory': 'Có',
      'familyAutoimmuneHistory': 'Không rõ',
      'familyHistoryDetail': 'Mẹ có tiền sử mày đay, chị gái có hen phế quản',

      // Khám thực thể (mở rộng)
      'fever': '0',
      'feverTemperature': '',
      'pulseRate': '82',
      'bloodPressure': '130/85',
      'organAbnormality': 'Không',
      'organAbnormalityDetail': '',
      'preliminaryDiagnosis': 'Mày đay mãn tính tự phát',

      // Kết quả test cơ bản
      'dermatographismTest': 'Dương tính',
      'fricScore': '3',
      'itchScoreNRS': '7',
      'painScoreNRS': '2',
      'burningScoreNRS': '4',

      // Test mày đay do lạnh - Temptest
      'coldUrticariaTemptest': 'Âm tính',
      'positiveTemperature': '',
      'itchScoreNRSCold': '',
      'painScoreNRSCold': '',
      'burningScoreNRSCold': '',

      // Test mày đay do lạnh - Test cục đá
      'coldUrticariaIceTest': 'Âm tính',
      'timeThreshold': '',
      'itchScoreNRSIce': '',
      'painScoreNRSIce': '',
      'burningScoreNRSIce': '',

      // Test mày đay do choline
      'cholinergicUrticariaTest': 'Âm tính',
      'lesionAppearanceTime': '',
      'itchScoreNRSCholine': '',
      'painScoreNRSCholine': '',
      'burningScoreNRSCholine': '',

      // Điểm số đánh giá
      'cusiScore': '12',
      'otherCause': 'Không xác định được',
      'uctScore': '8',
      'actScore': '15',

      // Cận lâm sàng (đầy đủ)
      'wbc': '6.8',
      'eo': '4.2',
      'ba': '0.8',
      'crp': '3.5',
      'esr': '25',
      'ft3': '4.2',
      'ft4': '12.5',
      'tsh': '2.1',
      'totalIgE': '320',
      'antiTPO': '15',
      'anaHep2': 'Âm tính',
      'depositionPattern': '',
      'thyroidUltrasound': 'Bình thường',
      'autologousSerumSkinTest': 'Dương tính',
      'whealDiameter': '8',
      'otherLabTests': 'Vitamin D: 18 ng/ml (thấp)',

      // Chẩn đoán xác định
      'finalDiagnosis': 'Mày đay mãn tính tự phát, mức độ trung bình',

      // Điều trị & Theo dõi
      'treatmentMedications':
          'Cetirizine 10mg 2x1, Montelukast 10mg 1x1 tối, Vitamin D3 1000IU 1x1',
      'followUpDate': '10/02/2024',
    };
  }

  Map<String, dynamic> _getChronicFollowupMockData() {
    return {
      // Thông tin cơ bản
      'fullName': 'Phạm Văn Đức',
      'nationalId': '001555666777',
      'age': '38',
      'gender': '0', // Nam
      'phoneNumber': '0976543210',
      'addressArea': 'Miền biển',
      'occupation': 'HS-SV',
      'exposureHistory': 'Ánh sáng',
      'recordOpenDate': '16/01/2024',
      'examinationDate': '16/01/2024',

      // Theo dõi hoạt động bệnh & kiểm soát bệnh
      'uas7OnTreatmentISS7': '8',
      'uas7OnTreatmentHSS7': '6',
      'uas7OffTreatmentISS7': '15',
      'uas7OffTreatmentHSS7': '12',
      'uctScore': '10',
      'treatmentResponse': 'Kiểm soát kém, bệnh nhẹ (UCT: <12, UAS7: 7-15)',

      // Tác dụng không mong muốn
      'sideEffectFatigue': '1',
      'sideEffectHeadache': '0',
      'sideEffectDizziness': '1',
      'sideEffectSleepy': '1',
      'sideEffectDrowsiness': '0',
      'sideEffectLossOfAppetite': '0',
      'sideEffectIndigestion': '1',
      'sideEffectAbdominalPain': '0',
      'sideEffectChestPain': '0',
      'sideEffectPalpitations': '0',
      'sideEffectOther': 'Khô miệng nhẹ',

      // Triệu chứng hiện tại
      'rashPresent': '1',
      'angioedemaPresent': '1',
      'angioedemaLocation': ['Mắt', 'Bàn tay'],
      'aas7Score': '4',
      'anaphylaxisSymptoms': 'Không có',
      'newMedicalHistory': 'Phát hiện tăng huyết áp nhẹ',

      // Kết quả test cơ bản
      'dermatographismTest': 'Dương tính',
      'fricScore': '2',
      'itchScoreNRS': '5',
      'painScoreNRS': '1',
      'burningScoreNRS': '3',

      // Test mày đay do lạnh - Temptest
      'coldUrticariaTemptest': 'Dương tính',
      'coldPositiveTemperature': '15',
      'itchScoreNRSCold': '6',
      'painScoreNRSCold': '2',
      'burningScoreNRSCold': '4',

      // Test mày đay do lạnh - Test cục đá
      'coldUrticariaIceTest': 'Dương tính',
      'coldIceTimeThreshold': '3',
      'itchScoreNRSIce': '7',
      'painScoreNRSIce': '3',
      'burningScoreNRSIce': '5',

      // Test mày đay do choline
      'cholinergicUrticariaTest': 'Âm tính',
      'cholinergicAppearanceTime': '',
      'itchScoreNRSCholine': '',
      'painScoreNRSCholine': '',
      'burningScoreNRSCholine': '',

      // Điểm số đánh giá
      'cusiScore': '8',
      'otherCause': 'Mày đay do lạnh',
      'actScore': '12',
    };
  }

  Map<String, dynamic> _getTypeInfo(String type) {
    switch (type) {
      case 'acute':
        return {
          'label': 'Cấp tính',
          'color': const Color(0xFFEF4444),
          'icon': Icons.flash_on,
        };
      case 'chronic_initial':
        return {
          'label': 'Mãn tính L1',
          'color': const Color(0xFF3B82F6),
          'icon': Icons.schedule,
        };
      case 'chronic_followup':
        return {
          'label': 'Tái khám',
          'color': const Color(0xFF10B981),
          'icon': Icons.refresh,
        };
      default:
        return {
          'label': 'Khác',
          'color': Colors.grey,
          'icon': Icons.help,
        };
    }
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case 'completed':
        return {
          'label': 'Hoàn thành',
          'color': const Color(0xFF10B981),
          'icon': Icons.check_circle,
        };
      case 'pending':
        return {
          'label': 'Chờ xử lý',
          'color': const Color(0xFFF59E0B),
          'icon': Icons.schedule,
        };
      case 'in_progress':
        return {
          'label': 'Đang xử lý',
          'color': const Color(0xFF3B82F6),
          'icon': Icons.hourglass_empty,
        };
      default:
        return {
          'label': 'Không xác định',
          'color': Colors.grey,
          'icon': Icons.help,
        };
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
