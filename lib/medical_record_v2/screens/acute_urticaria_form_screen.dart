import 'package:dr_urticaria/constant/color.dart';
import 'package:dr_urticaria/medical_record_v2/cubits/acute_urticaria/acute_urticaria_cubit.dart';
import 'package:dr_urticaria/medical_record_v2/cubits/acute_urticaria/acute_urticaria_state.dart';
import 'package:dr_urticaria/screens/dashboard/doctor_dashboard.dart';
import 'package:dr_urticaria/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/acute_urticaria_record.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_radio_group.dart';
import '../widgets/custom_checkbox_group.dart';
import '../widgets/custom_multiple_choice_with_images.dart';
import '../widgets/image_upload_widget.dart';
import '../widgets/section_header.dart';

class AcuteUrticariaFormScreen extends StatefulWidget {
  const AcuteUrticariaFormScreen({Key? key}) : super(key: key);

  @override
  State<AcuteUrticariaFormScreen> createState() =>
      _AcuteUrticariaFormScreenState();
}

class _AcuteUrticariaFormScreenState extends State<AcuteUrticariaFormScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 8;

  final AcuteUrticariaRecord _record = AcuteUrticariaRecord();
  Map<String, List<String>> _rashLocationImages = {};
  Map<String, List<String>> _angioedemaLocationImages = {};

  final List<String> _stepTitles = [
    'Thông tin cơ bản',
    'Bệnh án cấp tính',
    'Sẩn phù',
    'Phù mạch',
    'Yếu tố khởi phát',
    'Khám thực thể',
    'Chẩn đoán & Xét nghiệm',
    'Điều trị & Hẹn tái khám',
  ];

  // Face sub-options for location selection
  final Map<String, List<String>> _faceSubOptions = {
    'Mặt': ['Mặt thẳng', 'Nghiêng trái', 'Nghiêng phải'],
  };

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitForm() {
    // Update record with image data
    _record.rash?.rashLocationImages = _rashLocationImages;
    _record.angioedema?.angioedemaLocationImages = _angioedemaLocationImages;

    context.read<AcuteUrticariaCubit>().submitForm(_record);
  }

  int _calculateWeeksBetween(String? startMonth, String? startYear,
      String? endMonth, String? endYear) {
    if (startYear == null || endYear == null) return 0;

    try {
      int startM = startMonth != null ? int.parse(startMonth) : 1;
      int startY = int.parse(startYear);
      int endM = endMonth != null ? int.parse(endMonth) : 12;
      int endY = int.parse(endYear);

      DateTime startDate = DateTime(startY, startM);
      DateTime endDate = DateTime(endY, endM);

      return endDate.difference(startDate).inDays ~/ 7;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Bệnh án cấp tính - ${_stepTitles[_currentStep]}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocListener<AcuteUrticariaCubit, AcuteUrticariaState>(
        listener: (context, state) async {
          if (state is AcuteUrticariaSubmitted) {
            context.showSnackBarSuccess(
                text: "Tạo yêu cầu thành công", positionTop: true);
            await Future.delayed(Duration(seconds: 2));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDashboard(),
                ));
          } else if (state is AcuteUrticariaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bước ${_currentStep + 1}/$_totalSteps',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / _totalSteps,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor),
                  ),
                ],
              ),
            ),
            // Form content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildRootInfoStep(),
                  _buildBasicInfoStep(),
                  _buildChronicUrticariaStep(),
                  _buildOutbreakHistoryStep(),
                  _buildRashStep(),
                  _buildAngioedemaStep(),
                  _buildDiseasedHistoryStep(),
                  _buildTriggerFactorsStep(),
                  _buildPhysicalExamStep(),
                  _buildDiagnosisStep(),
                  _buildTreatmentStep(),
                  _buildCompletionStep(),
                ],
              ),
            ),
            // Navigation buttons
            BlocBuilder<AcuteUrticariaCubit, AcuteUrticariaState>(
              builder: (context, state) {
                final isSubmitting = state is AcuteUrticariaSubmitting;

                return Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : _previousStep,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Quay lại'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : (_currentStep == _totalSteps - 1
                                  ? _submitForm
                                  : _nextStep),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(_currentStep == _totalSteps - 1
                                  ? 'Hoàn thành'
                                  : 'Tiếp theo'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------- Step 0: Root Info -----------------
  Widget _buildRootInfoStep() {
    return Column(
      children: [
        const SectionHeader(
            title: "Thông tin hồ sơ",
            icon: Icons.folder,
            color: AppColors.primaryColor),
        CustomTextField(
          label: "Patient ID (bắt buộc)",
          value: _record.patientId?.toString(),
          keyboardType: TextInputType.number,
          onChanged: (v) => _record.patientId = int.tryParse(v) ?? 0,
        ),
        CustomTextField(
          label: "Triệu chứng",
          value: _record.symptoms,
          onChanged: (v) => _record.symptoms = v,
        ),
        CustomTextField(
          label: "Ghi chú",
          value: _record.notes,
          onChanged: (v) => _record.notes = v,
        ),
      ],
    );
  }

  Widget _buildBasicInfoStep() {
    _record.personalInfo ??= PersonalInfo();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Thông tin cơ bản của bệnh nhân',
            icon: Icons.person,
            color: AppColors.primaryColor,
          ),
          CustomTextField(
            label: 'Họ và tên',
            value: _record.personalInfo?.fullName,
            onChanged: (value) => _record.personalInfo?.fullName = value,
            isRequired: true,
          ),
          CustomTextField(
            label: 'Số căn cước công dân',
            value: _record.personalInfo?.nationalId,
            onChanged: (value) => _record.personalInfo?.nationalId = value,
            isRequired: true,
          ),
          CustomTextField(
            label: 'Tuổi',
            value: _record.personalInfo?.age,
            onChanged: (value) => _record.personalInfo?.age = value,
            hint: 'Nếu dưới 6 tuổi thì ghi theo tháng',
            keyboardType: TextInputType.number,
          ),
          CustomRadioGroup(
            label: 'Giới tính',
            value: _record.personalInfo?.gender == 0 ? "Nam" : "Nữ",
            options: const ['Nam', 'Nữ'],
            onChanged: (value) => setState(
                () => _record.personalInfo?.gender = value == "Nam" ? 0 : 1),
          ),
          CustomTextField(
            label: 'Số điện thoại',
            value: _record.personalInfo?.phoneNumber,
            onChanged: (value) => _record.personalInfo?.phoneNumber = value,
            isRequired: true,
            keyboardType: TextInputType.phone,
          ),
          CustomRadioGroup(
            label: 'Khu vực sinh sống',
            value: _record.personalInfo?.addressArea,
            options: const ['Thành thị', 'Nông thôn', 'Miền biển', 'Vùng núi'],
            onChanged: (value) =>
                setState(() => _record.personalInfo?.addressArea = value),
          ),
          CustomRadioGroup(
            label: 'Nghề nghiệp',
            value: _record.personalInfo?.occupation,
            options: const [
              'Công nhân',
              'Nông dân',
              'HS-SV',
              'Cán bộ công chức',
              'Khác'
            ],
            onChanged: (value) =>
                setState(() => _record.personalInfo?.occupation = value),
            isRequired: true,
          ),
          CustomRadioGroup(
            label: 'Tiền sử tiếp xúc',
            value: _record.personalInfo?.exposureHistory,
            options: const ['Hóa chất', 'Ánh sáng', 'Bụi', 'Khác', 'Không'],
            onChanged: (value) =>
                setState(() => _record.personalInfo?.exposureHistory = value),
            isRequired: true,
          ),
          CustomTextField(
            label: 'Ngày mở hồ sơ',
            value: _record.personalInfo?.recordOpenDate,
            onChanged: (value) => _record.personalInfo?.recordOpenDate = value,
            hint: 'dd/mm/yyyy',
            keyboardType: TextInputType.datetime,
          ),
          CustomTextField(
            label: 'Ngày khám',
            value: _record.personalInfo?.examinationDate,
            onChanged: (value) => _record.personalInfo?.examinationDate = value,
            hint: 'dd/mm/yyyy',
            keyboardType: TextInputType.datetime,
          ),
        ],
      ),
    );
  }

  Widget _buildChronicUrticariaStep() {
    _record.generalInfo ??= GeneralInfo();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Bệnh án mãn tính lần 1 - phần chung',
            icon: Icons.medical_services,
            color: AppColors.primaryColor,
          ),
          // CustomRadioGroup(
          //   label: 'Đợt bệnh ≥ 6 tuần',
          //   value: _record.continuousOutbreak6Weeks,
          //   options: const ['Có', 'Không'],
          //   onChanged: (value) =>
          //       setState(() => _record.continuousOutbreak6Weeks = value),
          // ),
          CustomRadioGroup(
            label: 'Loại tổn thương',
            value: _record.generalInfo?.rashOrAngioedema,
            options: const ['Sẩn phù', 'Phù mạch', 'Cả hai'],
            onChanged: (value) =>
                setState(() => _record.generalInfo?.rashOrAngioedema = value),
          ),
          CustomTextField(
            label: 'Lần đầu tổn thương từ bao nhiêu tuần',
            value: _record.generalInfo?.firstOutbreakSinceWeeks.toString(),
            onChanged: (value) => setState(() => _record
                .generalInfo?.firstOutbreakSinceWeeks = int.parse(value)),
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Số đợt bị mày đay (≥ 2 lần/tuần)',
            value: _record.generalInfo?.outbreakCount.toString(),
            onChanged: (value) => setState(
                () => _record.generalInfo?.outbreakCount = int.parse(value)),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildOutbreakHistoryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Lịch sử các đợt bệnh chi tiết',
            icon: Icons.history,
            color: AppColors.primaryColor,
          ),
          // Đợt 1
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue[200]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đợt 1',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Từ tháng',
                        value: _record.generalInfo?.outbreak1StartMonth,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak1StartMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.generalInfo?.outbreak1StartYear,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak1StartYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Đến tháng',
                        value: _record.generalInfo?.outbreak1EndMonth,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak1EndMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.generalInfo?.outbreak1EndYear,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak1EndYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                CustomRadioGroup(
                  label: 'Có điều trị trong đợt hay không',
                  value: _record.generalInfo?.outbreak1TreatmentReceived,
                  options: const ['Có', 'Không', 'Không nhớ'],
                  onChanged: (value) => setState(() =>
                      _record.generalInfo?.outbreak1TreatmentReceived = value),
                ),
                if (_record.generalInfo?.outbreak1TreatmentReceived ==
                    'Có') ...[
                  CustomRadioGroup(
                    label: 'Đáp ứng điều trị',
                    value: _record.generalInfo?.outbreak1DrugResponse,
                    options: const [
                      'Khỏi hoàn toàn',
                      'Không khỏi',
                      'Giảm',
                      'Nặng lên'
                    ],
                    onChanged: (value) => setState(() =>
                        _record.generalInfo?.outbreak1DrugResponse = value),
                  ),
                  if (_record.generalInfo?.outbreak1DrugResponse == 'Giảm' ||
                      _record.generalInfo?.outbreak1DrugResponse == 'Nặng lên')
                    CustomRadioGroup(
                      label: 'Triệu chứng giảm/nặng lên',
                      value: _record.generalInfo?.outbreak1DrugResponseSymptom,
                      options: const ['Nốt đỏ', 'Ngứa', 'Cả hai'],
                      onChanged: (value) => setState(() => _record
                          .generalInfo?.outbreak1DrugResponseSymptom = value),
                    ),
                ],
              ],
            ),
          ),

          // Đợt 2
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange[200]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.orange[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đợt 2',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Từ tháng',
                        value: _record.generalInfo?.outbreak2StartMonth,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak2StartMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm',
                        value: _record.generalInfo?.outbreak2StartYear,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak2StartYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Đến tháng',
                        value: _record.generalInfo?.outbreak2EndMonth,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak2EndMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm',
                        value: _record.generalInfo?.outbreak2EndYear,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak2EndYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                      ),
                    ),
                  ],
                ),
                CustomRadioGroup(
                  label: 'Có điều trị trong đợt hay không',
                  value: _record.generalInfo?.outbreak2TreatmentReceived,
                  options: const ['Có', 'Không', 'Không nhớ'],
                  onChanged: (value) => setState(() =>
                      _record.generalInfo?.outbreak2TreatmentReceived = value),
                ),
                if (_record.generalInfo?.outbreak2TreatmentReceived ==
                    'Có') ...[
                  CustomRadioGroup(
                    label: 'Đáp ứng điều trị',
                    value: _record.generalInfo?.outbreak2DrugResponse,
                    options: const [
                      'Khỏi hoàn toàn',
                      'Không khỏi',
                      'Giảm',
                      'Nặng lên'
                    ],
                    onChanged: (value) => setState(() =>
                        _record.generalInfo?.outbreak2DrugResponse = value),
                  ),
                  if (_record.generalInfo?.outbreak2DrugResponse == 'Giảm' ||
                      _record.generalInfo?.outbreak2DrugResponse == 'Nặng lên')
                    CustomRadioGroup(
                      label: 'Triệu chứng giảm/nặng lên',
                      value: _record.generalInfo?.outbreak2DrugResponseSymptom,
                      options: const ['Nốt đỏ', 'Ngứa', 'Cả hai'],
                      onChanged: (value) => setState(() => _record
                          .generalInfo?.outbreak2DrugResponseSymptom = value),
                    ),
                ],
              ],
            ),
          ),

          // Đợt 3
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green[200]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.green[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đợt 3',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Từ tháng',
                        value: _record.generalInfo?.outbreak3StartMonth,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak3StartMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm',
                        value: _record.generalInfo?.outbreak3StartYear,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak3StartYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Đến tháng',
                        value: _record.generalInfo?.outbreak3EndMonth,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak3EndMonth = value),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm',
                        value: _record.generalInfo?.outbreak3EndYear,
                        onChanged: (value) => setState(() =>
                            _record.generalInfo?.outbreak3EndYear = value),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                      ),
                    ),
                  ],
                ),
                CustomRadioGroup(
                  label: 'Có điều trị trong đợt hay không',
                  value: _record.generalInfo?.outbreak3TreatmentReceived,
                  options: const ['Có', 'Không', 'Không nhớ'],
                  onChanged: (value) => setState(() =>
                      _record.generalInfo?.outbreak3TreatmentReceived = value),
                ),
                if (_record.generalInfo?.outbreak3TreatmentReceived ==
                    'Có') ...[
                  CustomRadioGroup(
                    label: 'Đáp ứng điều trị',
                    value: _record.generalInfo?.outbreak3DrugResponse,
                    options: const [
                      'Khỏi hoàn toàn',
                      'Không khỏi',
                      'Giảm',
                      'Nặng lên'
                    ],
                    onChanged: (value) => setState(() =>
                        _record.generalInfo?.outbreak3DrugResponse = value),
                  ),
                  if (_record.generalInfo?.outbreak3DrugResponse == 'Giảm' ||
                      _record.generalInfo?.outbreak3DrugResponse == 'Nặng lên')
                    CustomRadioGroup(
                      label: 'Triệu chứng giảm/nặng lên',
                      value: _record.generalInfo?.outbreak3DrugResponseSymptom,
                      options: const ['Nốt đỏ', 'Ngứa', 'Cả hai'],
                      onChanged: (value) => setState(() => _record
                          .generalInfo?.outbreak3DrugResponseSymptom = value),
                    ),
                ],
              ],
            ),
          ),

          // Đợt hiện tại
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red[200]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.red[50],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Đợt hiện tại',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Từ tháng',
                        value: _record.generalInfo?.currentOutbreakStartMonth,
                        onChanged: (value) => setState(() {
                          _record.generalInfo?.currentOutbreakStartMonth =
                              value;
                          _record.generalInfo?.currentOutbreakWeeks =
                              _calculateWeeksBetween(
                            _record.generalInfo?.currentOutbreakStartMonth,
                            _record.generalInfo?.currentOutbreakStartYear,
                            _record.generalInfo?.currentOutbreakEndMonth,
                            _record.generalInfo?.currentOutbreakEndYear,
                          ).toString();
                        }),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.generalInfo?.currentOutbreakStartYear,
                        onChanged: (value) => setState(() {
                          _record.generalInfo?.currentOutbreakStartYear = value;
                          _record.generalInfo?.currentOutbreakWeeks =
                              _calculateWeeksBetween(
                            _record.generalInfo?.currentOutbreakStartMonth,
                            _record.generalInfo?.currentOutbreakStartYear,
                            _record.generalInfo?.currentOutbreakEndMonth,
                            _record.generalInfo?.currentOutbreakEndYear,
                          ).toString();
                        }),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Đến tháng',
                        value: _record.generalInfo?.currentOutbreakEndMonth,
                        onChanged: (value) => setState(() {
                          _record.generalInfo?.currentOutbreakEndMonth = value;
                          _record.generalInfo?.currentOutbreakWeeks =
                              _calculateWeeksBetween(
                            _record.generalInfo?.currentOutbreakStartMonth,
                            _record.generalInfo?.currentOutbreakStartYear,
                            _record.generalInfo?.currentOutbreakEndMonth,
                            _record.generalInfo?.currentOutbreakEndYear,
                          ).toString();
                        }),
                        keyboardType: TextInputType.number,
                        hint: '01-12',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomTextField(
                        label: 'Năm *',
                        value: _record.generalInfo?.currentOutbreakEndYear,
                        onChanged: (value) => setState(() {
                          _record.generalInfo?.currentOutbreakEndYear = value;
                          _record.generalInfo?.currentOutbreakWeeks =
                              _calculateWeeksBetween(
                            _record.generalInfo?.currentOutbreakStartMonth,
                            _record.generalInfo?.currentOutbreakStartYear,
                            _record.generalInfo?.currentOutbreakEndMonth,
                            _record.generalInfo?.currentOutbreakEndYear,
                          ).toString();
                        }),
                        keyboardType: TextInputType.number,
                        hint: 'YYYY',
                        isRequired: true,
                      ),
                    ),
                  ],
                ),
                if (_record.generalInfo?.currentOutbreakWeeks != null &&
                    _record.generalInfo!.currentOutbreakWeeks!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Đợt này bạn bị: ${_record.generalInfo?.currentOutbreakWeeks} tuần',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                CustomRadioGroup(
                  label: 'Có điều trị trong đợt hay không',
                  value: _record.generalInfo?.currentTreatmentReceived,
                  options: const ['Có', 'Không', 'Không nhớ'],
                  onChanged: (value) => setState(() =>
                      _record.generalInfo?.currentTreatmentReceived = value),
                ),
                if (_record.generalInfo?.currentTreatmentReceived == 'Có') ...[
                  CustomRadioGroup(
                    label: 'Đáp ứng điều trị',
                    value: _record.generalInfo?.currentDrugResponse,
                    options: const [
                      'Khỏi hoàn toàn',
                      'Không khỏi',
                      'Giảm',
                      'Nặng lên'
                    ],
                    onChanged: (value) => setState(
                        () => _record.generalInfo?.currentDrugResponse = value),
                  ),
                  if (_record.generalInfo?.currentDrugResponse == 'Giảm' ||
                      _record.generalInfo?.currentDrugResponse == 'Nặng lên')
                    CustomRadioGroup(
                      label: 'Triệu chứng giảm/nặng lên',
                      value: _record.generalInfo?.currentDrugResponseSymptom,
                      options: const ['Nốt đỏ', 'Ngứa', 'Cả hai'],
                      onChanged: (value) => setState(() => _record
                          .generalInfo?.currentDrugResponseSymptom = value),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRashStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Sẩn phù',
            icon: Icons.healing,
            color: AppColors.primaryColor,
          ),
          CustomRadioGroup(
            label: 'Nốt đỏ xuất hiện khi nào?',
            value: _record.rash?.rashAppearanceTime,
            options: const [
              'Một cách ngẫu nhiên',
              'Khi có các yếu tố kích thích'
            ],
            onChanged: (value) =>
                setState(() => _record.rash?.rashAppearanceTime = value),
          ),
          if (_record.rash?.rashAppearanceTime ==
              'Khi có các yếu tố kích thích')
            CustomCheckboxGroup(
              label: 'Các yếu tố kích thích',
              selectedValues: _record.rash?.rashTriggerFactors ?? [],
              options: const [
                'Gãi, chà xát, sau tắm',
                'Ra mồ hôi, +/- vận động',
                'Không có mồ hôi, +/- ngâm tắm nước nóng',
                'Khi thời tiết lạnh + nhiệt lượng cơ thể tăng',
                'Mang vật nặng',
                'Tiếp xúc với đồ vật lạnh',
                'Tiếp xúc với ánh sáng',
                'Do rung',
                'Do các chất cụ thể'
              ],
              onChanged: (values) =>
                  setState(() => _record.rash?.rashTriggerFactors = values),
            ),
          CustomCheckboxGroup(
            label: 'Yếu tố làm nặng bệnh',
            selectedValues: _record.rash?.rashWorseningFactors ?? [],
            options: const ['Stress', 'Thức ăn', 'Chống viêm, giảm đau'],
            onChanged: (values) =>
                setState(() => _record.rash?.rashWorseningFactors = values),
          ),
          if (_record.rash?.rashWorseningFactors?.contains('Thức ăn') == true)
            CustomTextField(
              label: 'Chi tiết thức ăn gây nặng bệnh',
              value: _record.rash?.rashFoodTriggerDetail,
              onChanged: (value) => _record.rash?.rashFoodTriggerDetail = value,
            ),
          if (_record.rash?.rashWorseningFactors
                  ?.contains('Chống viêm, giảm đau') ==
              true)
            CustomTextField(
              label: 'Chi tiết thuốc gây nặng bệnh',
              value: _record.rash?.rashDrugTriggerDetail,
              onChanged: (value) => _record.rash?.rashDrugTriggerDetail = value,
            ),
          CustomMultipleChoiceWithImages(
            label: 'Vị trí nốt đỏ',
            selectedValues: _record.rash?.rashLocation ?? [],
            options: const [
              'Mặt',
              'Miệng',
              'Thân',
              'Bàn tay (chụp ảnh 2 bàn tay)',
              'Cẳng tay',
              'Cánh tay',
              'Sinh dục',
              'Đùi',
              'Cẳng chân',
              'Bàn chân (chụp ảnh 2 bàn chân)'
            ],
            subOptions: _faceSubOptions,
            imagePaths: _rashLocationImages,
            onChanged: (values) =>
                setState(() => _record.rash?.rashLocation = values),
            onImagesChanged: (images) =>
                setState(() => _rashLocationImages = images),
          ),
          CustomRadioGroup(
            label: 'Kích thước nốt đỏ khi dùng thuốc',
            value: _record.rash?.rashSizeOnTreatment,
            options: const ['<3mm', '3-10mm', '10-50mm', '>50mm'],
            onChanged: (value) =>
                setState(() => _record.rash?.rashSizeOnTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Kích thước nốt đỏ khi không dùng thuốc',
            value: _record.rash?.rashSizeNoTreatment,
            options: const ['<3mm', '3-10mm', '10-50mm', '>50mm'],
            onChanged: (value) =>
                setState(() => _record.rash?.rashSizeNoTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Ranh giới nốt đỏ',
            value: _record.rash?.rashBorder,
            options: const ['Có bờ', 'Không bờ'],
            onChanged: (value) =>
                setState(() => _record.rash?.rashBorder = value),
          ),
          CustomRadioGroup(
            label: 'Hình dạng',
            value: _record.rash?.rashShape,
            options: const ['Tròn/Oval', 'Dài', 'Hình dạng khác'],
            onChanged: (value) =>
                setState(() => _record.rash?.rashShape = value),
          ),
          CustomRadioGroup(
            label: 'Màu sắc',
            value: _record.rash?.rashColor,
            options: const [
              'Trùng màu da',
              'Đỏ hồng',
              'Trắng',
              'Xuất huyết (đỏ đậm, tím)',
              'Có quầng trắng xung quanh nốt đỏ'
            ],
            onChanged: (value) =>
                setState(() => _record.rash?.rashColor = value),
          ),
          CustomRadioGroup(
            label: 'Thời gian tồn tại khi dùng thuốc',
            value: _record.rash?.rashDurationOnTreatment,
            options: const ['<1h', '1h-6h', '6h-12h', '12h-24h', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.rash?.rashDurationOnTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Thời gian tồn tại khi không dùng thuốc',
            value: _record.rash?.rashDurationNoTreatment,
            options: const ['<1h', '1h-6h', '6h-12h', '12h-24h', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.rash?.rashDurationNoTreatment = value),
          ),
          CustomCheckboxGroup(
            label: 'Đặc điểm bề mặt',
            selectedValues: _record.rash?.rashSurface ?? [],
            options: const [
              'Có vảy',
              'Có mụn nước',
              'Có giãn mạch',
              'Không vảy',
              'Không mụn nước',
              'Không giãn mạch',
            ],
            onChanged: (values) =>
                setState(() => _record.rash?.rashSurface = values),
          ),
          CustomRadioGroup(
            label: 'Thời điểm xuất hiện nốt đỏ trong ngày',
            value: _record.rash?.rashTimeOfDay,
            options: const [
              'Sáng',
              'Trưa',
              'Chiều',
              'Tối',
              'Đêm',
              'Không có thời điểm cụ thể'
            ],
            onChanged: (value) =>
                setState(() => _record.rash?.rashTimeOfDay = value),
          ),
          CustomRadioGroup(
            label: 'Số lượng nốt đỏ trung bình/ngày',
            value: _record.rash?.rashCountPerDay,
            options: const ['0-20', '21-50', '>50'],
            onChanged: (value) =>
                setState(() => _record.rash?.rashCountPerDay = value),
          ),
          CustomRadioGroup(
            label: 'Cảm giác tại vị trí nốt đỏ',
            value: _record.rash?.rashSensation,
            options: const ['Ngứa', 'Bỏng rát', 'Tức', 'Đau'],
            onChanged: (value) =>
                setState(() => _record.rash?.rashSensation = value),
          ),
        ],
      ),
    );
  }

  Widget _buildAngioedemaStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Phù mạch',
            icon: Icons.face,
            color: AppColors.primaryColor,
          ),
          CustomTextField(
            label: 'Số lần bị sưng phù từ trước đến nay',
            value: _record.angioedema?.angioedemaCount.toString(),
            onChanged: (value) =>
                _record.angioedema?.angioedemaCount = int.parse(value),
            keyboardType: TextInputType.number,
          ),
          CustomMultipleChoiceWithImages(
            label: 'Vị trí sưng phù',
            selectedValues: _record.angioedema?.angioedemaLocation ?? [],
            options: const [
              'Mắt',
              'Môi',
              'Lưỡi',
              'Thanh quản',
              'Sinh dục',
              'Bàn tay',
              'Bàn chân',
              'Khác'
            ],
            imagePaths: _angioedemaLocationImages,
            onChanged: (values) =>
                setState(() => _record.angioedema?.angioedemaLocation = values),
            onImagesChanged: (images) =>
                setState(() => _angioedemaLocationImages = images),
          ),
          CustomCheckboxGroup(
            label: 'Đặc điểm bề mặt',
            selectedValues: _record.angioedema?.angioedemaSurface ?? [],
            options: const [
              'Có vảy',
              'Có mụn nước',
              'Có giãn mạch',
              'Không vảy',
              'Không mụn nước',
              'Không giãn mạch',
            ],
            onChanged: (values) =>
                setState(() => _record.angioedema?.angioedemaSurface = values),
          ),
          CustomRadioGroup(
            label: 'Thời gian tồn tại khi dùng thuốc',
            value: _record.angioedema?.angioedemaDurationOnTreatment,
            options: const [
              '<1h',
              '1h-6h',
              '6h-12h',
              '12h-24h',
              '24h-48h',
              '48h-72h',
              '>72h',
              'Không biết'
            ],
            onChanged: (value) => setState(() =>
                _record.angioedema?.angioedemaDurationOnTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Thời gian tồn tại khi không dùng thuốc',
            value: _record.angioedema?.angioedemaDurationNoTreatment,
            options: const [
              '<1h',
              '1h-6h',
              '6h-12h',
              '12h-24h',
              '24h-48h',
              '48h-72h',
              '>72h',
              'Không biết'
            ],
            onChanged: (value) => setState(() =>
                _record.angioedema?.angioedemaDurationNoTreatment = value),
          ),
          CustomRadioGroup(
            label: 'Thời điểm xuất hiện sưng phù trong ngày',
            value: _record.angioedema?.angioedemaTimeOfDay,
            options: const [
              'Sáng',
              'Trưa',
              'Chiều',
              'Tối',
              'Đêm',
              'Không có thời điểm cụ thể'
            ],
            onChanged: (value) =>
                setState(() => _record.angioedema?.angioedemaTimeOfDay = value),
          ),
          CustomRadioGroup(
            label: 'Cảm giác tại vị trí sưng phù',
            value: _record.angioedema?.angioedemaSensation,
            options: const ['Ngứa', 'Bỏng rát', 'Tức', 'Đau'],
            onChanged: (value) =>
                setState(() => _record.angioedema?.angioedemaSensation = value),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDiseasedHistoryStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomRadioGroup(
          label:
              'Bạn đã bao giờ phải khám cấp cứu/nằm viện vì bệnh này hay chưa?',
          value: _record.diseasedHistory?.emergencyVisitHistory,
          options: const ['Rồi', 'Chưa'],
          onChanged: (value) => setState(
              () => _record.diseasedHistory?.emergencyVisitHistory = value),
        ),
        CustomRadioGroup(
          label:
              'Bạn đã bao giờ bị khó thở trong đợt bệnh này (liên quan đến bệnh mề đay) hay chưa?',
          value: _record.diseasedHistory?.breathingDifficultyHistory,
          options: const ['Có', 'Không'],
          onChanged: (value) => setState(() =>
              _record.diseasedHistory?.breathingDifficultyHistory = value),
        ),
      ]),
    );
  }

  Widget _buildTriggerFactorsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Yếu tố khởi phát & Tiền sử',
            icon: Icons.history,
            color: AppColors.primaryColor,
          ),
          const Text(
            'Yếu tố khởi phát',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          CustomRadioGroup(
            label: 'Triệu chứng nhiễm trùng',
            value: _record.triggerPersonal?.triggerInfection,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) => setState(
                () => _record.triggerPersonal?.triggerInfection = value),
          ),
          CustomRadioGroup(
            label: 'Thức ăn',
            value: _record.triggerPersonal?.triggerFood,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.triggerPersonal?.triggerFood = value),
          ),
          CustomRadioGroup(
            label: 'Thuốc',
            value: _record.triggerPersonal?.triggerDrug,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) =>
                setState(() => _record.triggerPersonal?.triggerDrug = value),
          ),
          CustomRadioGroup(
            label: 'Côn trùng đốt',
            value: _record.triggerPersonal?.triggerInsectBite,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) => setState(
                () => _record.triggerPersonal?.triggerInsectBite = value),
          ),
          CustomTextField(
            label: 'Khác (ghi rõ)',
            value: _record.triggerPersonal?.triggerOther,
            onChanged: (value) => _record.triggerPersonal?.triggerOther = value,
          ),
          const SizedBox(height: 24),
          const Text(
            'Tiền sử bản thân',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          CustomRadioGroup(
            label: 'Tiền sử dị ứng',
            value: _record.triggerPersonal?.personalAllergyHistory,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) => setState(
                () => _record.triggerPersonal?.personalAllergyHistory = value),
          ),
          CustomRadioGroup(
            label: 'Tiền sử dị ứng thuốc',
            value: _record.triggerPersonal?.personalDrugHistory,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) => setState(
                () => _record.triggerPersonal?.personalDrugHistory = value),
          ),
          CustomRadioGroup(
            label: 'Tiền sử mắc mày đay',
            value: _record.triggerPersonal?.personalUrticariaHistory,
            options: const ['Có', 'Không', 'Không biết'],
            onChanged: (value) => setState(() =>
                _record.triggerPersonal?.personalUrticariaHistory = value),
          ),
          CustomTextField(
            label: 'Tiền sử bệnh khác (ghi rõ)',
            value: _record.triggerPersonal?.personalOtherHistory,
            onChanged: (value) =>
                _record.triggerPersonal?.personalOtherHistory = value,
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalExamStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Khám thực thể',
            icon: Icons.monitor_heart,
            color: AppColors.primaryColor,
          ),
          CustomRadioGroup(
            label: 'Có sốt hay không',
            value: _record.physicalExam?.fever,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.physicalExam?.fever = value),
          ),
          if (_record.physicalExam?.fever == 'Có')
            CustomTextField(
              label: 'Nhiệt độ cơ thể khi sốt (°C)',
              value: _record.physicalExam?.feverTemperature,
              onChanged: (value) =>
                  _record.physicalExam?.feverTemperature = value,
              keyboardType: TextInputType.number,
            ),
          CustomTextField(
            label: 'Mạch (lần/phút)',
            value: _record.physicalExam?.pulseRate,
            onChanged: (value) => _record.physicalExam?.pulseRate = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Huyết áp (mmHg)',
            value: _record.physicalExam?.bloodPressure,
            onChanged: (value) => _record.physicalExam?.bloodPressure = value,
            keyboardType: TextInputType.text,
            hint: 'Ví dụ: 120/80',
          ),
          CustomRadioGroup(
            label: 'Có bất thường cơ quan khác hay không',
            value: _record.physicalExam?.organAbnormality,
            options: const ['Có', 'Không', 'Không rõ'],
            onChanged: (value) =>
                setState(() => _record.physicalExam?.organAbnormality = value),
          ),
          if (_record.physicalExam?.organAbnormality == 'Có')
            CustomTextField(
              label: 'Mô tả chi tiết bất thường cơ quan',
              value: _record.physicalExam?.organAbnormalityDetail,
              onChanged: (value) =>
                  _record.physicalExam?.organAbnormalityDetail = value,
              maxLines: 3,
            ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Chẩn đoán sơ bộ',
            value: _record.physicalExam?.preliminaryDiagnosis,
            onChanged: (value) =>
                _record.physicalExam?.preliminaryDiagnosis = value,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Kết quả test & Cận lâm sàng',
            icon: Icons.science,
            color: AppColors.primaryColor,
          ),
          // Test da vẽ nổi
          CustomRadioGroup(
            label: 'Kết quả da vẽ nổi (Dermatographism)',
            value: _record.diagnosis?.dermatographismTest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.diagnosis?.dermatographismTest = val),
          ),
          CustomTextField(
            label: 'Điểm Fric',
            value: _record.diagnosis?.fricScore,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.fricScore = val,
          ),
          CustomTextField(
            label: 'Điểm ngứa NRS',
            value: _record.diagnosis?.itchScoreNRS,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.itchScoreNRS = val,
            hint: '0-10',
          ),
          CustomTextField(
            label: 'Điểm đau NRS',
            value: _record.diagnosis?.painScoreNRS,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.painScoreNRS = val,
            hint: '0-10',
          ),
          CustomTextField(
            label: 'Điểm bỏng rát NRS',
            value: _record.diagnosis?.burningScoreNRS,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.burningScoreNRS = val,
            hint: '0-10',
          ),
          const SizedBox(height: 16),
          // Test mày đay do lạnh - Temptest
          CustomRadioGroup(
            label: 'Mày đay do lạnh (Temptest)',
            value: _record.diagnosis?.coldUrticariaTemptest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.diagnosis?.coldUrticariaTemptest = val),
          ),
          CustomTextField(
            label: 'Vùng nhiệt độ dương tính (°C)',
            value: _record.diagnosis?.positiveTemperature,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.positiveTemperature = val,
          ),
          CustomTextField(
            label: 'Điểm ngứa NRS (khi Temptest)',
            value: _record.diagnosis?.itchScoreNRSCold,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.itchScoreNRSCold = val,
            hint: '0-10',
          ),
          CustomTextField(
            label: 'Điểm đau NRS (khi Temptest)',
            value: _record.diagnosis?.painScoreNRSCold,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.painScoreNRSCold = val,
            hint: '0-10',
          ),
          CustomTextField(
            label: 'Điểm bỏng rát NRS (khi Temptest)',
            value: _record.diagnosis?.burningScoreNRSCold,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.burningScoreNRSCold = val,
            hint: '0-10',
          ),
          const SizedBox(height: 16),
          // Test mày đay do lạnh - Test cục đá
          CustomRadioGroup(
            label: 'Mày đay do lạnh - Test cục đá',
            value: _record.diagnosis?.coldUrticariaIceTest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) =>
                setState(() => _record.diagnosis?.coldUrticariaIceTest = val),
          ),
          CustomTextField(
            label: 'Ngưỡng thời gian (phút)',
            value: _record.diagnosis?.timeThreshold,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.timeThreshold = val,
          ),
          CustomTextField(
            label: 'Điểm ngứa NRS (khi Test cục đá)',
            value: _record.diagnosis?.itchScoreNRSIce,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.itchScoreNRSIce = val,
            hint: '0-10',
          ),
          CustomTextField(
            label: 'Điểm đau NRS (khi Test cục đá)',
            value: _record.diagnosis?.painScoreNRSIce,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.painScoreNRSIce = val,
            hint: '0-10',
          ),
          CustomTextField(
            label: 'Điểm bỏng rát NRS (khi Test cục đá)',
            value: _record.diagnosis?.burningScoreNRSIce,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.burningScoreNRSIce = val,
            hint: '0-10',
          ),
          const SizedBox(height: 16),
          // Test mày đay do choline
          CustomRadioGroup(
            label: 'Mày đay do choline',
            value: _record.diagnosis?.cholinergicUrticariaTest,
            options: const ['Dương tính', 'Âm tính'],
            onChanged: (val) => setState(
                () => _record.diagnosis?.cholinergicUrticariaTest = val),
          ),
          CustomTextField(
            label: 'Thời gian xuất hiện tổn thương (phút)',
            value: _record.diagnosis?.lesionAppearanceTime,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.lesionAppearanceTime = val,
          ),
          CustomTextField(
            label: 'Điểm ngứa NRS (khi test choline)',
            value: _record.diagnosis?.itchScoreNRSCholine,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.itchScoreNRSCholine = val,
            hint: '0-10',
          ),
          CustomTextField(
            label: 'Điểm đau NRS (khi test choline)',
            value: _record.diagnosis?.painScoreNRSCholine,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.painScoreNRSCholine = val,
            hint: '0-10',
          ),
          CustomTextField(
            label: 'Điểm bỏng rát NRS (khi test choline)',
            value: _record.diagnosis?.burningScoreNRSCholine,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.burningScoreNRSCholine = val,
            hint: '0-10',
          ),
          const SizedBox(height: 16),

          CustomTextField(
            label: 'Mức độ hoạt động bệnh CUSI',
            value: _record.diagnosis?.cusiScore,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.cusiScore = val,
          ),
          CustomTextField(
            label: 'Căn nguyên khác',
            value: _record.diagnosis?.otherCause,
            onChanged: (val) => _record.diagnosis?.otherCause = val,
            maxLines: 2,
          ),
          CustomTextField(
            label: 'Mức độ kiểm soát bệnh UCT',
            value: _record.diagnosis?.uctScore,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.uctScore = val,
            hint: '0-16',
          ),
          CustomTextField(
            label: 'Mức độ kiểm soát bệnh ACT',
            value: _record.diagnosis?.actScore,
            keyboardType: TextInputType.number,
            onChanged: (val) => _record.diagnosis?.actScore = val,
          ),
          const SizedBox(height: 16),
          const Text(
            'Cận lâm sàng',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'WBC (G/L)',
            value: _record.diagnosis?.wbc,
            onChanged: (value) => _record.diagnosis?.wbc = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'EO (%)',
            value: _record.diagnosis?.eo,
            onChanged: (value) => _record.diagnosis?.eo = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'BA (%)',
            value: _record.diagnosis?.ba,
            onChanged: (value) => _record.diagnosis?.ba = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'CRP (mg/L)',
            value: _record.diagnosis?.crp,
            onChanged: (value) => _record.diagnosis?.crp = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'ESR (mm/h)',
            value: _record.diagnosis?.esr,
            onChanged: (value) => _record.diagnosis?.esr = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'FT3 (pmol/L)',
            value: _record.diagnosis?.ft3,
            onChanged: (value) => _record.diagnosis?.ft3 = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'FT4 (pmol/L)',
            value: _record.diagnosis?.ft4,
            onChanged: (value) => _record.diagnosis?.ft4 = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'TSH (mIU/L)',
            value: _record.diagnosis?.tsh,
            onChanged: (value) => _record.diagnosis?.tsh = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Total IgE (kU/L)',
            value: _record.diagnosis?.totalIgE,
            onChanged: (value) => _record.diagnosis?.totalIgE = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Anti-TPO (IU/mL)',
            value: _record.diagnosis?.antiTPO,
            onChanged: (value) => _record.diagnosis?.antiTPO = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'ANA Hep-2',
            value: _record.diagnosis?.anaHep2,
            onChanged: (value) => _record.diagnosis?.anaHep2 = value,
          ),
          CustomTextField(
            label: 'Mô hình lắng đọng',
            value: _record.diagnosis?.depositionPattern,
            onChanged: (value) => _record.diagnosis?.depositionPattern = value,
          ),
          CustomTextField(
            label: 'Siêu âm tuyến giáp',
            value: _record.diagnosis?.thyroidUltrasound,
            onChanged: (value) => _record.diagnosis?.thyroidUltrasound = value,
            maxLines: 2,
          ),
          CustomTextField(
            label: 'Test huyết thanh tự thân',
            value: _record.diagnosis?.autologousSerumSkinTest,
            onChanged: (value) =>
                _record.diagnosis?.autologousSerumSkinTest = value,
          ),
          CustomTextField(
            label: 'Đường kính mối phù (mm)',
            value: _record.diagnosis?.whealDiameter,
            onChanged: (value) => _record.diagnosis?.whealDiameter = value,
            keyboardType: TextInputType.number,
          ),
          CustomTextField(
            label: 'Xét nghiệm khác',
            value: _record.diagnosis?.otherLabTests,
            onChanged: (value) => _record.diagnosis?.otherLabTests = value,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Chẩn đoán xác định',
            value: _record.diagnosis?.finalDiagnosis,
            onChanged: (value) => _record.diagnosis?.finalDiagnosis = value,
            maxLines: 3,
            isRequired: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Điều trị & Theo dõi',
            icon: Icons.medication,
            color: AppColors.primaryColor,
          ),
          CustomTextField(
            label: 'Thuốc điều trị',
            value: _record.treatment?.treatmentMedications,
            onChanged: (value) =>
                _record.treatment?.treatmentMedications = value,
            maxLines: 4,
            hint: 'Ghi rõ tên thuốc, liều dùng, cách dùng',
            isRequired: true,
          ),
          CustomTextField(
            label: 'Hẹn khám lại',
            value: _record.treatment?.followUpDate,
            onChanged: (value) => _record.treatment?.followUpDate = value,
            hint: 'dd/mm/yyyy',
            keyboardType: TextInputType.datetime,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Hoàn thành bệnh án',
            icon: Icons.check_circle,
            color: AppColors.primaryColor,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border.all(color: Colors.green[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thông tin bệnh án mãn tính lần 1 đã được hoàn thành',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Bệnh nhân: ${_record.personalInfo?.fullName ?? "Chưa nhập"}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Số CCCD: ${_record.personalInfo?.nationalId ?? "Chưa nhập"}',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'SĐT: ${_record.personalInfo?.phoneNumber ?? "Chưa nhập"}',
                  style: const TextStyle(fontSize: 14),
                ),
                if (_record.personalInfo?.examinationDate != null)
                  Text(
                    'Ngày khám: ${_record.personalInfo?.examinationDate}',
                    style: const TextStyle(fontSize: 14),
                  ),
                if (_record.diagnosis?.finalDiagnosis != null)
                  Text(
                    'Chẩn đoán: ${_record.diagnosis?.finalDiagnosis}',
                    style: const TextStyle(fontSize: 14),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nhấn "Hoàn thành" để gửi bệnh án đến hệ thống.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
