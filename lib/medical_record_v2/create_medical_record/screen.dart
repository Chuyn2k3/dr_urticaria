import 'package:flutter/material.dart';

import 'medical_form_screen.dart';
import 'patient_picker_screen.dart';
import 'package:dr_urticaria/models/patient/patient_model.dart';

class StaffTemplatePickerScreen extends StatelessWidget {
  const StaffTemplatePickerScreen({super.key});

  static const _templates = [
    (id: 16, name: 'Cấp tính'),
    (id: 17, name: 'Mạn tính lần 1'),
    (id: 18, name: 'Mạn tính tái khám'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn loại bệnh án')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _templates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          final t = _templates[i];
          return Card(
            child: ListTile(
              title: Text(t.name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                //1. Chọn bệnh nhân
                final selectedPatient = await Navigator.push<PatientModel>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientPickerScreen(
                      isUas7: false,
                    ),
                  ),
                );

                if (selectedPatient == null) return;

                // 2. Mở form tạo bệnh án với templateId + patientId
                // Ở đây có thể dùng pushReplacement nếu muốn.
                // ignore: use_build_context_synchronously
                final created = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedicalFormScreen(
                      templateId: t.id,
                      patient: selectedPatient,
                    ),
                  ),
                );
                if (created ?? false) {
                  setState() {}
                }
              },
            ),
          );
        },
      ),
    );
  }
}
