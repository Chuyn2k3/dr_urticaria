import 'package:dr_urticaria/medical_record_v2/screens/medical_record_detail_screen.dart';
import 'package:dr_urticaria/widget/appbar/custom_app_bar.dart';
import 'package:dr_urticaria/widget/base_scaffold.dart';
import 'package:flutter/material.dart';

class MedicalRecordsListScreen extends StatefulWidget {
  const MedicalRecordsListScreen({super.key});

  @override
  State<MedicalRecordsListScreen> createState() =>
      _MedicalRecordsListScreenState();
}

class _MedicalRecordsListScreenState extends State<MedicalRecordsListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  // Mock data - trong thực tế sẽ lấy từ API
  final List<MedicalRecordItem> _mockRecords = [
    MedicalRecordItem(
      id: '1',
      type: 'acute',
      patientName: 'Nguyễn Văn A',
      patientId: 'BN001',
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
      status: 'completed',
      doctorName: 'BS. Trần Thị B',
      symptoms: 'Sẩn phù cấp tính, ngứa nhiều',
      diagnosis: 'Mày đay cấp tính',
    ),
    MedicalRecordItem(
      id: '2',
      type: 'chronic_initial',
      patientName: 'Lê Thị C',
      patientId: 'BN002',
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      status: 'pending',
      doctorName: 'BS. Nguyễn Văn D',
      symptoms: 'Mày đay mãn tính > 6 tuần',
      diagnosis: 'Đang chờ kết quả xét nghiệm',
    ),
    MedicalRecordItem(
      id: '3',
      type: 'chronic_followup',
      patientName: 'Phạm Văn E',
      patientId: 'BN003',
      createdDate: DateTime.now().subtract(const Duration(days: 7)),
      status: 'in_progress',
      doctorName: 'BS. Hoàng Thị F',
      symptoms: 'Tái khám mày đay mãn tính',
      diagnosis: 'Mày đay mãn tính - đáp ứng tốt',
    ),
    MedicalRecordItem(
      id: '4',
      type: 'acute',
      patientName: 'Trần Văn G',
      patientId: 'BN004',
      createdDate: DateTime.now().subtract(const Duration(days: 14)),
      status: 'completed',
      doctorName: 'BS. Lê Thị H',
      symptoms: 'Phù mạch, khó thở nhẹ',
      diagnosis: 'Phù mạch cấp tính',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MedicalRecordItem> get _filteredRecords {
    List<MedicalRecordItem> filtered = _mockRecords;

    switch (_selectedFilter) {
      case 'acute':
        filtered = _mockRecords.where((r) => r.type == 'acute').toList();
        break;
      case 'chronic_initial':
        filtered =
            _mockRecords.where((r) => r.type == 'chronic_initial').toList();
        break;
      case 'chronic_followup':
        filtered =
            _mockRecords.where((r) => r.type == 'chronic_followup').toList();
        break;
      default:
        filtered = _mockRecords;
    }

    return filtered..sort((a, b) => b.createdDate.compareTo(a.createdDate));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppbar.basic(
        title: 'Danh sách bệnh án',
      ),
      body: Column(
        children: [
          // Statistics Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tổng số',
                    _mockRecords.length.toString(),
                    Icons.folder_outlined,
                    const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Hoàn thành',
                    _mockRecords
                        .where((r) => r.status == 'completed')
                        .length
                        .toString(),
                    Icons.check_circle_outline,
                    const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Đang xử lý',
                    _mockRecords
                        .where((r) => r.status != 'completed')
                        .length
                        .toString(),
                    Icons.schedule,
                    const Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ),

          // Filter Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              onTap: (index) {
                setState(() {
                  switch (index) {
                    case 0:
                      _selectedFilter = 'all';
                      break;
                    case 1:
                      _selectedFilter = 'acute';
                      break;
                    case 2:
                      _selectedFilter = 'chronic_initial';
                      break;
                    case 3:
                      _selectedFilter = 'chronic_followup';
                      break;
                  }
                });
              },
              tabs: const [
                Tab(text: 'Tất cả'),
                Tab(text: 'Cấp tính'),
                Tab(text: 'Mãn tính L1'),
                Tab(text: 'Tái khám'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Records List
          Expanded(
            child: _filteredRecords.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = _filteredRecords[index];
                      return _buildRecordCard(record);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
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
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(MedicalRecordItem record) {
    final typeInfo = _getTypeInfo(record.type);
    final statusInfo = _getStatusInfo(record.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MedicalRecordDetailScreen(record: record),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: typeInfo['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            typeInfo['icon'],
                            size: 14,
                            color: typeInfo['color'],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            typeInfo['label'],
                            style: TextStyle(
                              color: typeInfo['color'],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusInfo['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            statusInfo['icon'],
                            size: 12,
                            color: statusInfo['color'],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            statusInfo['label'],
                            style: TextStyle(
                              color: statusInfo['color'],
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Patient Info
                Text(
                  record.patientName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mã BN: ${record.patientId}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                // Symptoms
                if (record.symptoms.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.medical_services,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          record.symptoms,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],

                // Diagnosis
                if (record.diagnosis.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.medical_information,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          record.diagnosis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],

                // Footer Row
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      record.doctorName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(record.createdDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có bệnh án nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tạo bệnh án đầu tiên của bạn',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
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
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == 1) {
      return 'Hôm qua';
    } else if (difference < 7) {
      return '$difference ngày trước';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Model class for medical record items
class MedicalRecordItem {
  final String id;
  final String type; // 'acute', 'chronic_initial', 'chronic_followup'
  final String patientName;
  final String patientId;
  final DateTime createdDate;
  final String status; // 'completed', 'pending', 'in_progress'
  final String doctorName;
  final String symptoms;
  final String diagnosis;

  MedicalRecordItem({
    required this.id,
    required this.type,
    required this.patientName,
    required this.patientId,
    required this.createdDate,
    required this.status,
    required this.doctorName,
    required this.symptoms,
    required this.diagnosis,
  });
}
