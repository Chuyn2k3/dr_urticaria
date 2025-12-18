//import 'package:dr_urticaria/medical_record_v2/screens/acute_urticaria_form_screen.dart';
import 'package:dr_urticaria/feature/uas7/uas7_patient_daily_screen.dart';
import 'package:dr_urticaria/medical_record_v2/create_medical_record/patient_picker_screen.dart';
import 'package:dr_urticaria/models/patient/patient_model.dart';
import 'package:dr_urticaria/utils/app_theme.dart';
import 'package:dr_urticaria/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubits/profile/profile_cubit.dart';
import '../medical_record_v2/create_medical_record/screen.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUserCubit, ProfileUserState>(
      builder: (context, state) {
        if (state is ProfileUserLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileUserLoadedState) {
          final user = state.user;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// --- Welcome card ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.doctorColor,
                          AppTheme.doctorColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.doctorColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Text(
                            user.fullname?.split(' ').last[0] ?? "",
                            style: const TextStyle(
                              color: AppTheme.doctorColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BS. ${user.fullname}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${user.phone} • ${user.address}',
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
                  ),

                  const SizedBox(height: 24),

                  /// --- Quick Actions ---
                  const Text(
                    'Thao tác nhanh',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    children: [
                      _buildQuickActionCard(
                        'Tạo bệnh án',
                        Icons.add_circle,
                        Colors.green,
                        () {
                          // context.showSnackBarSuccess(
                          //   text: "Chức năng đang phát triển",
                          //   positionTop: true,
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => StaffTemplatePickerScreen()),
                          );
                        },
                      ),
                      _buildQuickActionCard(
                        'Theo dõi UAS7',
                        Icons.timeline,
                        Colors.redAccent,
                        () {
                          Navigator.push<PatientModel>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PatientPickerScreen(isUas7: true,),
                            ),
                          );
                        },
                      ),
                      _buildQuickActionCard(
                        'Chỉ định XN',
                        Icons.science,
                        Colors.purple,
                        () {
                          context.showSnackBarSuccess(
                            text: "Chức năng đang phát triển",
                            positionTop: true,
                          );
                        },
                      ),
                      _buildQuickActionCard(
                        'Tạo livestream',
                        Icons.live_tv,
                        Colors.blue,
                        () {
                          Navigator.of(context).pushNamed('/live_page');
                        },
                      ),
                      // _buildQuickActionCard(
                      //   'Hàng đợi bệnh nhân',
                      //   Icons.people_alt,
                      //   Colors.blue,
                      //   () => Navigator.pushNamed(context, '/patient-queue'),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ProfileUserErrorState) {
          return Center(child: Text(state.error));
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
