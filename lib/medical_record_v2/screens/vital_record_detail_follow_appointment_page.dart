import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dr_urticaria/cubits/vital_record_detail_cubit.dart';
import 'package:dr_urticaria/cubits/vital_record_detail_state.dart';
import 'package:dr_urticaria/medical_record_v2/widgets/vital_field_editor.dart';

import 'package:dr_urticaria/cubits/appointment/appointment_update_status_cubit.dart';
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';

// ✅ dùng group/indicator theo TEMPLATE (giống màn create form)
import 'package:dr_urticaria/medical_record_v2/create_medical_record/model/vital_group.dart';

import '../widgets/indicator_label.dart';

class VitalRecordDetailFollowAppointmentPage extends StatelessWidget {
  final int medicalRecordId;
  final int templateId; // ✅ thêm templateId để load form template
  final int appointmentId;
  final AppointmentStatus selectedStatus;

  const VitalRecordDetailFollowAppointmentPage({
    super.key,
    required this.medicalRecordId,
    required this.templateId,
    required this.appointmentId,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VitalRecordDetailCubit(
        medicalRecordId: medicalRecordId,
        templateId: templateId,
      )..load(),
      child: VitalRecordDetailFollowAppointmentView(
        medicalRecordId: medicalRecordId,
        templateId: templateId,
        selectedStatus: selectedStatus,
        appointmentId: appointmentId,
      ),
    );
  }
}

class VitalRecordDetailFollowAppointmentView extends StatefulWidget {
  final int medicalRecordId;
  final int templateId; // ✅ thêm templateId để load form template
  final int appointmentId;
  final AppointmentStatus selectedStatus;

  const VitalRecordDetailFollowAppointmentView({
    super.key,
    required this.medicalRecordId,
    required this.templateId,
    required this.appointmentId,
    required this.selectedStatus,
  });

  @override
  State<VitalRecordDetailFollowAppointmentView> createState() =>
      _VitalRecordDetailFollowAppointmentViewState();
}

