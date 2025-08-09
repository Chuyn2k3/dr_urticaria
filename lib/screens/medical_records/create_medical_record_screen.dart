import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../cubits/medical_record_cubit.dart';
import '../../models/medical_record_model.dart';
import '../../utils/app_theme.dart';

class CreateMedicalRecordScreen extends StatefulWidget {
  final String createdBy;
  final String? doctorId;
  final String? doctorName;
  final String? roomNumber;

  const CreateMedicalRecordScreen({
    super.key,
    required this.createdBy,
    this.doctorId,
    this.doctorName,
    this.roomNumber,
  });

  @override
  State<CreateMedicalRecordScreen> createState() =>
      _CreateMedicalRecordScreenState();
}

class _CreateMedicalRecordScreenState extends State<CreateMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _patientPhoneController = TextEditingController();
  final _patientAddressController = TextEditingController();
  final _symptomsController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _currentMedicationsController = TextEditingController();

  MedicalRecordType? _selectedType;
  bool _hasUrticariaHistory = false;
  bool _hasPhotos = false;
  String? _symptomDuration;
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientPhoneController.dispose();
    _patientAddressController.dispose();
    _symptomsController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    super.dispose();
  }

  // Add a section for creating records for patients
  Widget _buildStaffCreateForPatient() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.infoColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.infoColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.infoColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Tạo bệnh án hỗ trợ cho bệnh nhân chưa có tài khoản hoặc chưa tạo bệnh án.',
                  style: TextStyle(
                    color: AppTheme.infoColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Rest of the form...
        _buildDoctorForm(),
      ],
    );
  }

  // Update the main build method
  @override
  Widget build(BuildContext context) {
    final isPatient = widget.createdBy == 'patient';
    final isStaffHelping = widget.createdBy == 'staff_help';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPatient
              ? 'Tạo bệnh án'
              : isStaffHelping
                  ? 'Tạo bệnh án cho bệnh nhân'
                  : 'Tạo bệnh án mới',
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isPatient) ...[
                _buildPatientQuestionnaire(),
              ] else if (isStaffHelping) ...[
                _buildStaffCreateForPatient(),
              ] else ...[
                _buildDoctorForm(),
              ],

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canCreateRecord() ? _createRecord : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isStaffHelping
                        ? 'Tạo bệnh án cho bệnh nhân'
                        : isPatient
                            ? 'Tạo bệnh án'
                            : 'Tạo bệnh án mới',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientQuestionnaire() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Patient Information
        _buildSection(
          'Thông tin cá nhân',
          [
            _buildTextField(
              controller: _patientNameController,
              label: 'Họ và tên',
              icon: Icons.person,
              required: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _patientPhoneController,
              label: 'Số điện thoại',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              required: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _patientAddressController,
              label: 'Địa chỉ',
              icon: Icons.location_on,
              required: true,
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Question 1: Urticaria history
        _buildSection(
          'Câu hỏi 1: Tiền sử bệnh',
          [
            const Text(
              'Bạn có tiền sử mề đay hiện tại không?',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildRadioOption(
                    title: 'Có',
                    value: true,
                    groupValue: _hasUrticariaHistory,
                    onChanged: (value) {
                      setState(() {
                        _hasUrticariaHistory = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _buildRadioOption(
                    title: 'Không',
                    value: false,
                    groupValue: _hasUrticariaHistory,
                    onChanged: (value) {
                      setState(() {
                        _hasUrticariaHistory = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Question 2: Photos
        _buildSection(
          'Câu hỏi 2: Ảnh minh chứng',
          [
            const Text(
              'Tải ảnh minh chứng các vị trí có mề đay',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildRadioOption(
                    title: 'Có ảnh',
                    value: true,
                    groupValue: _hasPhotos,
                    onChanged: (value) {
                      setState(() {
                        _hasPhotos = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _buildRadioOption(
                    title: 'Không có ảnh',
                    value: false,
                    groupValue: _hasPhotos,
                    onChanged: (value) {
                      setState(() {
                        _hasPhotos = value!;
                        if (!value) {
                          _selectedImages.clear();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_hasPhotos) _buildPhotoUploadSection(),
            if (!_hasPhotos) _buildPhotoGuidanceSection(),
          ],
        ),

        const SizedBox(height: 24),

        // Question 3: Symptom duration
        _buildSection(
          'Câu hỏi 3: Thời gian xuất hiện tổn thương',
          [
            const Text(
              'Thời gian xuất hiện triệu chứng mề đay:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildRadioOption(
                    title: '< 6 tuần',
                    value: '< 6 tuần',
                    groupValue: _symptomDuration,
                    onChanged: (value) {
                      setState(() {
                        _symptomDuration = value;
                        _selectedType = MedicalRecordType.acute;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _buildRadioOption(
                    title: '≥ 6 tuần',
                    value: '≥ 6 tuần',
                    groupValue: _symptomDuration,
                    onChanged: (value) {
                      setState(() {
                        _symptomDuration = value;
                        _selectedType = null;
                      });
                    },
                  ),
                ),
              ],
            ),

            // Sub-options for chronic cases
            if (_symptomDuration == '≥ 6 tuần') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tình trạng khám bệnh:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildRadioOption(
                      title: 'Lần đầu khám',
                      subtitle: 'Chưa từng khám mề đay tại bệnh viện',
                      value: MedicalRecordType.chronicFirst,
                      groupValue: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                    _buildRadioOption(
                      title: 'Tái khám',
                      subtitle: 'Đã từng khám và điều trị mề đay',
                      value: MedicalRecordType.chronicReexam,
                      groupValue: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 24),

        // Symptoms description
        _buildSection(
          'Mô tả triệu chứng',
          [
            _buildTextField(
              controller: _symptomsController,
              label: 'Mô tả chi tiết các triệu chứng',
              icon: Icons.description,
              maxLines: 4,
              hintText:
                  'Ví dụ: Nổi mề đay toàn thân, ngứa nhiều, xuất hiện sau khi ăn...',
            ),
          ],
        ),

        if (_selectedType == MedicalRecordType.chronicReexam) ...[
          const SizedBox(height: 24),
          _buildSection(
            'Thông tin bổ sung (Tái khám)',
            [
              _buildTextField(
                controller: _medicalHistoryController,
                label: 'Tiền sử bệnh',
                icon: Icons.history,
                maxLines: 3,
                hintText: 'Các bệnh đã mắc, điều trị trước đây...',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _allergiesController,
                label: 'Dị ứng',
                icon: Icons.warning,
                maxLines: 2,
                hintText: 'Các chất gây dị ứng đã biết...',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _currentMedicationsController,
                label: 'Thuốc đang sử dụng',
                icon: Icons.medication,
                maxLines: 2,
                hintText: 'Các loại thuốc đang dùng...',
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDoctorForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Record Type Selection
        _buildSection(
          'Loại bệnh án',
          [
            _buildRecordTypeCard(
              MedicalRecordType.acute,
              'Mề đay cấp tính',
              'Triệu chứng xuất hiện < 6 tuần',
              Icons.flash_on,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildRecordTypeCard(
              MedicalRecordType.chronicFirst,
              'Mề đay mạn tính lần 1',
              'Triệu chứng ≥ 6 tuần, lần đầu khám',
              Icons.schedule,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildRecordTypeCard(
              MedicalRecordType.chronicReexam,
              'Mề đay mạn tính tái khám',
              'Triệu chứng ≥ 6 tuần, tái khám',
              Icons.refresh,
              Colors.green,
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Patient Information
        _buildSection(
          'Thông tin bệnh nhân',
          [
            _buildTextField(
              controller: _patientNameController,
              label: 'Họ và tên',
              icon: Icons.person,
              required: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _patientPhoneController,
              label: 'Số điện thoại',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              required: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _patientAddressController,
              label: 'Địa chỉ',
              icon: Icons.location_on,
              required: true,
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Symptoms
        _buildSection(
          'Triệu chứng và tiền sử',
          [
            _buildTextField(
              controller: _symptomsController,
              label: 'Triệu chứng',
              icon: Icons.sick,
              maxLines: 3,
              hintText: 'Mô tả triệu chứng của bệnh nhân...',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Có tiền sử mề đay'),
                    value: _hasUrticariaHistory,
                    onChanged: (value) {
                      setState(() {
                        _hasUrticariaHistory = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Có ảnh minh chứng'),
                    value: _hasPhotos,
                    onChanged: (value) {
                      setState(() {
                        _hasPhotos = value ?? false;
                        if (!_hasPhotos) {
                          _selectedImages.clear();
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
            if (_hasPhotos) ...[
              const SizedBox(height: 16),
              _buildPhotoUploadSection(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập $label';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildRadioOption<T>({
    required String title,
    String? subtitle,
    required T value,
    required T? groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value == groupValue
              ? AppTheme.primaryColor
              : Colors.grey.shade300,
          width: value == groupValue ? 2 : 1,
        ),
        color: value == groupValue
            ? AppTheme.primaryColor.withOpacity(0.05)
            : null,
      ),
      child: RadioListTile<T>(
        title: Text(
          title,
          style: TextStyle(
            fontWeight:
                value == groupValue ? FontWeight.bold : FontWeight.normal,
            color: value == groupValue ? AppTheme.primaryColor : null,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: value == groupValue
                      ? AppTheme.primaryColor.withOpacity(0.8)
                      : Colors.grey.shade600,
                ),
              )
            : null,
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildRecordTypeCard(
    MedicalRecordType type,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          // Auto-set symptom duration based on type
          if (type == MedicalRecordType.acute) {
            _symptomDuration = '< 6 tuần';
          } else {
            _symptomDuration = '≥ 6 tuần';
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? color.withOpacity(0.05) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? color : AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? color.withOpacity(0.8)
                          : AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoUploadSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_a_photo,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Chụp ảnh các vị trí có mề đay',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Photo grid
          if (_selectedImages.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImages.removeAt(index);
                          });
                        },
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
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
          ],

          // Add photo buttons
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
                  label: const Text('Chọn từ thư viện'),
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
            'Lưu ý: Chụp rõ các vị trí có mề đay để bác sĩ dễ chẩn đoán',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGuidanceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.blue,
            size: 32,
          ),
          const SizedBox(height: 12),
          const Text(
            'Hướng dẫn đến phòng chụp ảnh',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Để tiện cho việc khám chữa bệnh, bạn vui lòng đến phòng chụp ảnh và chụp ảnh các vị trí có mề đay trên cơ thể.',
            style: TextStyle(color: Colors.blue),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Địa điểm: Phòng chụp ảnh tổn thương - Phòng 301, tầng 3, khu A',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Giờ làm việc: 8:00 - 17:00 (thứ 2 - thứ 6)',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          _selectedImages.add(File(image.path));
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

  bool _canCreateRecord() {
    //if (!_formKey.currentState!.validate()) return false;
    if (_selectedType == null) return false;
    if (widget.createdBy == 'patient' && _symptomDuration == null) return false;
    return true;
  }

  void _createRecord() {
    if (!_canCreateRecord()) return;

    final recordNumber =
        'BN${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    final newRecord = MedicalRecordModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: 'patient_${DateTime.now().millisecondsSinceEpoch}',
      patientName: _patientNameController.text,
      patientPhone: _patientPhoneController.text,
      patientAddress: _patientAddressController.text,
      medicalRecordNumber: recordNumber,
      type: _selectedType!,
      status: widget.createdBy == 'doctor'
          ? MedicalRecordStatus.inProgress
          : MedicalRecordStatus.pendingApproval,
      doctorId: widget.doctorId,
      doctorName: widget.doctorName,
      roomNumber: widget.roomNumber,
      createdAt: DateTime.now(),
      createdBy: widget.createdBy,
      hasUrticariaHistory: _hasUrticariaHistory,
      hasPhotos: _selectedImages.isNotEmpty,
      photoUrls: _selectedImages.map((file) => file.path).toList(),
      symptomDuration: _symptomDuration,
      symptoms: _symptomsController.text,
      medicalHistory: _medicalHistoryController.text.isNotEmpty
          ? _medicalHistoryController.text
          : null,
      allergies: _allergiesController.text.isNotEmpty
          ? _allergiesController.text
          : null,
      currentMedications: _currentMedicationsController.text.isNotEmpty
          ? _currentMedicationsController.text
          : null,
    );

    context.read<MedicalRecordCubit>().addRecord(newRecord);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã tạo bệnh án $recordNumber'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}
