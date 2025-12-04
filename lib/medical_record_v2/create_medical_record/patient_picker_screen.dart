import 'package:dr_urticaria/di/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_urticaria/constant/color.dart';
import 'package:dr_urticaria/models/patient/patient_model.dart';

import 'cubit/patient_search_cubit.dart';
import 'cubit/patient_search_state.dart';

class PatientPickerScreen extends StatefulWidget {
  const PatientPickerScreen({super.key});

  @override
  State<PatientPickerScreen> createState() => _PatientPickerScreenState();
}

class _PatientPickerScreenState extends State<PatientPickerScreen> {
  final _keywordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _identityController = TextEditingController();
  final _scrollController = ScrollController();
  final cubit = serviceLocator<PatientSearchCubit>();
  @override
  void initState() {
    super.initState();
    // load lần đầu
    cubit.searchPatients();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        cubit.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _phoneController.dispose();
    _identityController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearch() {
    cubit.searchPatients(
      search: _keywordController.text.trim().isEmpty
          ? null
          : _keywordController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      identityNumber: _identityController.text.trim().isEmpty
          ? null
          : _identityController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chọn bệnh nhân'),
        ),
        body: Column(
          children: [
            // Bộ lọc tìm kiếm
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _keywordController,
                    decoration: const InputDecoration(
                      labelText: 'Từ khóa (tên, email...)',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Số điện thoại',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          onSubmitted: (_) => _onSearch(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _identityController,
                          decoration: const InputDecoration(
                            labelText: 'CMND/CCCD',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _onSearch(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _onSearch,
                      icon: const Icon(Icons.search),
                      label: const Text('Tìm kiếm'),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Danh sách
            Expanded(
              child: BlocBuilder<PatientSearchCubit, PatientSearchState>(
                builder: (context, state) {
                  print(state);
                  if (state is PatientSearchLoading ||
                      state is PatientSearchInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PatientSearchError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is PatientSearchLoaded) {
                    if (state.patients.isEmpty) {
                      return const Center(
                        child: Text('Không tìm thấy bệnh nhân'),
                      );
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount:
                          state.patients.length + (state.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (index >= state.patients.length) {
                          // item loading more
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final patient = state.patients[index];
                        return Card(
                          child: ListTile(
                            title: Text(patient.fullname),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (patient.phone != null)
                                  Text('SDT: ${patient.phone}'),
                                if (patient.identityNumber != null)
                                  Text('CMND/CCCD: ${patient.identityNumber}'),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pop<PatientModel>(context, patient);
                            },
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
