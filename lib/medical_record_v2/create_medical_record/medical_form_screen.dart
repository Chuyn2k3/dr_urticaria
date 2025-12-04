import 'package:dr_urticaria/medical_record_v2/create_medical_record/widget/indicator_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import các widget dùng sẵn của bạn
import 'package:dr_urticaria/constant/color.dart';

import 'package:dr_urticaria/utils/snack_bar.dart';

// ⚠️ IndicatorField tái sử dụng widget hiện có của bạn (không thay đổi)
// Nếu nó đang nằm file khác, hãy import đúng đường dẫn:
// import '../widgets/indicator_field.dart';
import '../../widget/custom_progress_indicator.dart';
import 'cubit/medical_form_cubit.dart';
import 'cubit/medical_form_state.dart';
import 'model/vital_group.dart';

class MedicalFormScreen extends StatelessWidget {
  final int templateId;
  final int patientId;
  const MedicalFormScreen({
    super.key,
    required this.templateId,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicalFormCubit()..loadMedicalForm(templateId),
      child: _MedicalFormView(
        templateId: templateId,
        patientId: patientId,
      ),
    );
  }
}

class _MedicalFormView extends StatefulWidget {
  final int templateId;
  final int patientId;
  const _MedicalFormView({required this.templateId, required this.patientId});

  @override
  State<_MedicalFormView> createState() => _MedicalFormViewState();
}

class _MedicalFormViewState extends State<_MedicalFormView> {
  int currentStep = 0;
  final PageController pageController = PageController();

  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Rời khỏi biểu mẫu?'),
        content: const Text('Dữ liệu có thể chưa được lưu.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Tiếp tục')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Rời khỏi')),
        ],
      ),
    );
    return result ?? false;
  }

  void nextStep(int total) {
    if (currentStep < total - 1) {
      setState(() => currentStep++);
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmExit,
      child: BlocListener<MedicalFormCubit, MedicalFormState>(
        listener: (context, state) async {
          if (state is MedicalFormSubmittedSuccess) {
            context.showSnackBarSuccess(
                text: "✅ Tạo bệnh án thành công", positionTop: true);
            await Future.delayed(const Duration(milliseconds: 600));
            if (mounted) Navigator.pop(context, true);
          } else if (state is MedicalFormError) {
            context.showSnackBarFail(
                text: "❌ Lỗi tạo bệnh án", positionTop: true);
          }
        },
        child: BlocBuilder<MedicalFormCubit, MedicalFormState>(
          builder: (context, state) {
            if (state is MedicalFormLoading) {
              return Scaffold(
                  backgroundColor: AppColors.primaryColor,
                  body: CustomProgressIndicator());
            }

            if (state is MedicalFormError && state.groups.isEmpty) {
              return Scaffold(
                backgroundColor: AppColors.backgroundColor,
                body: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.filter_alt_off_outlined,
                              size: 56, color: AppColors.textSecondary),
                          const SizedBox(height: 12),
                          const Text(
                            'Không có câu hỏi nào hiển thị',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Các điều kiện hiển thị có thể đang ẩn hết câu hỏi.\nBạn có thể tải lại để bắt đầu lại.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Quay lại'),
                              ),
                              const SizedBox(width: 12),
                              FilledButton.icon(
                                onPressed: () => context
                                    .read<MedicalFormCubit>()
                                    .loadMedicalForm(widget.templateId),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Tải lại'),
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

            final cubit = context.read<MedicalFormCubit>();
            final groups = (state is MedicalFormLoaded ||
                    state is MedicalFormSubmitting ||
                    state is MedicalFormSubmittedSuccess)
                ? (state as dynamic).groups as List<VitalGroup>
                : <VitalGroup>[];

            final answers = (state is MedicalFormLoaded ||
                    state is MedicalFormSubmitting ||
                    state is MedicalFormSubmittedSuccess)
                ? (state as dynamic).answers as Map<int, dynamic>
                : <int, dynamic>{};

            if (groups.isEmpty) {
              return const Scaffold(
                backgroundColor: AppColors.primaryColor,
                body: Center(child: Text('Không có dữ liệu form')),
              );
            }

            // Lọc group theo visibleGroupIds (nếu state có)
            final Set<int> visibleGroupIds = (state is MedicalFormLoaded)
                ? state.visibleGroupIds
                : groups.map((g) => g.id).toSet();

            final visibleGroups =
                groups.where((g) => visibleGroupIds.contains(g.id)).toList();

            return Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColors.primaryColor,
                  appBar: AppBar(
                    title: const Text('Tạo bệnh án'),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () async {
                        final leave = await _confirmExit();
                        if (leave && mounted) Navigator.pop(context);
                      },
                    ),
                  ),
                  body: Column(
                    children: [
                      // Progress
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: AppColors.whiteColor,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Tiến độ'),
                                Text(
                                    '${((currentStep + 1) / visibleGroups.length * 100).round()}%'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: (currentStep + 1) / visibleGroups.length,
                              minHeight: 6,
                            ),
                          ],
                        ),
                      ),
                      // Pages
                      Expanded(
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: visibleGroups.length,
                          onPageChanged: (i) => setState(() => currentStep = i),
                          itemBuilder: (context, index) {
                            final group = visibleGroups[index];

                            // Nếu cần ẩn indicator trong group 12/27
                            final Set<int> visible12 =
                                (state is MedicalFormLoaded)
                                    ? state.visibleIndicatorsInGroup12
                                    : group.indicators.map((e) => e.id).toSet();
                            final Set<int> visible27 =
                                (state is MedicalFormLoaded)
                                    ? state.visibleIndicatorsInGroup27
                                    : group.indicators.map((e) => e.id).toSet();

                            final indicators = group.indicators.where((ind) {
                              if (!ind.isVisibleToPatient)
                                return false; // tuỳ chọn, có thể bỏ trong staff
                              if (group.id == 12)
                                return visible12.contains(ind.id);
                              if (group.id == 27)
                                return visible27.contains(ind.id);
                              return true;
                            }).toList();

                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(group.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      const SizedBox(height: 16),
                                      ...indicators.map((indicator) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: IndicatorField(
                                            indicator: indicator,
                                            value: answers[indicator.id],
                                            onChanged: (val) =>
                                                cubit.updateAnswer(
                                                    indicator.id, val),
                                            templateId: widget.templateId,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // Bottom actions
                      Container(
                        color: AppColors.whiteColor,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (currentStep > 0)
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.navigate_before),
                                  label: const Text('Quay lại'),
                                  onPressed: previousStep,
                                ),
                              ),
                            if (currentStep > 0) const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: Icon(
                                    currentStep == visibleGroups.length - 1
                                        ? Icons.check
                                        : Icons.navigate_next),
                                label: Text(
                                    currentStep == visibleGroups.length - 1
                                        ? 'Hoàn thành'
                                        : 'Tiếp theo'),
                                onPressed: () {
                                  if (currentStep == visibleGroups.length - 1) {
                                    context
                                        .read<MedicalFormCubit>()
                                        .submitMedicalRecord(
                                          templateId: widget.templateId,
                                          patientId: widget.patientId,
                                        );
                                  } else {
                                    nextStep(visibleGroups.length);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is MedicalFormSubmitting)
                  Container(
                    color: Colors.black38,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
