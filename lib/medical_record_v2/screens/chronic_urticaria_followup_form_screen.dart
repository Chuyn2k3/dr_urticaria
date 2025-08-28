// import 'package:dr_urticaria/constant/color.dart';
// import 'package:dr_urticaria/medical_record_v2/cubits/chronic_followup/chronic_followup_cubit.dart';
// import 'package:dr_urticaria/medical_record_v2/cubits/chronic_followup/chronic_followup_state.dart';
// import 'package:dr_urticaria/screens/dashboard/doctor_dashboard.dart';
// import 'package:dr_urticaria/utils/snack_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../models/chronic_urticaria_followup_record.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/custom_radio_group.dart';
// import '../widgets/custom_checkbox_group.dart';
// import '../widgets/image_upload_widget.dart';
// import '../widgets/section_header.dart';

// class ChronicUrticariaFollowupFormScreen extends StatefulWidget {
//   const ChronicUrticariaFollowupFormScreen({Key? key}) : super(key: key);

//   @override
//   State<ChronicUrticariaFollowupFormScreen> createState() =>
//       _ChronicUrticariaFollowupFormScreenState();
// }

// class _ChronicUrticariaFollowupFormScreenState
//     extends State<ChronicUrticariaFollowupFormScreen> {
//   final PageController _pageController = PageController();
//   int _currentStep = 0;
//   final int _totalSteps = 6;

//   final ChronicUrticariaFollowupRecord _record =
//       ChronicUrticariaFollowupRecord();
//   List<String> _rashImages = [];
//   List<String> _angioedemaImages = [];

//   final List<String> _stepTitles = [
//     'Thông tin cơ bản',
//     'Hoạt động bệnh & Điều trị',
//     'Tác dụng phụ',
//     'Triệu chứng hiện tại',
//     'Kết quả test',
//     'Hoàn thành',
//   ];

//   // Helper function to calculate weeks between dates
//   int _calculateWeeks(DateTime start, DateTime? end) {
//     final endDate = end ?? DateTime.now();
//     final difference = endDate.difference(start).inDays;
//     return (difference / 7).round();
//   }

//   void _nextStep() {
//     if (_currentStep < _totalSteps - 1) {
//       setState(() {
//         _currentStep++;
//       });
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _previousStep() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep--;
//       });
//       _pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _submitForm() {
//     context.read<ChronicFollowupCubit>().submitForm(_record);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text(
//           'Bệnh án tái khám - ${_stepTitles[_currentStep]}',
//           style:
//               const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.orange,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: BlocListener<ChronicFollowupCubit, ChronicFollowupState>(
//         listener: (context, state) async {
//           if (state is ChronicFollowupSubmitted) {
//             context.showSnackBarSuccess(
//                 text: "Tạo yêu cầu thành công", positionTop: true);
//             await Future.delayed(const Duration(seconds: 2));
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const DoctorDashboard(),
//                 ));
//           } else if (state is ChronicFollowupError) {
//             context.showSnackBarFail(text: state.message, positionTop: true);
//           }
//         },
//         child: Column(
//           children: [
//             // Progress indicator
//             Container(
//               padding: const EdgeInsets.all(16),
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Bước ${_currentStep + 1}/$_totalSteps',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.orange,
//                         ),
//                       ),
//                       Text(
//                         '${((_currentStep + 1) / _totalSteps * 100).round()}%',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.orange,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   LinearProgressIndicator(
//                     value: (_currentStep + 1) / _totalSteps,
//                     backgroundColor: Colors.grey[300],
//                     valueColor:
//                         const AlwaysStoppedAnimation<Color>(Colors.orange),
//                   ),
//                 ],
//               ),
//             ),
//             // Form content
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   _buildRootInfoStep(),
//                   _buildBasicInfoStep(),
//                   _buildDiseaseActivityStep(),
//                   _buildSideEffectsStep(),
//                   _buildCurrentSymptomsStep(),
//                   _buildTestResultsStep(),
//                   _buildCompletionStep(),
//                 ],
//               ),
//             ),
//             // Navigation buttons
//             BlocBuilder<ChronicFollowupCubit, ChronicFollowupState>(
//               builder: (context, state) {
//                 final isSubmitting = state is ChronicFollowupSubmitting;

