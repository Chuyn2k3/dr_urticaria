import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../cubits/medical_record_cubit.dart';
import '../../cubits/notification_cubit.dart';
import '../../cubits/auth_cubit.dart';
import '../../models/medical_record_model.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import 'test_order_screen.dart';
import '../../utils/app_theme.dart';

class MedicalRecordDetailScreen extends StatefulWidget {
  final MedicalRecordModel record;

  const MedicalRecordDetailScreen({
    super.key,
    required this.record,
  });

  @override
  State<MedicalRecordDetailScreen> createState() =>
      _MedicalRecordDetailScreenState();
}

class _MedicalRecordDetailScreenState extends State<MedicalRecordDetailScreen> {
  late MedicalRecordModel _record;
  final _symptomsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _treatmentController = TextEditingController();

  List<File> _newImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _record = widget.record;
    _symptomsController.text = _record.symptoms ?? '';
    _diagnosisController.text = _record.diagnosis ?? '';
    _prescriptionController.text = _record.prescription ?? '';
    _notesController.text = _record.notes ?? '';
    _treatmentController.text = _record.treatment ?? '';
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    _diagnosisController.dispose();
    _prescriptionController.dispose();
    _notesController.dispose();
    _treatmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthCubit>().state.user;
    final canEdit = _canEditRecord(currentUser);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bệnh án ${_record.medicalRecordNumber}'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (canEdit && _record.status == MedicalRecordStatus.inProgress)
            IconButton(
              icon: const Icon(Icons.save_rounded),
              onPressed: _saveRecord,
              tooltip: 'Lưu bệnh án',
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'approve':
                  _approveRecord();
                  break;
                case 'test_order':
                  _navigateToTestOrder();
                  break;
                case 'mark_tests_complete':
                  _markTestsComplete();
                  break;
                case 'complete':
                  _completeRecord();
                  break;
                case 'print':
                  _printRecord();
                  break;
              }
            },
            itemBuilder: (context) => [
              if (canEdit &&
                  currentUser?.role == UserRole.nurse &&
                  _record.status == MedicalRecordStatus.pendingApproval)
                const PopupMenuItem(
                  value: 'approve',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppTheme.successColor),
                      SizedBox(width: 12),
                      Text('Duyệt bệnh án'),
                    ],
                  ),
                ),
              if (canEdit &&
                  currentUser?.role == UserRole.doctor &&
                  _record.status == MedicalRecordStatus.inProgress)
                const PopupMenuItem(
                  value: 'test_order',
                  child: Row(
                    children: [
                      Icon(Icons.science_rounded, color: AppTheme.primaryColor),
                      SizedBox(width: 12),
                      Text('Chỉ định xét nghiệm'),
                    ],
                  ),
                ),
              if (canEdit &&
                  currentUser?.role == UserRole.doctor &&
                  _record.status == MedicalRecordStatus.waitingTests)
                const PopupMenuItem(
                  value: 'mark_tests_complete',
                  child: Row(
                    children: [
                      Icon(Icons.assignment_turned_in,
                          color: AppTheme.successColor),
                      SizedBox(width: 12),
                      Text('Đã đủ kết quả XN'),
                    ],
                  ),
                ),
              if (canEdit &&
                  _record.status == MedicalRecordStatus.testsComplete &&
                  currentUser?.role == UserRole.doctor)
                const PopupMenuItem(
                  value: 'complete',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: AppTheme.successColor),
                      SizedBox(width: 12),
                      Text('Hoàn thành bệnh án'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'print',
                child: Row(
                  children: [
                    Icon(Icons.print_rounded, color: AppTheme.textPrimaryColor),
                    SizedBox(width: 12),
                    Text('In bệnh án'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            _buildStatusCard(),

            const SizedBox(height: 24),

            // Patient Information
            _buildPatientInfoSection(),

            const SizedBox(height: 16),

            // Medical History
            _buildMedicalHistorySection(),

            const SizedBox(height: 16),

            // Photos Section
            _buildPhotosSection(canEdit),

            const SizedBox(height: 16),

            // Symptoms
            _buildEditableSection(
              'Triệu chứng',
              _symptomsController,
              'Mô tả triệu chứng của bệnh nhân...',
              icon: Icons.sick_rounded,
              iconColor: AppTheme.errorColor,
              canEdit: canEdit,
            ),

            const SizedBox(height: 16),

            // Test Results
            if (_record.testOrders.isNotEmpty) _buildTestResultsSection(),

            const SizedBox(height: 16),

            // Diagnosis
            _buildEditableSection(
              'Chẩn đoán',
              _diagnosisController,
              'Chẩn đoán của bác sĩ...',
              icon: Icons.psychology_rounded,
              iconColor: AppTheme.primaryColor,
              canEdit: canEdit && currentUser?.role == UserRole.doctor,
            ),

            const SizedBox(height: 16),

            // Treatment
            _buildEditableSection(
              'Phương pháp điều trị',
              _treatmentController,
              'Phương pháp điều trị cho bệnh nhân...',
              icon: Icons.healing_rounded,
              iconColor: AppTheme.accentColor,
              canEdit: canEdit && currentUser?.role == UserRole.doctor,
            ),

            const SizedBox(height: 16),

            // Prescription
            _buildEditableSection(
              'Đơn thuốc',
              _prescriptionController,
              'Kê đơn thuốc cho bệnh nhân...',
              icon: Icons.medication_rounded,
              iconColor: AppTheme.secondaryColor,
              canEdit: canEdit && currentUser?.role == UserRole.doctor,
            ),

            const SizedBox(height: 16),

            // Notes
            _buildEditableSection(
              'Ghi chú',
              _notesController,
              'Ghi chú thêm...',
              icon: Icons.note_rounded,
              iconColor: AppTheme.accentColor,
              canEdit: canEdit,
            ),

            const SizedBox(height: 32),

            // Action buttons
            if (canEdit && _record.status == MedicalRecordStatus.inProgress)
              _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _record.statusColor,
            _record.statusColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _record.statusColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medical_services_rounded,
                  color: _record.statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _record.statusDisplayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _record.typeDisplayName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Ngày tạo: ${_record.createdAt.day}/${_record.createdAt.month}/${_record.createdAt.year}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (_record.queueNumber != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.queue_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'STT: ${_record.queueNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfoSection() {
    return _buildSection(
      'Thông tin bệnh nhân',
      [
        _buildInfoRow('Họ tên', _record.patientName),
        _buildInfoRow('Số điện thoại', _record.patientPhone),
        _buildInfoRow('Địa chỉ', _record.patientAddress),
        _buildInfoRow('Số bệnh án', _record.medicalRecordNumber),
        if (_record.doctorName != null)
          _buildInfoRow('Bác sĩ phụ trách', _record.doctorName!),
        if (_record.roomNumber != null)
          _buildInfoRow('Phòng khám', _record.roomNumber!),
      ],
      icon: Icons.person_rounded,
      iconColor: AppTheme.primaryColor,
    );
  }

  Widget _buildMedicalHistorySection() {
    return _buildSection(
      'Tiền sử bệnh',
      [
        _buildInfoRow(
          'Có tiền sử mề đay',
          _record.hasUrticariaHistory ? 'Có' : 'Không',
        ),
        _buildInfoRow(
          'Thời gian xuất hiện triệu chứng',
          _record.symptomDuration ?? 'Chưa cập nhật',
        ),
        _buildInfoRow(
          'Có ảnh minh chứng',
          _record.hasPhotos
              ? 'Có (${_record.photoUrls.length + _newImages.length} ảnh)'
              : 'Không',
        ),
        if (_record.medicalHistory != null)
          _buildInfoRow('Tiền sử bệnh', _record.medicalHistory!),
        if (_record.allergies != null)
          _buildInfoRow('Dị ứng', _record.allergies!),
        if (_record.currentMedications != null)
          _buildInfoRow('Thuốc đang dùng', _record.currentMedications!),
      ],
      icon: Icons.history_rounded,
      iconColor: AppTheme.warningColor,
    );
  }

  Widget _buildPhotosSection(bool canEdit) {
    final allPhotos = [..._record.photoUrls, ..._newImages.map((f) => f.path)];

    if (allPhotos.isEmpty && !canEdit) {
      return const SizedBox.shrink();
    }

    return _buildSection(
      'Ảnh minh chứng',
      [
        if (allPhotos.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: allPhotos.length,
            itemBuilder: (context, index) {
              final isNewImage = index >= _record.photoUrls.length;
              final imagePath = allPhotos[index];

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => _viewFullImage(imagePath, isNewImage),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: isNewImage
                              ? FileImage(File(imagePath))
                              : NetworkImage(imagePath) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (canEdit)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  if (isNewImage)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Mới',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          if (canEdit) const SizedBox(height: 16),
        ],
        if (canEdit) ...[
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Chụp ảnh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Chọn ảnh'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Bác sĩ/Y tá có thể chụp thêm ảnh hoặc chỉnh sửa ảnh hiện có',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
      icon: Icons.photo_camera_rounded,
      iconColor: AppTheme.infoColor,
    );
  }

  Widget _buildSection(String title, List<Widget> children,
      {IconData? icon, Color? iconColor}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          (iconColor ?? AppTheme.primaryColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildEditableSection(
    String title,
    TextEditingController controller,
    String hint, {
    IconData? icon,
    Color? iconColor,
    bool canEdit = true,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          (iconColor ?? AppTheme.primaryColor).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppTheme.primaryColor,
                      size: 20,
                    ),
                  ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                if (!canEdit)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Chỉ xem',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              enabled: canEdit,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: hint,
                border: canEdit ? null : InputBorder.none,
                filled: !canEdit,
                fillColor: canEdit ? null : Colors.grey[100],
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: canEdit
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFDFE1E5)),
                      )
                    : null,
                focusedBorder: canEdit
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: iconColor ?? AppTheme.primaryColor,
                            width: 2),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResultsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.science_rounded,
                    color: AppTheme.infoColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Kết quả xét nghiệm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const Spacer(),
                if (_record.hasCompleteTestResults)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.successColor,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Đã đủ kết quả',
                          style: TextStyle(
                            color: AppTheme.successColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _record.testOrders.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final test = _record.testOrders[index];
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: test.isCompleted
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        test.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.schedule_rounded,
                        color: test.isCompleted
                            ? AppTheme.successColor
                            : AppTheme.warningColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test.testName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.meeting_room_rounded,
                                size: 14,
                                color: AppTheme.textSecondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Phòng: ${test.roomNumber}',
                                style: const TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          if (test.result != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Kết quả:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(test.result!),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: test.isCompleted
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        test.isCompleted ? 'Hoàn thành' : 'Chờ kết quả',
                        style: TextStyle(
                          color: test.isCompleted
                              ? AppTheme.successColor
                              : AppTheme.warningColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _saveRecord,
            icon: const Icon(Icons.save_rounded),
            label: const Text('Lưu bệnh án'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _completeRecord,
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text('Hoàn thành'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  bool _canEditRecord(UserModel? user) {
    if (user == null) return false;

    // Patients can only view their records
    // if (user.role == UserRole.patient) return false;

    // Doctors and nurses can edit records in progress
    if (user.role == UserRole.doctor || user.role == UserRole.nurse) {
      return _record.status == MedicalRecordStatus.inProgress ||
          _record.status == MedicalRecordStatus.testsComplete;
    }

    return false;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _newImages.add(File(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi chọn ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      if (index < _record.photoUrls.length) {
        // Remove from original photos
        final updatedUrls = List<String>.from(_record.photoUrls);
        updatedUrls.removeAt(index);
        _record = _record.copyWith(photoUrls: updatedUrls);
      } else {
        // Remove from new images
        final newImageIndex = index - _record.photoUrls.length;
        _newImages.removeAt(newImageIndex);
      }
    });
  }

  void _viewFullImage(String imagePath, bool isNewImage) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image(
                  image: isNewImage
                      ? FileImage(File(imagePath))
                      : NetworkImage(imagePath) as ImageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTestOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestOrderScreen(record: _record),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          _record = result;
        });
      }
    });
  }

  void _saveRecord() {
    final updatedPhotoUrls = [
      ..._record.photoUrls,
      ..._newImages.map((file) => file.path),
    ];

    final updatedRecord = _record.copyWith(
      symptoms: _symptomsController.text,
      diagnosis: _diagnosisController.text,
      prescription: _prescriptionController.text,
      notes: _notesController.text,
      treatment: _treatmentController.text,
      photoUrls: updatedPhotoUrls,
      hasPhotos: updatedPhotoUrls.isNotEmpty,
      updatedAt: DateTime.now(),
    );

    context.read<MedicalRecordCubit>().updateRecord(updatedRecord);
    setState(() {
      _record = updatedRecord;
      _newImages.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu bệnh án'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _completeRecord() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hoàn thành bệnh án'),
        content: const Text('Bạn có chắc chắn muốn hoàn thành bệnh án này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedPhotoUrls = [
                ..._record.photoUrls,
                ..._newImages.map((file) => file.path),
              ];

              final completedRecord = _record.copyWith(
                status: MedicalRecordStatus.completed,
                symptoms: _symptomsController.text,
                diagnosis: _diagnosisController.text,
                prescription: _prescriptionController.text,
                notes: _notesController.text,
                treatment: _treatmentController.text,
                photoUrls: updatedPhotoUrls,
                hasPhotos: updatedPhotoUrls.isNotEmpty,
                updatedAt: DateTime.now(),
              );

              context.read<MedicalRecordCubit>().updateRecord(completedRecord);

              // Send notification to patient
              context.read<NotificationCubit>().addNotification(
                    NotificationModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      userId: _record.patientId,
                      title: 'Bệnh án hoàn thành',
                      message:
                          'Bệnh án ${_record.medicalRecordNumber} đã được hoàn thành',
                      type: NotificationType.general,
                      createdAt: DateTime.now(),
                    ),
                  );

              Navigator.pop(context);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã hoàn thành bệnh án'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
            ),
            child: const Text('Hoàn thành'),
          ),
        ],
      ),
    );
  }

  void _printRecord() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng in bệnh án đang được phát triển'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Add a method to mark tests as complete
  void _markTestsComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật kết quả xét nghiệm'),
        content: const Text(
            'Bệnh nhân đã mang đầy đủ kết quả xét nghiệm. Cập nhật trạng thái bệnh án?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              final updatedRecord = _record.copyWith(
                status: MedicalRecordStatus.testsComplete,
                hasCompleteTestResults: true,
                updatedAt: DateTime.now(),
              );

              context.read<MedicalRecordCubit>().updateRecord(updatedRecord);
              setState(() {
                _record = updatedRecord;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Đã cập nhật trạng thái: Đủ kết quả xét nghiệm'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
            ),
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

// Add the approve record method
  void _approveRecord() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duyệt bệnh án'),
        content: Text('Duyệt bệnh án của ${_record.patientName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              final updatedRecord = _record.copyWith(
                status: MedicalRecordStatus.inProgress,
                updatedAt: DateTime.now(),
              );

              context.read<MedicalRecordCubit>().updateRecord(updatedRecord);
              setState(() {
                _record = updatedRecord;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã duyệt bệnh án'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
            ),
            child: const Text('Duyệt'),
          ),
        ],
      ),
    );
  }
}