class _VitalRecordDetailFollowAppointmentViewState
    extends State<VitalRecordDetailFollowAppointmentView>
    with TickerProviderStateMixin {
  // giống màn detail mới
  static const Set<int> _diagnosisIds = {25, 35, 52};
  static const Set<int> _labIds = {23, 33, 43};
  static const Set<int> _treatmentIds = {26, 36, 53};
  static const Set<int> _followUpIds = {49, 37, 54};

  late final TabController _tabController;
  late AppointmentStatus _currentStatus;
  AppointmentStatus? _requestedStatus;

  bool _needReloadOnBack = false;

  // note controller bền vững
  final Map<int, TextEditingController> _noteControllers = {};

  TextEditingController _noteCtrl(int indicatorId, String initialText) {
    final exist = _noteControllers[indicatorId];
    if (exist != null) {
      if (exist.text != initialText) {
        exist.value = TextEditingValue(
          text: initialText,
          selection: TextSelection.collapsed(offset: initialText.length),
        );
      }
      return exist;
    }
    final c = TextEditingController(text: initialText);
    _noteControllers[indicatorId] = c;
    return c;
  }

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.selectedStatus;
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in _noteControllers.values) c.dispose();
    super.dispose();
  }

  // ===== group helpers (theo template VitalGroup) =====
  List<VitalGroup> _filterGroups(List<VitalGroup> all, Set<int> ids) {
    return all.where((g) => ids.contains(g.id)).toList();
  }

  List<VitalGroup> _normalGroups(List<VitalGroup> all) {
    final special = {
      ..._diagnosisIds,
      ..._labIds,
      ..._treatmentIds,
      ..._followUpIds
    };
    return all.where((g) => !special.contains(g.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (_) => VitalRecordDetailCubit(
        //     medicalRecordId: widget.medicalRecordId,
        //     templateId: widget.templateId,
        //   )..load(),
        // ),
        BlocProvider(create: (_) => AppointmentUpdateStatusCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<VitalRecordDetailCubit, VitalRecordDetailState>(
            listener: (context, state) {
              if (state.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Cập nhật thành công!'),
                    backgroundColor: color,
                    duration: const Duration(seconds: 2),
                  ),
                );
                _needReloadOnBack = true; // ✅ back về list reload
              }
            },
          ),
          BlocListener<AppointmentUpdateStatusCubit,
              AppointmentUpdateStatusState>(
            listener: (context, state) {
              if (state is AppointmentUpdateStatusSuccess) {
                final toStatus = _requestedStatus;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Cập nhật trạng thái thành: ${toStatus?.display ?? ''}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );

                if (toStatus != null) {
                  setState(() => _currentStatus = toStatus);
                }
                _needReloadOnBack = true;
              } else if (state is AppointmentUpdateStatusFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cập nhật thất bại'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, _needReloadOnBack);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Chi tiết bệnh án'),
              backgroundColor: color,
              foregroundColor: Colors.white,
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Thông tin bệnh án'),
                  Tab(text: 'Chẩn đoán'),
                  Tab(text: 'Xét nghiệm'),
                  Tab(text: 'Điều trị'),
                  Tab(text: 'Hẹn'),
                ],
              ),
            ),
            body: BlocBuilder<VitalRecordDetailCubit, VitalRecordDetailState>(
              builder: (context, state) {
                // ✅ chỉ block khi đang load form và chưa có groups để render
                if (state.loadingForm && state.groups.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ✅ nếu form lỗi và không có groups thì show error screen
                if (state.groups.isEmpty && state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Lỗi: ${state.error}'),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () =>
                              context.read<VitalRecordDetailCubit>().load(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }

                final all = [...state.groups];
                final normal = _normalGroups(all);
                final diagnosis = _filterGroups(all, _diagnosisIds);
                final lab = _filterGroups(all, _labIds);
                final treatment = _filterGroups(all, _treatmentIds);
                final followUp = _filterGroups(all, _followUpIds);

                return Stack(
                  children: [
                    TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTabContent(normal, state,
                            emptyText:
                                'Không có nhóm thông tin trong template'),
                        _buildTabContent(diagnosis, state,
                            emptyText:
                                'Không có nhóm Chẩn đoán trong template'),
                        _buildTabContent(lab, state,
                            emptyText:
                                'Không có nhóm xét nghiệm trong template'),
                        _buildTabContent(treatment, state,
                            emptyText: 'Không có nhóm điều trị trong template'),
                        _buildTabContent(followUp, state,
                            emptyText: 'Không có nhóm hẹn trong template'),
                      ],
                    ),

                    // ✅ detail đang load thì overlay nhẹ (không chặn UI)
                    if (state.loadingDetail)
                      const Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: LinearProgressIndicator(minHeight: 2),
                      ),
                  ],
                );
              },
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_currentStatus == AppointmentStatus.confirmed)
                      BlocBuilder<VitalRecordDetailCubit,
                          VitalRecordDetailState>(
                        builder: (context, s) {
                          return FilledButton.icon(
                            onPressed: s.saving
                                ? null
                                : () => context
                                    .read<VitalRecordDetailCubit>()
                                    .saveAll(),
                            icon: const Icon(Icons.save_outlined),
                            label: Text(s.saving
                                ? 'Đang lưu...'
                                : 'Lưu tất cả thay đổi'),
                          );
                        },
                      ),
                    const SizedBox(height: 8),

                    // ✅ nút primary action theo status hiện tại
                    if (_currentStatus.canPrimaryAction &&
                        _currentStatus.nextStatus != null)
                      BlocBuilder<AppointmentUpdateStatusCubit,
                          AppointmentUpdateStatusState>(
                        builder: (context, state) {
                          final loading =
                              state is AppointmentUpdateStatusLoading;
                          return FilledButton.icon(
                            onPressed: loading
                                ? null
                                : () {
                                    _requestedStatus =
                                        _currentStatus.nextStatus;
                                    context
                                        .read<AppointmentUpdateStatusCubit>()
                                        .updateStatus(
                                          widget.appointmentId,
                                          _currentStatus.nextStatus!,
                                        );
                                  },
                            icon: Icon(
                              _currentStatus == AppointmentStatus.pending
                                  ? Icons.check_circle_outline
                                  : Icons.task_alt_outlined,
                            ),
                            label: loading
                                ? const Text("Đang cập nhật...")
                                : Text(_currentStatus.primaryActionLabel),
                          );
                        },
                      ),

                    // ✅ nút hủy: chỉ show khi CURRENT status còn pending
                    if (_currentStatus == AppointmentStatus.pending)
                      BlocBuilder<AppointmentUpdateStatusCubit,
                          AppointmentUpdateStatusState>(
                        builder: (context, state) {
                          final loading =
                              state is AppointmentUpdateStatusLoading;
                          return FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: loading
                                ? null
                                : () {
                                    _requestedStatus =
                                        AppointmentStatus.cancelled;
                                    context
                                        .read<AppointmentUpdateStatusCubit>()
                                        .updateStatus(
                                          widget.appointmentId,
                                          AppointmentStatus.cancelled,
                                        );
                                  },
                            icon: const Icon(Icons.cancel_outlined),
                            label: loading
                                ? const Text("Đang hủy lịch...")
                                : const Text("Hủy lịch hẹn"),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(List<VitalGroup> groups, VitalRecordDetailState state,
      {String emptyText = 'Không có dữ liệu'}) {
    if (groups.isEmpty) {
      return Center(
        child: Text(emptyText, style: const TextStyle(fontSize: 16)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _buildGroupCard(groups[i], state),
    );
  }

  Widget _buildGroupCard(VitalGroup group, VitalRecordDetailState state) {
    final indicators = [...group.indicators];
    indicators.sort((a, b) => (a.code ?? '').compareTo(b.code ?? ''));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: Text(
          group.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: indicators.map((indicator) {
          final indicatorId = indicator.id;

          final current = state.editedValues.containsKey(indicatorId)
              ? state.editedValues[indicatorId]
              : (state.initialValues[indicatorId] ?? "");

          final noteText = state.editedNotes.containsKey(indicatorId)
              ? (state.editedNotes[indicatorId] ?? '')
              : (state.initialNotes[indicatorId] ?? '');

          final noteController = _noteCtrl(indicatorId, noteText);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // label + unit
                Row(
                  children: [
                    Expanded(
                      child: FieldLabel(
                        indicator.name ?? '',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (indicator.unit != null)
                      Text(
                        indicator.unit!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                VitalFieldEditor(
                  //templateId: widget.templateId,
                  indicator: indicator,
                  value: current,
                  unit: indicator.unit,
                  onChanged: (val) => context
                      .read<VitalRecordDetailCubit>()
                      .editValue(indicatorId: indicatorId, newValue: val),
                ),

                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ghi chú',
                    prefixIcon: const Icon(Icons.note_alt_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  controller: noteController,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (v) => context
                      .read<VitalRecordDetailCubit>()
                      .editNote(indicatorId: indicatorId, note: v),
                ),

                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    indicator.code ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