//                 return Container(
//                   padding: const EdgeInsets.all(16),
//                   color: Colors.white,
//                   child: Row(
//                     children: [
//                       if (_currentStep > 0)
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: isSubmitting ? null : _previousStep,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.grey[300],
//                               foregroundColor: Colors.black87,
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                             ),
//                             child: const Text('Quay lại'),
//                           ),
//                         ),
//                       if (_currentStep > 0) const SizedBox(width: 16),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: isSubmitting
//                               ? null
//                               : (_currentStep == _totalSteps - 1
//                                   ? _submitForm
//                                   : _nextStep),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.orange,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: isSubmitting
//                               ? const SizedBox(
//                                   height: 20,
//                                   width: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white),
//                                   ),
//                                 )
//                               : Text(_currentStep == _totalSteps - 1
//                                   ? 'Hoàn thành'
//                                   : 'Tiếp theo'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRootInfoStep() {
//     return Column(
//       children: [
//         const SectionHeader(
//             title: "Thông tin hồ sơ",
//             icon: Icons.folder,
//             color: AppColors.primaryColor),
//         CustomTextField(
//           label: "Patient ID (bắt buộc)",
//           value: _record.patientId?.toString(),
//           keyboardType: TextInputType.number,
//           onChanged: (v) => _record.patientId = int.tryParse(v) ?? 0,
//         ),
//         CustomTextField(
//           label: "Triệu chứng",
//           value: _record.symptoms,
//           onChanged: (v) => _record.symptoms = v,
//         ),
//         CustomTextField(
//           label: "Ghi chú",
//           value: _record.notes,
//           onChanged: (v) => _record.notes = v,
//         ),
//       ],
//     );
//   }

