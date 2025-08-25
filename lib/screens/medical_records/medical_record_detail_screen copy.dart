import 'package:dr_urticaria/screens/medical_records/medical_records_list_screen.dart';
import 'package:flutter/material.dart';

class MedicalRecordDetailScreen extends StatelessWidget {
  final MedicalRecordItem record;

  const MedicalRecordDetailScreen({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final typeInfo = _getTypeInfo(record.type);
    final statusInfo = _getStatusInfo(record.status);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết bệnh án'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _navigateToEditForm(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Print functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Status Header Card
            _buildStatusCard(typeInfo, statusInfo),
            const SizedBox(height: 16),

            // Patient Basic Information
            _buildInfoCard(
              'Thông tin cơ bản của bệnh nhân',
              Icons.person,
              const Color(0xFF3B82F6),
              _buildBasicInfo(),
            ),
            const SizedBox(height: 16),

            // Type-specific detailed information
            ..._buildDetailedSections(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
      Map<String, dynamic> typeInfo, Map<String, dynamic> statusInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusInfo['color'],
            statusInfo['color'].withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: statusInfo['color'].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(typeInfo['icon'], color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Icon(statusInfo['icon'], color: Colors.white, size: 32),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${typeInfo['label']} - ${statusInfo['label']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Cập nhật: ${_formatDateTime(record.createdDate)}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  List<Widget> _buildBasicInfo() {
    return [
      _buildInfoRow('Họ và tên', record.data['fullName'] ?? ''),
      _buildInfoRow('Số căn cước công dân', record.data['nationalId'] ?? ''),
      _buildInfoRow('Tuổi', record.data['age'] ?? ''),
      _buildInfoRow('Giới tính', record.data['gender'] == '0' ? 'Nam' : 'Nữ'),
      _buildInfoRow('Số điện thoại', record.data['phoneNumber'] ?? ''),
      _buildInfoRow('Khu vực sinh sống', record.data['addressArea'] ?? ''),
      _buildInfoRow('Nghề nghiệp', record.data['occupation'] ?? ''),
      _buildInfoRow('Tiền sử tiếp xúc', record.data['exposureHistory'] ?? ''),
      _buildInfoRow('Ngày mở hồ sơ bệnh án',
          record.data['recordOpenDate'] ?? _formatDate(record.createdDate)),
      _buildInfoRow('Ngày khám bệnh',
          record.data['examinationDate'] ?? _formatDate(record.createdDate)),
      _buildInfoRow('Bác sĩ điều trị', record.doctorName),
    ];
  }

  List<Widget> _buildDetailedSections() {
    switch (record.type) {
      case 'acute':
        return _buildAcuteUrticariaDetails();
      case 'chronic_initial':
        return _buildChronicInitialDetails();
      case 'chronic_followup':
        return _buildChronicFollowupDetails();
      default:
        return [];
    }
  }

  List<Widget> _buildAcuteUrticariaDetails() {
    return [
      // Bệnh án cấp tính - phần chung
      _buildInfoCard(
        'Bệnh án cấp tính - phần chung',
        Icons.flash_on,
        const Color(0xFFEF4444),
        [
          _buildInfoRow(
              'Loại tổn thương', record.data['rashOrAngioedema'] ?? ''),
          _buildInfoRow('Lần đầu tổn thương từ bao nhiêu tuần',
              record.data['firstOutbreakSinceWeeks'] ?? ''),
          _buildInfoRow('Số đợt bị mày đay (≥ 2 lần/tuần)',
              record.data['outbreakCount'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Đợt 1
      if (record.data['outbreak1StartYear'] != null)
        _buildInfoCard(
          'Đợt 1',
          Icons.timeline,
          const Color(0xFF3B82F6),
          [
            _buildInfoRow('Từ tháng', record.data['outbreak1StartMonth'] ?? ''),
            _buildInfoRow('Năm', record.data['outbreak1StartYear'] ?? ''),
            _buildInfoRow('Đến tháng', record.data['outbreak1EndMonth'] ?? ''),
            _buildInfoRow('Năm', record.data['outbreak1EndYear'] ?? ''),
            _buildInfoRow('Có điều trị trong đợt hay không',
                record.data['outbreak1TreatmentReceived'] ?? ''),
            _buildInfoRow(
                'Đáp ứng điều trị', record.data['outbreak1DrugResponse'] ?? ''),
            _buildInfoRow('Triệu chứng giảm/nặng lên',
                record.data['outbreak1DrugResponseSymptom'] ?? ''),
          ],
        ),
      const SizedBox(height: 16),

      // Đợt 2
      if (record.data['outbreak2StartYear'] != null)
        _buildInfoCard(
          'Đợt 2',
          Icons.timeline,
          const Color(0xFFF59E0B),
          [
            _buildInfoRow('Từ tháng', record.data['outbreak2StartMonth'] ?? ''),
            _buildInfoRow('Năm', record.data['outbreak2StartYear'] ?? ''),
            _buildInfoRow('Đến tháng', record.data['outbreak2EndMonth'] ?? ''),
            _buildInfoRow('Năm', record.data['outbreak2EndYear'] ?? ''),
            _buildInfoRow('Có điều trị trong đợt hay không',
                record.data['outbreak2TreatmentReceived'] ?? ''),
            _buildInfoRow(
                'Đáp ứng điều trị', record.data['outbreak2DrugResponse'] ?? ''),
            _buildInfoRow('Triệu chứng giảm/nặng lên',
                record.data['outbreak2DrugResponseSymptom'] ?? ''),
          ],
        ),
      const SizedBox(height: 16),

      // Đợt 3
      if (record.data['outbreak3StartYear'] != null)
        _buildInfoCard(
          'Đợt 3',
          Icons.timeline,
          const Color(0xFF10B981),
          [
            _buildInfoRow('Từ tháng', record.data['outbreak3StartMonth'] ?? ''),
            _buildInfoRow('Năm', record.data['outbreak3StartYear'] ?? ''),
            _buildInfoRow('Đến tháng', record.data['outbreak3EndMonth'] ?? ''),
            _buildInfoRow('Năm', record.data['outbreak3EndYear'] ?? ''),
            _buildInfoRow('Có điều trị trong đợt hay không',
                record.data['outbreak3TreatmentReceived'] ?? ''),
            _buildInfoRow(
                'Đáp ứng điều trị', record.data['outbreak3DrugResponse'] ?? ''),
            _buildInfoRow('Triệu chứng giảm/nặng lên',
                record.data['outbreak3DrugResponseSymptom'] ?? ''),
          ],
        ),
      const SizedBox(height: 16),

      // Đợt hiện tại
      _buildInfoCard(
        'Đợt hiện tại',
        Icons.schedule,
        const Color(0xFFEF4444),
        [
          _buildInfoRow(
              'Từ tháng', record.data['currentOutbreakStartMonth'] ?? ''),
          _buildInfoRow('Năm', record.data['currentOutbreakStartYear'] ?? ''),
          _buildInfoRow(
              'Đến tháng', record.data['currentOutbreakEndMonth'] ?? ''),
          _buildInfoRow('Năm', record.data['currentOutbreakEndYear'] ?? ''),
          _buildInfoRow('Số tuần (tự động tính)',
              record.data['currentOutbreakWeeks'] ?? ''),
          _buildInfoRow('Có điều trị trong đợt hay không',
              record.data['currentTreatmentReceived'] ?? ''),
          _buildInfoRow(
              'Đáp ứng điều trị', record.data['currentDrugResponse'] ?? ''),
          _buildInfoRow('Triệu chứng giảm/nặng lên',
              record.data['currentDrugResponseSymptom'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Thông tin thuốc đã sử dụng
      _buildInfoCard(
        'Thông tin thuốc đã sử dụng',
        Icons.medication,
        const Color(0xFF6366F1),
        [
          _buildInfoRow('Tên thuốc đã dùng', record.data['drugName'] ?? ''),
          _buildInfoRow(
              'Thời gian dùng thuốc', record.data['drugDuration'] ?? ''),
          _buildInfoRow('Liều dùng thuốc', record.data['drugDosage'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Sẩn phù
      _buildInfoCard(
        'Sẩn phù',
        Icons.healing,
        const Color(0xFFEF4444),
        [
          _buildInfoRow('Nốt đỏ xuất hiện khi nào?',
              record.data['rashAppearanceTime'] ?? ''),
          _buildInfoRow('Các yếu tố kích thích',
              _formatList(record.data['rashTriggerFactors'])),
          _buildInfoRow('Yếu tố làm nặng bệnh',
              _formatList(record.data['rashWorseningFactors'])),
          _buildInfoRow('Chi tiết thức ăn gây nặng bệnh',
              record.data['rashFoodTriggerDetail'] ?? ''),
          _buildInfoRow('Chi tiết thuốc gây nặng bệnh',
              record.data['rashDrugTriggerDetail'] ?? ''),
          _buildInfoRow(
              'Vị trí nốt đỏ', _formatList(record.data['rashLocation'])),
          // Hiển thị ảnh nếu có
          if (record.data['rashLocationImages'] != null)
            _buildImageGallery(
                'Ảnh vị trí nốt đỏ', record.data['rashLocationImages']),
          _buildInfoRow('Kích thước nốt đỏ khi dùng thuốc',
              record.data['rashSizeOnTreatment'] ?? ''),
          _buildInfoRow('Kích thước nốt đỏ khi không dùng thuốc',
              record.data['rashSizeNoTreatment'] ?? ''),
          _buildInfoRow('Ranh giới nốt đỏ', record.data['rashBorder'] ?? ''),
          _buildInfoRow('Hình dạng', record.data['rashShape'] ?? ''),
          _buildInfoRow('Màu sắc', record.data['rashColor'] ?? ''),
          _buildInfoRow('Thời gian tồn tại khi dùng thuốc',
              record.data['rashDurationOnTreatment'] ?? ''),
          _buildInfoRow('Thời gian tồn tại khi không dùng thuốc',
              record.data['rashDurationNoTreatment'] ?? ''),
          _buildInfoRow(
              'Đặc điểm bề mặt', _formatList(record.data['rashSurface'])),
          _buildInfoRow('Thời điểm xuất hiện nốt đỏ trong ngày',
              record.data['rashTimeOfDay'] ?? ''),
          _buildInfoRow('Số lượng nốt đỏ trung bình/ngày',
              record.data['rashCountPerDay'] ?? ''),
          _buildInfoRow(
              'Cảm giác tại vị trí nốt đỏ', record.data['rashSensation'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Phù mạch
      _buildInfoCard(
        'Phù mạch',
        Icons.face,
        const Color(0xFFEF4444),
        [
          _buildInfoRow('Số lần bị sưng phù từ trước đến nay',
              record.data['angioedemaCount'] ?? ''),
          _buildInfoRow('Vị trí sưng phù',
              _formatList(record.data['angioedemaLocation'])),
          // Hiển thị ảnh phù mạch nếu có
          if (record.data['angioedemaLocationImages'] != null)
            _buildImageGallery(
                'Ảnh vị trí phù mạch', record.data['angioedemaLocationImages']),
          _buildInfoRow(
              'Đặc điểm bề mặt', _formatList(record.data['angioedemaSurface'])),
          _buildInfoRow('Thời gian tồn tại khi dùng thuốc',
              record.data['angioedemaDurationOnTreatment'] ?? ''),
          _buildInfoRow('Thời gian tồn tại khi không dùng thuốc',
              record.data['angioedemaDurationNoTreatment'] ?? ''),
          _buildInfoRow('Thời điểm xuất hiện sưng phù trong ngày',
              record.data['angioedemaTimeOfDay'] ?? ''),
          _buildInfoRow('Cảm giác tại vị trí sưng phù',
              record.data['angioedemaSensation'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Yếu tố khởi phát & Tiền sử
      _buildInfoCard(
        'Yếu tố khởi phát & Tiền sử',
        Icons.warning,
        const Color(0xFFF59E0B),
        [
          _buildSectionTitle('Yếu tố khởi phát'),
          _buildInfoRow(
              'Triệu chứng nhiễm trùng', record.data['triggerInfection'] ?? ''),
          _buildInfoRow('Thức ăn', record.data['triggerFood'] ?? ''),
          _buildInfoRow('Thuốc', record.data['triggerDrug'] ?? ''),
          _buildInfoRow(
              'Côn trùng đốt', record.data['triggerInsectBite'] ?? ''),
          _buildInfoRow('Khác (ghi rõ)', record.data['triggerOther'] ?? ''),
          const SizedBox(height: 16),
          _buildSectionTitle('Tiền sử bản thân'),
          _buildInfoRow(
              'Tiền sử dị ứng', record.data['personalAllergyHistory'] ?? ''),
          _buildInfoRow(
              'Tiền sử dị ứng thuốc', record.data['personalDrugHistory'] ?? ''),
          _buildInfoRow('Tiền sử mắc mày đay',
              record.data['personalUrticariaHistory'] ?? ''),
          _buildInfoRow('Tiền sử bệnh khác (ghi rõ)',
              record.data['personalOtherHistory'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Khám thực thể
      _buildInfoCard(
        'Khám thực thể',
        Icons.monitor_heart,
        const Color(0xFF8B5CF6),
        [
          _buildInfoRow('Sốt', record.data['fever'] == '1' ? 'Có' : 'Không'),
          if (record.data['fever'] == '1')
            _buildInfoRow(
                'Nhiệt độ (°C)', record.data['feverTemperature'] ?? ''),
          _buildInfoRow('Mạch (lần/phút)', record.data['pulseRate'] ?? ''),
          _buildInfoRow('Huyết áp (mmHg)', record.data['bloodPressure'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Chẩn đoán & Xét nghiệm
      _buildInfoCard(
        'Chẩn đoán & Xét nghiệm',
        Icons.science,
        const Color(0xFF10B981),
        [
          _buildInfoRow(
              'Chẩn đoán sơ bộ', record.data['preliminaryDiagnosis'] ?? ''),
          _buildInfoRow('WBC (x10³/μL)', record.data['wbc'] ?? ''),
          _buildInfoRow('NEU (%)', record.data['neu'] ?? ''),
          _buildInfoRow('CRP (mg/L)', record.data['crp'] ?? ''),
          _buildInfoRow('Total IgE (IU/mL)', record.data['totalIgE'] ?? ''),
          _buildInfoRow('Xét nghiệm khác', record.data['otherLabTests'] ?? ''),
          _buildInfoRow(
              'Chẩn đoán xác định', record.data['finalDiagnosis'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Điều trị & Hẹn tái khám
      _buildInfoCard(
        'Điều trị & Hẹn tái khám',
        Icons.medication,
        const Color(0xFF6366F1),
        [
          _buildInfoRow(
              'Antihistamine H1', record.data['antihistamineH1'] ?? ''),
          _buildInfoRow('Corticosteroid toàn thân',
              record.data['corticosteroidSystemic'] ?? ''),
          _buildInfoRow('Nhập viện', record.data['hospitalization'] ?? ''),
          _buildInfoRow('Hẹn tái khám', record.data['followUpDate'] ?? ''),
        ],
      ),
    ];
  }

  List<Widget> _buildChronicInitialDetails() {
    return [
      // Bệnh án mãn tính lần 1 - phần chung
      _buildInfoCard(
        'Bệnh án mãn tính lần 1 - phần chung',
        Icons.schedule,
        const Color(0xFF3B82F6),
        [
          _buildInfoRow(
              'Loại tổn thương', record.data['rashOrAngioedema'] ?? ''),
          _buildInfoRow('Lần đầu tổn thương từ bao nhiêu tuần',
              record.data['firstOutbreakSinceWeeks'] ?? ''),
          _buildInfoRow('Số đợt bị mày đay (≥ 2 lần/tuần)',
              record.data['outbreakCount'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Lịch sử các đợt bệnh chi tiết
      _buildInfoCard(
        'Lịch sử các đợt bệnh chi tiết',
        Icons.history,
        const Color(0xFF8B5CF6),
        [
          // Đợt 1
          if (record.data['outbreak1StartYear'] != null) ...[
            _buildSectionTitle('Đợt 1'),
            _buildInfoRow('Từ tháng/năm',
                '${record.data['outbreak1StartMonth'] ?? ''}/${record.data['outbreak1StartYear'] ?? ''}'),
            _buildInfoRow('Đến tháng/năm',
                '${record.data['outbreak1EndMonth'] ?? ''}/${record.data['outbreak1EndYear'] ?? ''}'),
            _buildInfoRow('Có điều trị trong đợt hay không',
                record.data['outbreak1TreatmentReceived'] ?? ''),
            _buildInfoRow(
                'Đáp ứng điều trị', record.data['outbreak1DrugResponse'] ?? ''),
            _buildInfoRow('Triệu chứng giảm/nặng lên',
                record.data['outbreak1DrugResponseSymptom'] ?? ''),
            const SizedBox(height: 12),
          ],

          // Đợt 2
          if (record.data['outbreak2StartYear'] != null) ...[
            _buildSectionTitle('Đợt 2'),
            _buildInfoRow('Từ tháng/năm',
                '${record.data['outbreak2StartMonth'] ?? ''}/${record.data['outbreak2StartYear'] ?? ''}'),
            _buildInfoRow('Đến tháng/năm',
                '${record.data['outbreak2EndMonth'] ?? ''}/${record.data['outbreak2EndYear'] ?? ''}'),
            _buildInfoRow('Có điều trị trong đợt hay không',
                record.data['outbreak2TreatmentReceived'] ?? ''),
            _buildInfoRow(
                'Đáp ứng điều trị', record.data['outbreak2DrugResponse'] ?? ''),
            _buildInfoRow('Triệu chứng giảm/nặng lên',
                record.data['outbreak2DrugResponseSymptom'] ?? ''),
            const SizedBox(height: 12),
          ],

          // Đợt 3
          if (record.data['outbreak3StartYear'] != null) ...[
            _buildSectionTitle('Đợt 3'),
            _buildInfoRow('Từ tháng/năm',
                '${record.data['outbreak3StartMonth'] ?? ''}/${record.data['outbreak3StartYear'] ?? ''}'),
            _buildInfoRow('Đến tháng/năm',
                '${record.data['outbreak3EndMonth'] ?? ''}/${record.data['outbreak3EndYear'] ?? ''}'),
            _buildInfoRow('Có điều trị trong đợt hay không',
                record.data['outbreak3TreatmentReceived'] ?? ''),
            _buildInfoRow(
                'Đáp ứng điều trị', record.data['outbreak3DrugResponse'] ?? ''),
            _buildInfoRow('Triệu chứng giảm/nặng lên',
                record.data['outbreak3DrugResponseSymptom'] ?? ''),
            const SizedBox(height: 12),
          ],

          // Đợt hiện tại
          _buildSectionTitle('Đợt hiện tại'),
          _buildInfoRow('Từ tháng/năm',
              '${record.data['currentOutbreakStartMonth'] ?? ''}/${record.data['currentOutbreakStartYear'] ?? ''}'),
          _buildInfoRow('Đến tháng/năm',
              '${record.data['currentOutbreakEndMonth'] ?? ''}/${record.data['currentOutbreakEndYear'] ?? ''}'),
          _buildInfoRow('Số tuần (tự động tính)',
              record.data['currentOutbreakWeeks'] ?? ''),
          _buildInfoRow('Có điều trị trong đợt hay không',
              record.data['currentTreatmentReceived'] ?? ''),
          _buildInfoRow(
              'Đáp ứng điều trị', record.data['currentDrugResponse'] ?? ''),
          _buildInfoRow('Triệu chứng giảm/nặng lên',
              record.data['currentDrugResponseSymptom'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Sẩn phù (giống acute)
      _buildInfoCard(
        'Sẩn phù',
        Icons.healing,
        const Color(0xFF3B82F6),
        [
          _buildInfoRow('Nốt đỏ xuất hiện khi nào?',
              record.data['rashAppearanceTime'] ?? ''),
          _buildInfoRow('Các yếu tố kích thích',
              _formatList(record.data['rashTriggerFactors'])),
          _buildInfoRow('Yếu tố làm nặng bệnh',
              _formatList(record.data['rashWorseningFactors'])),
          _buildInfoRow('Chi tiết thức ăn gây nặng bệnh',
              record.data['rashFoodTriggerDetail'] ?? ''),
          _buildInfoRow('Chi tiết thuốc gây nặng bệnh',
              record.data['rashDrugTriggerDetail'] ?? ''),
          _buildInfoRow(
              'Vị trí nốt đỏ', _formatList(record.data['rashLocation'])),
          // Hiển thị ảnh nếu có
          if (record.data['rashLocationImages'] != null)
            _buildImageGallery(
                'Ảnh vị trí nốt đỏ', record.data['rashLocationImages']),
          _buildInfoRow('Kích thước nốt đỏ khi dùng thuốc',
              record.data['rashSizeOnTreatment'] ?? ''),
          _buildInfoRow('Kích thước nốt đỏ khi không dùng thuốc',
              record.data['rashSizeNoTreatment'] ?? ''),
          _buildInfoRow('Ranh giới nốt đỏ', record.data['rashBorder'] ?? ''),
          _buildInfoRow('Hình dạng', record.data['rashShape'] ?? ''),
          _buildInfoRow('Màu sắc', record.data['rashColor'] ?? ''),
          _buildInfoRow('Thời gian tồn tại khi dùng thuốc',
              record.data['rashDurationOnTreatment'] ?? ''),
          _buildInfoRow('Thời gian tồn tại khi không dùng thuốc',
              record.data['rashDurationNoTreatment'] ?? ''),
          _buildInfoRow(
              'Đặc điểm bề mặt', _formatList(record.data['rashSurface'])),
          _buildInfoRow('Thời điểm xuất hiện nốt đỏ trong ngày',
              record.data['rashTimeOfDay'] ?? ''),
          _buildInfoRow('Số lượng nốt đỏ trung bình/ngày',
              record.data['rashCountPerDay'] ?? ''),
          _buildInfoRow(
              'Cảm giác tại vị trí nốt đỏ', record.data['rashSensation'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Phù mạch (giống acute)
      _buildInfoCard(
        'Phù mạch',
        Icons.face,
        const Color(0xFF3B82F6),
        [
          _buildInfoRow('Số lần bị sưng phù từ trước đến nay',
              record.data['angioedemaCount'] ?? ''),
          _buildInfoRow('Vị trí sưng phù',
              _formatList(record.data['angioedemaLocation'])),
          // Hiển thị ảnh phù mạch nếu có
          if (record.data['angioedemaLocationImages'] != null)
            _buildImageGallery(
                'Ảnh vị trí phù mạch', record.data['angioedemaLocationImages']),
          _buildInfoRow(
              'Đặc điểm bề mặt', _formatList(record.data['angioedemaSurface'])),
          _buildInfoRow('Thời gian tồn tại khi dùng thuốc',
              record.data['angioedemaDurationOnTreatment'] ?? ''),
          _buildInfoRow('Thời gian tồn tại khi không dùng thuốc',
              record.data['angioedemaDurationNoTreatment'] ?? ''),
          _buildInfoRow('Thời điểm xuất hiện sưng phù trong ngày',
              record.data['angioedemaTimeOfDay'] ?? ''),
          _buildInfoRow('Cảm giác tại vị trí sưng phù',
              record.data['angioedemaSensation'] ?? ''),
          const SizedBox(height: 16),
          _buildInfoRow('Từng khám cấp cứu/nằm viện',
              record.data['emergencyVisitHistory'] ?? ''),
          _buildInfoRow('Từng khó thở do bệnh',
              record.data['breathingDifficultyHistory'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Tiền sử - Bệnh sử (mở rộng cho chronic)
      _buildInfoCard(
        'Tiền sử - Bệnh sử',
        Icons.history_edu,
        const Color(0xFF8B5CF6),
        [
          _buildInfoRow('Bệnh sử các đợt bệnh trước đây',
              record.data['pastOutbreakHistory'] ?? ''),
          _buildInfoRow('Đã từng điều trị trước đó',
              record.data['previousTreatment'] ?? ''),
          _buildInfoRow(
              'Chi tiết thuốc, liều, thời gian, tuân thủ, đáp ứng điều trị',
              record.data['previousTreatmentDetails'] ?? ''),
          const SizedBox(height: 16),
          _buildSectionTitle('Tiền sử cá nhân'),
          _buildInfoRow('Tiền sử mắc bệnh lý cơ địa (cá nhân)',
              record.data['personalAtopyHistory'] ?? ''),
          _buildInfoRow('Tiền sử mắc bệnh tuyến giáp',
              record.data['personalThyroidDiseaseHistory'] ?? ''),
          _buildInfoRow('Tiền sử mắc bệnh tự miễn',
              record.data['personalAutoimmuneHistory'] ?? ''),
          _buildInfoRow('Tiền sử mắc bệnh lý khác',
              record.data['personalOtherDiseaseHistory'] ?? ''),
          _buildInfoRow('Tiền sử dị ứng thuốc hoặc thức ăn',
              record.data['personalDrugFoodAllergyHistory'] ?? ''),
          _buildInfoRow('Tiền sử phản vệ',
              record.data['personalAnaphylaxisHistory'] ?? ''),
          const SizedBox(height: 16),
          _buildSectionTitle('Tiền sử gia đình'),
          _buildInfoRow('Tiền sử gia đình mắc mày đay mạn tính',
              record.data['familyChronicUrticariaHistory'] ?? ''),
          _buildInfoRow('Tiền sử gia đình mắc bệnh lý cơ địa',
              record.data['familyAtopyHistory'] ?? ''),
          _buildInfoRow('Tiền sử gia đình mắc bệnh tự miễn',
              record.data['familyAutoimmuneHistory'] ?? ''),
          _buildInfoRow('Chi tiết về bệnh của thành viên gia đình (nếu có)',
              record.data['familyHistoryDetail'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Khám thực thể (mở rộng cho chronic)
      _buildInfoCard(
        'Khám thực thể',
        Icons.monitor_heart,
        const Color(0xFF8B5CF6),
        [
          _buildInfoRow(
              'Có sốt hay không', record.data['fever'] == '1' ? 'Có' : 'Không'),
          if (record.data['fever'] == '1')
            _buildInfoRow('Nhiệt độ cơ thể khi sốt (°C)',
                record.data['feverTemperature'] ?? ''),
          _buildInfoRow('Mạch (lần/phút)', record.data['pulseRate'] ?? ''),
          _buildInfoRow('Huyết áp (mmHg)', record.data['bloodPressure'] ?? ''),
          _buildInfoRow('Có bất thường cơ quan khác hay không',
              record.data['organAbnormality'] ?? ''),
          _buildInfoRow('Mô tả chi tiết bất thường cơ quan',
              record.data['organAbnormalityDetail'] ?? ''),
          _buildInfoRow(
              'Chẩn đoán sơ bộ', record.data['preliminaryDiagnosis'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Kết quả test cơ bản
      _buildInfoCard(
        'Kết quả test cơ bản',
        Icons.science,
        const Color(0xFF10B981),
        [
          _buildInfoRow('Kết quả da vẽ nổi (Dermatographism)',
              record.data['dermatographismTest'] ?? ''),
          _buildInfoRow('Điểm Fric', record.data['fricScore'] ?? ''),
          _buildInfoRow('Điểm ngứa NRS', record.data['itchScoreNRS'] ?? ''),
          _buildInfoRow('Điểm đau NRS', record.data['painScoreNRS'] ?? ''),
          _buildInfoRow(
              'Điểm bỏng rát NRS', record.data['burningScoreNRS'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Test mày đay do lạnh - Temptest
      _buildInfoCard(
        'Mày đay do lạnh - Temptest',
        Icons.ac_unit,
        const Color(0xFF06B6D4),
        [
          _buildInfoRow(
              'Kết quả Temptest', record.data['coldUrticariaTemptest'] ?? ''),
          _buildInfoRow('Vùng nhiệt độ dương tính (°C)',
              record.data['positiveTemperature'] ?? ''),
          _buildInfoRow('Điểm ngứa NRS (khi Temptest)',
              record.data['itchScoreNRSCold'] ?? ''),
          _buildInfoRow('Điểm đau NRS (khi Temptest)',
              record.data['painScoreNRSCold'] ?? ''),
          _buildInfoRow('Điểm bỏng rát NRS (khi Temptest)',
              record.data['burningScoreNRSCold'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Test mày đay do lạnh - Test cục đá
      _buildInfoCard(
        'Mày đay do lạnh - Test cục đá',
        Icons.ac_unit,
        const Color(0xFF06B6D4),
        [
          _buildInfoRow(
              'Kết quả Test cục đá', record.data['coldUrticariaIceTest'] ?? ''),
          _buildInfoRow(
              'Ngưỡng thời gian (phút)', record.data['timeThreshold'] ?? ''),
          _buildInfoRow('Điểm ngứa NRS (khi Test cục đá)',
              record.data['itchScoreNRSIce'] ?? ''),
          _buildInfoRow('Điểm đau NRS (khi Test cục đá)',
              record.data['painScoreNRSIce'] ?? ''),
          _buildInfoRow('Điểm bỏng rát NRS (khi Test cục đá)',
              record.data['burningScoreNRSIce'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Test mày đay do choline
      _buildInfoCard(
        'Mày đay do choline',
        Icons.fitness_center,
        const Color(0xFFEF4444),
        [
          _buildInfoRow('Kết quả test choline',
              record.data['cholinergicUrticariaTest'] ?? ''),
          _buildInfoRow('Thời gian xuất hiện tổn thương (phút)',
              record.data['lesionAppearanceTime'] ?? ''),
          _buildInfoRow('Điểm ngứa NRS (khi test choline)',
              record.data['itchScoreNRSCholine'] ?? ''),
          _buildInfoRow('Điểm đau NRS (khi test choline)',
              record.data['painScoreNRSCholine'] ?? ''),
          _buildInfoRow('Điểm bỏng rát NRS (khi test choline)',
              record.data['burningScoreNRSCholine'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Điểm số đánh giá
      _buildInfoCard(
        'Điểm số đánh giá',
        Icons.assessment,
        const Color(0xFF8B5CF6),
        [
          _buildInfoRow(
              'Mức độ hoạt động bệnh CUSI', record.data['cusiScore'] ?? ''),
          _buildInfoRow('Căn nguyên khác', record.data['otherCause'] ?? ''),
          _buildInfoRow(
              'Mức độ kiểm soát bệnh UCT', record.data['uctScore'] ?? ''),
          _buildInfoRow(
              'Mức độ kiểm soát bệnh ACT', record.data['actScore'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Cận lâm sàng (đầy đủ)
      _buildInfoCard(
        'Cận lâm sàng',
        Icons.biotech,
        const Color(0xFFEF4444),
        [
          _buildInfoRow('WBC (G/L)', record.data['wbc'] ?? ''),
          _buildInfoRow('EO (%)', record.data['eo'] ?? ''),
          _buildInfoRow('BA (%)', record.data['ba'] ?? ''),
          _buildInfoRow('CRP (mg/L)', record.data['crp'] ?? ''),
          _buildInfoRow('ESR (mm/h)', record.data['esr'] ?? ''),
          _buildInfoRow('FT3 (pmol/L)', record.data['ft3'] ?? ''),
          _buildInfoRow('FT4 (pmol/L)', record.data['ft4'] ?? ''),
          _buildInfoRow('TSH (mIU/L)', record.data['tsh'] ?? ''),
          _buildInfoRow('Total IgE (kU/L)', record.data['totalIgE'] ?? ''),
          _buildInfoRow('Anti-TPO (IU/mL)', record.data['antiTPO'] ?? ''),
          _buildInfoRow('ANA Hep-2', record.data['anaHep2'] ?? ''),
          _buildInfoRow(
              'Mô hình lắng đọng', record.data['depositionPattern'] ?? ''),
          _buildInfoRow(
              'Siêu âm tuyến giáp', record.data['thyroidUltrasound'] ?? ''),
          _buildInfoRow('Test huyết thanh tự thân',
              record.data['autologousSerumSkinTest'] ?? ''),
          _buildInfoRow(
              'Đường kính mối phù (mm)', record.data['whealDiameter'] ?? ''),
          _buildInfoRow('Xét nghiệm khác', record.data['otherLabTests'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Chẩn đoán xác định
      _buildInfoCard(
        'Chẩn đoán xác định',
        Icons.medical_information,
        const Color(0xFF10B981),
        [
          _buildInfoRow(
              'Chẩn đoán xác định', record.data['finalDiagnosis'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Điều trị & Theo dõi
      _buildInfoCard(
        'Điều trị & Theo dõi',
        Icons.medication,
        const Color(0xFF6366F1),
        [
          _buildInfoRow(
              'Thuốc điều trị', record.data['treatmentMedications'] ?? ''),
          _buildInfoRow('Hẹn khám lại', record.data['followUpDate'] ?? ''),
        ],
      ),
    ];
  }

  List<Widget> _buildChronicFollowupDetails() {
    return [
      // Theo dõi hoạt động bệnh & kiểm soát bệnh
      _buildInfoCard(
        'Theo dõi hoạt động bệnh & kiểm soát bệnh',
        Icons.monitor_heart,
        const Color(0xFF10B981),
        [
          _buildSectionTitle('UAS7 khi dùng thuốc'),
          _buildInfoRow('Điểm ISS7 (khi dùng thuốc)',
              record.data['uas7OnTreatmentISS7'] ?? ''),
          _buildInfoRow('Điểm HSS7 (khi dùng thuốc)',
              record.data['uas7OnTreatmentHSS7'] ?? ''),
          const SizedBox(height: 16),
          _buildSectionTitle('UAS7 khi ngừng thuốc'),
          _buildInfoRow('Điểm ISS7 (khi ngừng thuốc)',
              record.data['uas7OffTreatmentISS7'] ?? ''),
          _buildInfoRow('Điểm HSS7 (khi ngừng thuốc)',
              record.data['uas7OffTreatmentHSS7'] ?? ''),
          const SizedBox(height: 16),
          _buildInfoRow('Mức độ kiểm soát bệnh (UCT điểm)',
              record.data['uctScore'] ?? ''),
          _buildInfoRow('Mức độ đáp ứng điều trị',
              record.data['treatmentResponse'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Tác dụng không mong muốn (chi tiết theo nhóm)
      _buildInfoCard(
        'Tác dụng không mong muốn - Toàn trạng',
        Icons.warning,
        const Color(0xFFF59E0B),
        [
          _buildInfoRow('Mệt mỏi',
              record.data['sideEffectFatigue'] == '1' ? 'Có' : 'Không'),
        ],
      ),
      const SizedBox(height: 16),

      _buildInfoCard(
        'Tác dụng không mong muốn - Thần kinh',
        Icons.psychology,
        const Color(0xFFF59E0B),
        [
          _buildInfoRow('Đau đầu',
              record.data['sideEffectHeadache'] == '1' ? 'Có' : 'Không'),
          _buildInfoRow('Chóng mặt',
              record.data['sideEffectDizziness'] == '1' ? 'Có' : 'Không'),
          _buildInfoRow('Buồn ngủ',
              record.data['sideEffectSleepy'] == '1' ? 'Có' : 'Không'),
          _buildInfoRow('Ngủ gà',
              record.data['sideEffectDrowsiness'] == '1' ? 'Có' : 'Không'),
        ],
      ),
      const SizedBox(height: 16),

      _buildInfoCard(
        'Tác dụng không mong muốn - Tiêu hóa',
        Icons.restaurant,
        const Color(0xFFF59E0B),
        [
          _buildInfoRow('Chán ăn',
              record.data['sideEffectLossOfAppetite'] == '1' ? 'Có' : 'Không'),
          _buildInfoRow('Khó tiêu',
              record.data['sideEffectIndigestion'] == '1' ? 'Có' : 'Không'),
          _buildInfoRow('Đau bụng',
              record.data['sideEffectAbdominalPain'] == '1' ? 'Có' : 'Không'),
        ],
      ),
      const SizedBox(height: 16),

      _buildInfoCard(
        'Tác dụng không mong muốn - Tim mạch',
        Icons.favorite,
        const Color(0xFFF59E0B),
        [
          _buildInfoRow('Đau ngực',
              record.data['sideEffectChestPain'] == '1' ? 'Có' : 'Không'),
          _buildInfoRow('Hồi hộp, trống ngực',
              record.data['sideEffectPalpitations'] == '1' ? 'Có' : 'Không'),
        ],
      ),
      const SizedBox(height: 16),

      _buildInfoCard(
        'Tác dụng phụ khác',
        Icons.warning_amber,
        const Color(0xFFF59E0B),
        [
          _buildInfoRow('Tác dụng phụ khác (ghi rõ)',
              record.data['sideEffectOther'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Triệu chứng hiện tại
      _buildInfoCard(
        'Triệu chứng hiện tại',
        Icons.healing,
        const Color(0xFFEF4444),
        [
          _buildInfoRow('Có sẩn phù hay không',
              record.data['rashPresent'] == '1' ? 'Có' : 'Không'),
          _buildInfoRow('Có phù mạch hay không',
              record.data['angioedemaPresent'] == '1' ? 'Có' : 'Không'),
          _buildInfoRow('Vị trí phù mạch',
              _formatList(record.data['angioedemaLocation'])),
          _buildInfoRow('Điểm AAS7', record.data['aas7Score'] ?? ''),
          _buildInfoRow(
              'Triệu chứng phản vệ', record.data['anaphylaxisSymptoms'] ?? ''),
          _buildInfoRow('Tiểu sử bệnh án khác mới phát hiện',
              record.data['newMedicalHistory'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Kết quả test cơ bản
      _buildInfoCard(
        'Kết quả test cơ bản',
        Icons.science,
        const Color(0xFF8B5CF6),
        [
          _buildInfoRow('Kết quả da vẽ nổi (Dermatographism)',
              record.data['dermatographismTest'] ?? ''),
          _buildInfoRow('Điểm Fric', record.data['fricScore'] ?? ''),
          _buildInfoRow('Điểm ngứa NRS', record.data['itchScoreNRS'] ?? ''),
          _buildInfoRow('Điểm đau NRS', record.data['painScoreNRS'] ?? ''),
          _buildInfoRow(
              'Điểm bỏng rát NRS', record.data['burningScoreNRS'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Mày đay do lạnh - Temptest
      _buildInfoCard(
        'Mày đay do lạnh - Temptest',
        Icons.ac_unit,
        const Color(0xFF06B6D4),
        [
          _buildInfoRow(
              'Kết quả Temptest', record.data['coldUrticariaTemptest'] ?? ''),
          _buildInfoRow('Vùng nhiệt độ dương tính (°C)',
              record.data['coldPositiveTemperature'] ?? ''),
          _buildInfoRow('Điểm ngứa NRS (khi Temptest)',
              record.data['itchScoreNRSCold'] ?? ''),
          _buildInfoRow('Điểm đau NRS (khi Temptest)',
              record.data['painScoreNRSCold'] ?? ''),
          _buildInfoRow('Điểm bỏng rát NRS (khi Temptest)',
              record.data['burningScoreNRSCold'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Mày đay do lạnh - Test cục đá
      _buildInfoCard(
        'Mày đay do lạnh - Test cục đá',
        Icons.ac_unit,
        const Color(0xFF06B6D4),
        [
          _buildInfoRow(
              'Kết quả Test cục đá', record.data['coldUrticariaIceTest'] ?? ''),
          _buildInfoRow('Ngưỡng thời gian (phút) khi Test cục đá',
              record.data['coldIceTimeThreshold'] ?? ''),
          _buildInfoRow('Điểm ngứa NRS (khi Test cục đá)',
              record.data['itchScoreNRSIce'] ?? ''),
          _buildInfoRow('Điểm đau NRS (khi Test cục đá)',
              record.data['painScoreNRSIce'] ?? ''),
          _buildInfoRow('Điểm bỏng rát NRS (khi Test cục đá)',
              record.data['burningScoreNRSIce'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Mày đay do choline
      _buildInfoCard(
        'Mày đay do choline',
        Icons.fitness_center,
        const Color(0xFFEF4444),
        [
          _buildInfoRow('Kết quả test choline',
              record.data['cholinergicUrticariaTest'] ?? ''),
          _buildInfoRow(
              'Thời gian xuất hiện tổn thương (phút) khi test choline',
              record.data['cholinergicAppearanceTime'] ?? ''),
          _buildInfoRow('Điểm ngứa NRS (khi test choline)',
              record.data['itchScoreNRSCholine'] ?? ''),
          _buildInfoRow('Điểm đau NRS (khi test choline)',
              record.data['painScoreNRSCholine'] ?? ''),
          _buildInfoRow('Điểm bỏng rát NRS (khi test choline)',
              record.data['burningScoreNRSCholine'] ?? ''),
        ],
      ),
      const SizedBox(height: 16),

      // Điểm số đánh giá cuối
      _buildInfoCard(
        'Điểm số đánh giá',
        Icons.assessment,
        const Color(0xFF8B5CF6),
        [
          _buildInfoRow(
              'Mức độ hoạt động bệnh CUSI', record.data['cusiScore'] ?? ''),
          _buildInfoRow('Căn nguyên khác', record.data['otherCause'] ?? ''),
          _buildInfoRow(
              'Mức độ kiểm soát bệnh ACT', record.data['actScore'] ?? ''),
        ],
      ),
    ];
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1F2937),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(String title, Map<String, dynamic> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ...images.entries.map((entry) {
          final location = entry.key;
          final imageList = entry.value as List<String>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () =>
                            _showImageDialog(context, imageList[index]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageList[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 80,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 40,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatList(dynamic list) {
    if (list == null) return '';
    if (list is List) {
      return list.join(', ');
    }
    return list.toString();
  }

  void _navigateToEditForm(BuildContext context) {
    // Navigate to appropriate edit form based on record type
    switch (record.type) {
      case 'acute':
        // Navigator.push to AcuteUrticariaFormScreen with edit mode
        break;
      case 'chronic_initial':
        // Navigator.push to ChronicUrticariaInitialFormScreen with edit mode
        break;
      case 'chronic_followup':
        // Navigator.push to ChronicUrticariaFollowupFormScreen with edit mode
        break;
    }
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

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
