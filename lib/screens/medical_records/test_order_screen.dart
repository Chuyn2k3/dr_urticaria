import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/medical_record_cubit.dart';
import '../../cubits/notification_cubit.dart';
import '../../models/medical_record_model.dart';
import '../../models/notification_model.dart';
import '../../utils/app_theme.dart';

class TestOrderScreen extends StatefulWidget {
  final MedicalRecordModel record;

  const TestOrderScreen({
    super.key,
    required this.record,
  });

  @override
  State<TestOrderScreen> createState() => _TestOrderScreenState();
}

class _TestOrderScreenState extends State<TestOrderScreen> {
  final List<TestOption> _availableTests = [
    TestOption(
      id: 'blood_test',
      name: 'Xét nghiệm máu',
      room: 'Phòng XN 201',
      description: 'Công thức máu, sinh hóa máu',
      category: 'Xét nghiệm cơ bản',
    ),
    TestOption(
      id: 'allergy_test',
      name: 'Test dị ứng',
      room: 'Phòng XN 202',
      description: 'Skin prick test, IgE đặc hiệu',
      category: 'Xét nghiệm dị ứng',
    ),
    TestOption(
      id: 'histamine_test',
      name: 'Xét nghiệm Histamine',
      room: 'Phòng XN 203',
      description: 'Đo nồng độ histamine trong máu',
      category: 'Xét nghiệm chuyên sâu',
    ),
    TestOption(
      id: 'complement_test',
      name: 'Xét nghiệm Complement',
      room: 'Phòng XN 204',
      description: 'C3, C4, CH50',
      category: 'Xét nghiệm miễn dịch',
    ),
    TestOption(
      id: 'thyroid_test',
      name: 'Chức năng tuyến giáp',
      room: 'Phòng XN 205',
      description: 'TSH, T3, T4',
      category: 'Xét nghiệm nội tiết',
    ),
    TestOption(
      id: 'liver_test',
      name: 'Chức năng gan',
      room: 'Phòng XN 206',
      description: 'ALT, AST, Bilirubin',
      category: 'Xét nghiệm cơ bản',
    ),
  ];

  final Set<String> _selectedTests = {};
  String _selectedCategory = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Tất cả',
      ..._availableTests.map((t) => t.category).toSet()
    ];
    final filteredTests = _selectedCategory == 'Tất cả'
        ? _availableTests
        : _availableTests
            .where((t) => t.category == _selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉ định xét nghiệm'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_selectedTests.isNotEmpty)
            TextButton(
              onPressed: _orderSelectedTests,
              child: Text(
                'Chỉ định (${_selectedTests.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Patient info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bệnh nhân: ${widget.record.patientName}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bệnh án: ${widget.record.medicalRecordNumber}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                Text(
                  'Chẩn đoán: ${widget.record.typeDisplayName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Category filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondaryColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // Tests list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTests.length,
              itemBuilder: (context, index) {
                final test = filteredTests[index];
                final isSelected = _selectedTests.contains(test.id);
                final isAlreadyOrdered = widget.record.testOrders
                    .any((order) => order.testName == test.name);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    onTap: isAlreadyOrdered
                        ? null
                        : () {
                            setState(() {
                              if (isSelected) {
                                _selectedTests.remove(test.id);
                              } else {
                                _selectedTests.add(test.id);
                              }
                            });
                          },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Test icon
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isAlreadyOrdered
                                  ? Colors.grey.withOpacity(0.1)
                                  : isSelected
                                      ? AppTheme.primaryColor.withOpacity(0.1)
                                      : AppTheme.infoColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.science_rounded,
                              color: isAlreadyOrdered
                                  ? Colors.grey
                                  : isSelected
                                      ? AppTheme.primaryColor
                                      : AppTheme.infoColor,
                              size: 24,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Test info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  test.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isAlreadyOrdered
                                        ? Colors.grey
                                        : AppTheme.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  test.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isAlreadyOrdered
                                        ? Colors.grey
                                        : AppTheme.textSecondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.meeting_room_rounded,
                                      size: 14,
                                      color: isAlreadyOrdered
                                          ? Colors.grey
                                          : AppTheme.textSecondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      test.room,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isAlreadyOrdered
                                            ? Colors.grey
                                            : AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Status indicator
                          if (isAlreadyOrdered)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Đã chỉ định',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.primaryColor,
                              size: 24,
                            )
                          else
                            Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.grey.shade400,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom action bar
          if (_selectedTests.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _orderSelectedTests,
                    icon: const Icon(Icons.assignment_add),
                    label: Text('Chỉ định ${_selectedTests.length} xét nghiệm'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _orderSelectedTests() {
    if (_selectedTests.isEmpty) return;

    final selectedTestOptions = _availableTests
        .where((test) => _selectedTests.contains(test.id))
        .toList();

    final newTestOrders = selectedTestOptions.map((test) {
      return TestOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString() + test.id,
        testName: test.name,
        roomNumber: test.room,
        orderedAt: DateTime.now(),
      );
    }).toList();

    // Update record with new test orders
    context
        .read<MedicalRecordCubit>()
        .orderTests(widget.record.id, newTestOrders);

    // Send notification to patient
    final testNames = selectedTestOptions.map((t) => t.name).join(', ');
    context.read<NotificationCubit>().addNotification(
          NotificationModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: widget.record.patientId,
            title: 'Chỉ định xét nghiệm mới',
            message: 'Bạn cần thực hiện các xét nghiệm: $testNames',
            type: NotificationType.testOrder,
            createdAt: DateTime.now(),
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã chỉ định ${_selectedTests.length} xét nghiệm'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, widget.record);
  }
}

class TestOption {
  final String id;
  final String name;
  final String room;
  final String description;
  final String category;

  TestOption({
    required this.id,
    required this.name,
    required this.room,
    required this.description,
    required this.category,
  });
}
