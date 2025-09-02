import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
import 'package:dr_urticaria/cubits/appointment/appointment_update_status_cubit.dart';
import 'package:dr_urticaria/cubits/vital_record_detail_cubit.dart';
import 'package:dr_urticaria/cubits/vital_record_detail_state.dart';
import 'package:dr_urticaria/medical_record_v2/widgets/vital_field_editor.dart';
import 'package:dr_urticaria/core/repositories/appointments_repository.dart';
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalRecordDetailPage extends StatelessWidget {
  final int medicalRecordId;

  const VitalRecordDetailPage({
    super.key,
    required this.medicalRecordId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              VitalRecordDetailCubit(medicalRecordId: medicalRecordId)..load(),
        ),
        BlocProvider(
          create: (ctx) => AppointmentUpdateStatusCubit(),
        ),
      ],
      child: _VitalRecordDetailView(appointmentId: medicalRecordId),
    );
  }
}

class _VitalRecordDetailView extends StatelessWidget {
  final int appointmentId;
  const _VitalRecordDetailView({required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return MultiBlocListener(
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
            }
          },
        ),
        BlocListener<AppointmentUpdateStatusCubit,
            AppointmentUpdateStatusState>(
          listener: (context, state) {
            if (state is AppointmentUpdateStatusSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Trạng thái đổi thành: ${state.appointment.status}'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is AppointmentUpdateStatusFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lỗi: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết bệnh án'),
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<VitalRecordDetailCubit, VitalRecordDetailState>(
          builder: (context, state) {
            if (state.loading && state.groups.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Lỗi: ${state.error}', textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () =>
                            context.read<VitalRecordDetailCubit>().load(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                      )
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<VitalRecordDetailCubit>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final g = state.groups[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: ExpansionTile(
                      title: Text(g.group.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        ...g.items.map((item) {
                          final vitalId = item.value.id;
                          final current = state.editedValues[vitalId] ??
                              item.value.value?.value ??
                              0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.indicator.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    if (item.indicator.unit != null)
                                      Text(item.indicator.unit!,
                                          style: TextStyle(
                                              color: Colors.grey[600])),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                VitalFieldEditor(
                                  indicator: item.indicator,
                                  value: current,
                                  unit: item.indicator.unit,
                                  onChanged: (val) => context
                                      .read<VitalRecordDetailCubit>()
                                      .editValue(
                                        vitalValueId: vitalId,
                                        newValue: val,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Ghi chú',
                                    prefixIcon:
                                        const Icon(Icons.note_alt_outlined),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  controller: TextEditingController(
                                      text: state.editedNotes[vitalId] ??
                                          item.value.note ??
                                          ''),
                                  onChanged: (v) => context
                                      .read<VitalRecordDetailCubit>()
                                      .editNote(
                                        vitalValueId: vitalId,
                                        note: v,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    item.indicator.code,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[600]),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                  onPressed: () =>
                      context.read<VitalRecordDetailCubit>().saveAll(),
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Lưu tất cả thay đổi'),
                ),
                const SizedBox(height: 8),
                BlocBuilder<AppointmentUpdateStatusCubit,
                    AppointmentUpdateStatusState>(
                  builder: (context, state) {
                    final loading = state is AppointmentUpdateStatusLoading;
                    return FilledButton.icon(
                      onPressed: loading
                          ? null
                          : () => context
                              .read<AppointmentUpdateStatusCubit>()
                              .updateStatus(
                                appointmentId,
                                AppointmentStatus.confirmed,
                              ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: loading
                          ? const Text("Đang cập nhật...")
                          : const Text("Xác nhận lịch hẹn"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
