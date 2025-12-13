import 'package:dr_urticaria/cubits/uas7/uas7_daily_cubit.dart';
import 'package:dr_urticaria/cubits/uas7/uas7_daily_state.dart';
import 'package:dr_urticaria/feature/uas7/widget/calendar_card.dart';
import 'package:dr_urticaria/feature/uas7/widget/detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:dr_urticaria/constant/color.dart';
import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/models/patient/patient_model.dart';
import 'package:dr_urticaria/core/repositories/uas7_repository.dart';
import 'package:dr_urticaria/utils/snack_bar.dart';

class Uas7PatientDailyScreen extends StatelessWidget {
  final PatientModel patient;

  const Uas7PatientDailyScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Uas7DailyCubit(
        repository: serviceLocator<Uas7Repository>(),
      )..loadPatientRecords(patient.id),
      child: _Uas7PatientDailyView(patient: patient),
    );
  }
}

class _Uas7PatientDailyView extends StatelessWidget {
  final PatientModel patient;

  const _Uas7PatientDailyView({required this.patient});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Uas7DailyCubit, Uas7DailyState>(
      listener: (ctx, state) {
        if (state.status == Uas7DailyStatus.updated) {
          ctx.showSnackBarSuccess(
            text: '✅ Cập nhật UAS7 thành công',
            positionTop: true,
          );
        } else if (state.status == Uas7DailyStatus.error &&
            state.errorMessage != null) {
          ctx.showSnackBarFail(
            text: '❌ ${state.errorMessage}',
            positionTop: true,
          );
        }
      },
      builder: (ctx, state) {
        final cubit = ctx.read<Uas7DailyCubit>();

        if (state.status == Uas7DailyStatus.loading ||
            state.status == Uas7DailyStatus.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('UAS7 - ${patient.fullname}'),
          ),
          body: Column(
            children: [
              const SizedBox(height: 8),
              CalendarCard(
                state: state,
                onDaySelected: (day) => cubit.selectDate(day),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: DetailCard(
                  state: state,
                  onSave: (itch, wheal, note) {
                    cubit.updateSelectedRecord(
                      itchLevel: itch,
                      whealLevel: wheal,
                      note: note,
                    );
                  },
                  weekSum: cubit.weekSum(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
