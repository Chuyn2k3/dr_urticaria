import 'package:flutter/material.dart';

import 'medical_form_screen.dart';

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedicalFormScreen(templateId: t.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