//   Widget _buildBasicInfoStep() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const SectionHeader(
//             title: 'Thông tin cơ bản',
//             icon: Icons.person,
//           ),
//           CustomTextField(
//             label: 'Họ và tên *',
//             value: _record.personalInfo?.fullName,
//             onChanged: (value) => _record.personalInfo?.fullName = value,
//             isRequired: true,
//           ),
//           CustomTextField(
//             label: 'Số căn cước công dân *',
//             value: _record.personalInfo?.nationalId,
//             onChanged: (value) => _record.personalInfo?.nationalId = value,
//             isRequired: true,
//           ),
//           CustomTextField(
//             label: 'Tuổi',
//             value: _record.personalInfo?.age,
//             onChanged: (value) => _record.personalInfo?.age = value,
//             hint: 'Nếu dưới 6 tuổi thì ghi theo tháng',
//             keyboardType: TextInputType.number,
//           ),
//           CustomRadioGroup(
//             label: 'Giới tính',
//             value: _record.personalInfo?.gender == 0 ? "Nam" : "Nữ",
//             options: const ['Nam', 'Nữ'],
//             onChanged: (value) => setState(
//                 () => _record.personalInfo?.gender = value == "Nam" ? 0 : 1),
//           ),
//           CustomTextField(
//             label: 'Số điện thoại *',
//             value: _record.personalInfo?.phoneNumber,
//             onChanged: (value) => _record.personalInfo?.phoneNumber = value,
//             keyboardType: TextInputType.phone,
//             isRequired: true,
//           ),
//           CustomRadioGroup(
//             label: 'Khu vực sinh sống',
//             value: _record.personalInfo?.addressArea,
//             options: const ['Thành thị', 'Nông thôn', 'Miền biển', 'Vùng núi'],
//             onChanged: (value) =>
//                 setState(() => _record.personalInfo?.addressArea = value),
//           ),
//           CustomRadioGroup(
//             label: 'Nghề nghiệp',
//             value: _record.personalInfo?.occupation,
//             options: const [
//               'Công nhân',
//               'Nông dân',
//               'HS-SV',
//               'Cán bộ công chức',
//               'Khác'
//             ],
//             onChanged: (value) =>
//                 setState(() => _record.personalInfo?.occupation = value),
//           ),
//           CustomRadioGroup(
//             label: 'Tiền sử tiếp xúc',
//             value: _record.personalInfo?.exposureHistory,
//             options: const ['Hóa chất', 'Ánh sáng', 'Bụi', 'Khác', 'Không'],
//             onChanged: (value) =>
//                 setState(() => _record.personalInfo?.exposureHistory = value),
//           ),
//           CustomTextField(
//             label: 'Ngày mở hồ sơ bệnh án',
//             value: _record.personalInfo?.recordOpenDate,
//             onChanged: (value) => _record.personalInfo?.recordOpenDate = value,
//             hint: 'dd/mm/yyyy',
//             keyboardType: TextInputType.datetime,
//           ),
//           CustomTextField(
//             label: 'Ngày khám bệnh',
//             value: _record.personalInfo?.examinationDate,
//             onChanged: (value) => _record.personalInfo?.examinationDate = value,
//             hint: 'dd/mm/yyyy',
//             keyboardType: TextInputType.datetime,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDiseaseActivityStep() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const SectionHeader(
//             title: 'Theo dõi hoạt động bệnh & kiểm soát bệnh',
//             icon: Icons.monitor_heart,
//           ),
//           // UAS7 khi dùng thuốc
//           const Text(
//             'UAS7 khi dùng thuốc',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 12),
//           CustomTextField(
//             label: 'Điểm ISS7 (khi dùng thuốc)',
//             value: _record.followUp?.uas7OnTreatmentISS7.toString(),
//             keyboardType: TextInputType.number,
//             onChanged: (val) =>
//                 _record.followUp?.uas7OnTreatmentISS7 = int.parse(val),
//             hint: '0-21',
//           ),
//           CustomTextField(
//             label: 'Điểm HSS7 (khi dùng thuốc)',
//             value: _record.followUp?.uas7OnTreatmentHSS7.toString(),
//             keyboardType: TextInputType.number,
//             onChanged: (val) =>
//                 _record.followUp?.uas7OnTreatmentHSS7 = int.parse(val),
//             hint: '0-21',
//           ),
//           const SizedBox(height: 16),
//           // UAS7 khi ngừng thuốc
//           const Text(
//             'UAS7 khi ngừng thuốc',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 12),
//           CustomTextField(
//             label: 'Điểm ISS7 (khi ngừng thuốc)',
//             value: _record.followUp?.uas7OffTreatmentISS7.toString(),
//             keyboardType: TextInputType.number,
//             onChanged: (val) =>
//                 _record.followUp?.uas7OffTreatmentISS7 = int.parse(val),
//             hint: '0-21',
//           ),
//           CustomTextField(
//             label: 'Điểm HSS7 (khi ngừng thuốc)',
//             value: _record.followUp?.uas7OffTreatmentHSS7.toString(),
//             keyboardType: TextInputType.number,
//             onChanged: (val) =>
//                 _record.followUp?.uas7OffTreatmentHSS7 = int.parse(val),
//             hint: '0-21',
//           ),
//           const SizedBox(height: 16),
//           CustomTextField(
//             label: 'Mức độ kiểm soát bệnh (UCT điểm)',
//             value: _record.followUp?.uctScore.toString(),
//             keyboardType: TextInputType.number,
//             onChanged: (val) => _record.followUp?.uctScore = int.parse(val),
//             hint: '0-16',
//           ),
//           CustomRadioGroup(
//             label: 'Mức độ đáp ứng điều trị',
//             value: _record.followUp?.treatmentResponse,
//             options: const [
//               'Kiểm soát hoàn toàn (UCT: 16, UAS7: 0)',
//               'Kiểm soát tốt, bệnh rất nhẹ (UCT: 12-15, UAS7: 1-6)',
//               'Kiểm soát kém, bệnh nhẹ (UCT: <12, UAS7: 7-15)',
//               'Kiểm soát kém, bệnh trung bình (UCT: <12, UAS7: 16-27)',
//               'Kiểm soát kém, bệnh cao (UCT: <12, UAS7: 28-42)',
//             ],
//             onChanged: (val) =>
//                 setState(() => _record.followUp?.treatmentResponse = val),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSideEffectsStep() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SectionHeader(
//             title: 'Tác dụng không mong muốn',
//             icon: Icons.report_problem,
//           ),
//           const Text('Toàn trạng'),
//           const SizedBox(height: 8),
//           CustomRadioGroup(
//             label: 'Mệt mỏi',
//             value:
//                 _record.sideEffects?.sideEffectFatigue == true ? "Có" : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() => _record
//                 .sideEffects?.sideEffectFatigue = val == "Có" ? true : false),
//           ),
//           const SizedBox(height: 16),
//           const Text('Thần kinh'),
//           const SizedBox(height: 8),
//           CustomRadioGroup(
//             label: 'Mệt mỏi',
//             value:
//                 _record.sideEffects?.sideEffectFatigue == true ? "Có" : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectFatigue = (val == "Có");
//             }),
//           ),
//           const SizedBox(height: 16),
//           const Text('Thần kinh'),
//           const SizedBox(height: 8),
//           CustomRadioGroup(
//             label: 'Đau đầu',
//             value: _record.sideEffects?.sideEffectHeadache == true
//                 ? "Có"
//                 : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectHeadache = (val == "Có");
//             }),
//           ),
//           CustomRadioGroup(
//             label: 'Chóng mặt',
//             value: _record.sideEffects?.sideEffectDizziness == true
//                 ? "Có"
//                 : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectDizziness = (val == "Có");
//             }),
//           ),
//           CustomRadioGroup(
//             label: 'Buồn ngủ',
//             value:
//                 _record.sideEffects?.sideEffectSleepy == true ? "Có" : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectSleepy = (val == "Có");
//             }),
//           ),
//           CustomRadioGroup(
//             label: 'Ngủ gà',
//             value: _record.sideEffects?.sideEffectDrowsiness == true
//                 ? "Có"
//                 : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectDrowsiness = (val == "Có");
//             }),
//           ),
//           const SizedBox(height: 16),
//           const Text('Tiêu hóa'),
//           const SizedBox(height: 8),
//           CustomRadioGroup(
//             label: 'Chán ăn',
//             value: _record.sideEffects?.sideEffectLossOfAppetite == true
//                 ? "Có"
//                 : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectLossOfAppetite = (val == "Có");
//             }),
//           ),
//           CustomRadioGroup(
//             label: 'Khó tiêu',
//             value: _record.sideEffects?.sideEffectIndigestion == true
//                 ? "Có"
//                 : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectIndigestion = (val == "Có");
//             }),
//           ),
//           CustomRadioGroup(
//             label: 'Đau bụng',
//             value: _record.sideEffects?.sideEffectAbdominalPain == true
//                 ? "Có"
//                 : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectAbdominalPain = (val == "Có");
//             }),
//           ),
//           const SizedBox(height: 16),
//           const Text('Tim mạch'),
//           const SizedBox(height: 8),
//           CustomRadioGroup(
//             label: 'Đau ngực',
//             value: _record.sideEffects?.sideEffectChestPain == true
//                 ? "Có"
//                 : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectChestPain = (val == "Có");
//             }),
//           ),
//           CustomRadioGroup(
//             label: 'Hồi hộp, trống ngực',
//             value: _record.sideEffects?.sideEffectPalpitations == true
//                 ? "Có"
//                 : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() {
//               _record.sideEffects ??= SideEffects();
//               _record.sideEffects!.sideEffectPalpitations = (val == "Có");
//             }),
//           ),
//           const SizedBox(height: 16),
//           CustomTextField(
//             label: 'Tác dụng phụ khác (ghi rõ)',
//             value: _record.sideEffects?.sideEffectOther,
//             onChanged: (val) =>
//                 setState(() => _record.sideEffects?.sideEffectOther = val),
//             maxLines: 3,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCurrentSymptomsStep() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SectionHeader(
//             title: 'Triệu chứng hiện tại',
//             icon: Icons.healing,
//           ),
//           CustomRadioGroup(
//             label: 'Có sẩn phù hay không',
//             value:
//                 _record.currentSymptoms?.rashPresent == true ? "Có" : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() => _record
//                 .currentSymptoms?.rashPresent = val == "Có" ? true : false),
//           ),
//           CustomRadioGroup(
//             label: 'Có phù mạch hay không',
//             value: _record.currentSymptoms?.angioedemaPresent == true
//                 ? "Có"
//                 : "Không",
//             options: const ['Có', 'Không'],
//             onChanged: (val) => setState(() => _record.currentSymptoms
//                 ?.angioedemaPresent = val == "Có" ? true : false),
//           ),
//           if (_record.currentSymptoms?.angioedemaPresent == true) ...[
//             const SizedBox(height: 16),
//             const Text('Vị trí phù mạch'),
//             CustomCheckboxGroup(
//               label: 'Chọn vị trí phù mạch',
//               selectedValues: _record.currentSymptoms?.angioedemaLocation ?? [],
//               options: const [
//                 'Mắt',
//                 'Môi',
//                 'Lưỡi',
//                 'Thanh quản',
//                 'Sinh dục',
//                 'Bàn tay',
//                 'Bàn chân',
//                 'Khác',
//               ],
//               onChanged: (selected) {
//                 setState(() {
//                   _record.currentSymptoms?.angioedemaLocation = selected;
//                 });
//               },
//             ),
//           ],
//           CustomTextField(
//             label: 'Điểm AAS7',
//             value: _record.currentSymptoms?.aas7Score.toString(),
//             keyboardType: TextInputType.number,
//             onChanged: (val) =>
//                 _record.currentSymptoms?.aas7Score = int.parse(val),
//             hint: '0-21',
//           ),
//           CustomTextField(
//             label: 'Triệu chứng phản vệ',
//             value: _record.currentSymptoms?.anaphylaxisSymptoms,
//             onChanged: (val) =>
//                 _record.currentSymptoms?.anaphylaxisSymptoms = val,
//             maxLines: 2,
//             hint: 'Mô tả các triệu chứng phản vệ nếu có',
//           ),
//           CustomTextField(
//             label: 'Tiểu sử bệnh án khác mới phát hiện',
//             value: _record.currentSymptoms?.newMedicalHistory,
//             onChanged: (val) =>
//                 _record.currentSymptoms?.newMedicalHistory = val,
//             maxLines: 3,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTestResultsStep() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const SectionHeader(
//             title: 'Kết quả test',
//             icon: Icons.science,
//           ),
//           // Test da vẽ nổi
//           CustomRadioGroup(
//             label: 'Kết quả da vẽ nổi (Dermatographism)',
//             value: _record.testResults?.dermatographismTest,
//             options: const ['Dương tính', 'Âm tính'],
//             onChanged: (val) =>
//                 setState(() => _record.testResults?.dermatographismTest = val),
//           ),
//           if (_record.testResults?.dermatographismTest == 'Dương tính') ...[
//             CustomTextField(
//               label: 'Điểm Fric',
//               value: _record.testResults?.fricScore != null
//                   ? _record.testResults?.fricScore.toString()
//                   : null,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.fricScore = int.tryParse(val),
//             ),
//             CustomTextField(
//               label: 'Điểm ngứa NRS',
//               value: _record.testResults?.itchScoreNRS != null
//                   ? _record.testResults?.itchScoreNRS.toString()
//                   : null,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.itchScoreNRS = int.tryParse(val),
//               hint: '0-10',
//             ),
//             CustomTextField(
//               label: 'Điểm đau NRS',
//               value: _record.testResults?.painScoreNRS != null
//                   ? _record.testResults?.painScoreNRS.toString()
//                   : null,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.painScoreNRS = int.tryParse(val),
//               hint: '0-10',
//             ),
//             CustomTextField(
//               label: 'Điểm bỏng rát NRS',
//               value: _record.testResults?.burningScoreNRS != null
//                   ? _record.testResults?.burningScoreNRS.toString()
//                   : null,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.burningScoreNRS = int.tryParse(val),
//               hint: '0-10',
//             ),
//           ],
//           const SizedBox(height: 16),
//           // Test mày đay do lạnh - Temptest
//           CustomRadioGroup(
//             label: 'Mày đay do lạnh (Temptest)',
//             value: _record.testResults?.coldUrticariaTemptest,
//             options: const ['Dương tính', 'Âm tính'],
//             onChanged: (val) => setState(
//                 () => _record.testResults?.coldUrticariaTemptest = val),
//           ),
//           if (_record.testResults?.coldUrticariaTemptest == 'Dương tính') ...[
//             CustomTextField(
//               label: 'Vùng nhiệt độ dương tính (°C)',
//               value: _record.testResults?.coldPositiveTemperature,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.coldPositiveTemperature = val,
//             ),
//             CustomTextField(
//               label: 'Điểm ngứa NRS (khi Temptest)',
//               value: _record.testResults?.itchScoreNRSCold,
//               keyboardType: TextInputType.number,
//               onChanged: (val) => _record.testResults?.itchScoreNRSCold = val,
//               hint: '0-10',
//             ),
//             CustomTextField(
//               label: 'Điểm đau NRS (khi Temptest)',
//               value: _record.testResults?.painScoreNRSCold,
//               keyboardType: TextInputType.number,
//               onChanged: (val) => _record.testResults?.painScoreNRSCold = val,
//               hint: '0-10',
//             ),
//             CustomTextField(
//               label: 'Điểm bỏng rát NRS (khi Temptest)',
//               value: _record.testResults?.burningScoreNRSCold,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.burningScoreNRSCold = val,
//               hint: '0-10',
//             ),
//           ],
//           const SizedBox(height: 16),
//           // Test mày đay do lạnh - Test cục đá
//           CustomRadioGroup(
//             label: 'Mày đay do lạnh - Test cục đá',
//             value: _record.testResults?.coldUrticariaIceTest,
//             options: const ['Dương tính', 'Âm tính'],
//             onChanged: (val) =>
//                 setState(() => _record.testResults?.coldUrticariaIceTest = val),
//           ),
//           if (_record.testResults?.coldUrticariaIceTest == 'Dương tính') ...[
//             CustomTextField(
//               label: 'Ngưỡng thời gian (phút)',
//               value: _record.testResults?.coldIceTimeThreshold,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.coldIceTimeThreshold = val,
//             ),
//             CustomTextField(
//               label: 'Điểm ngứa NRS (khi Test cục đá)',
//               value: _record.testResults?.itchScoreNRSIce,
//               keyboardType: TextInputType.number,
//               onChanged: (val) => _record.testResults?.itchScoreNRSIce = val,
//               hint: '0-10',
//             ),
//             CustomTextField(
//               label: 'Điểm đau NRS (khi Test cục đá)',
//               value: _record.testResults?.painScoreNRSIce,
//               keyboardType: TextInputType.number,
//               onChanged: (val) => _record.testResults?.painScoreNRSIce = val,
//               hint: '0-10',
//             ),
//             CustomTextField(
//               label: 'Điểm bỏng rát NRS (khi Test cục đá)',
//               value: _record.testResults?.burningScoreNRSIce,
//               keyboardType: TextInputType.number,
//               onChanged: (val) => _record.testResults?.burningScoreNRSIce = val,
//               hint: '0-10',
//             ),
//           ],
//           const SizedBox(height: 16),
//           // Test mày đay do choline
//           CustomRadioGroup(
//             label: 'Mày đay do choline',
//             value: _record.testResults?.cholinergicUrticariaTest,
//             options: const ['Dương tính', 'Âm tính'],
//             onChanged: (val) => setState(
//                 () => _record.testResults?.cholinergicUrticariaTest = val),
//           ),
//           if (_record.testResults?.cholinergicUrticariaTest ==
//               'Dương tính') ...[
//             CustomTextField(
//               label: 'Thời gian xuất hiện tổn thương (phút)',
//               value: _record.testResults?.cholinergicAppearanceTime,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.cholinergicAppearanceTime = val,
//             ),
//             CustomTextField(
//               label: 'Điểm ngứa NRS (khi test choline)',
//               value: _record.testResults?.itchScoreNRSCholine,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.itchScoreNRSCholine = val,
//               hint: '0-10',
//             ),
//             CustomTextField(
//               label: 'Điểm đau NRS (khi test choline)',
//               value: _record.testResults?.painScoreNRSCholine,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.painScoreNRSCholine = val,
//               hint: '0-10',
//             ),
//             CustomTextField(
//               label: 'Điểm bỏng rát NRS (khi test choline)',
//               value: _record.testResults?.burningScoreNRSCholine,
//               keyboardType: TextInputType.number,
//               onChanged: (val) =>
//                   _record.testResults?.burningScoreNRSCholine = val,
//               hint: '0-10',
//             ),
//           ],
//           const SizedBox(height: 16),
//           CustomTextField(
//             label: 'Mức độ hoạt động bệnh CUSI',
//             value: _record.testResults?.cusiScore,
//             keyboardType: TextInputType.number,
//             onChanged: (val) => _record.testResults?.cusiScore = val,
//           ),
//           CustomTextField(
//             label: 'Căn nguyên khác',
//             value: _record.testResults?.otherCause,
//             onChanged: (val) => _record.testResults?.otherCause = val,
//             maxLines: 2,
//           ),
//           CustomTextField(
//             label: 'Mức độ kiểm soát bệnh ACT',
//             value: _record.testResults?.actScore,
//             keyboardType: TextInputType.number,
//             onChanged: (val) => _record.testResults?.actScore = val,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCompletionStep() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const SectionHeader(
//             title: 'Hoàn thành bệnh án',
//             icon: Icons.check_circle,
//           ),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.green[50],
//               border: Border.all(color: Colors.green[200]!),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Thông tin bệnh án tái khám đã được hoàn thành',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Bệnh nhân: ${_record.fullName ?? "Chưa nhập"}',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 Text(
//                   'Số CCCD: ${_record.nationalId ?? "Chưa nhập"}',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 Text(
//                   'SĐT: ${_record.phoneNumber ?? "Chưa nhập"}',
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 if (_record.examinationDate != null)
//                   Text(
//                     'Ngày khám: ${_record.examinationDate}',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Nhấn "Hoàn thành" để gửi bệnh án đến hệ thống.',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
// }
