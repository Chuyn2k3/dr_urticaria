import 'package:dr_urticaria/constant/color.dart';
import 'package:dr_urticaria/cubits/uas7/uas7_daily_state.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatefulWidget {
  final Uas7DailyState state;
  final void Function(int itch, int wheal, String? note) onSave;
  final Map<String, int> weekSum;

  const DetailCard({
    super.key,
    required this.state,
    required this.onSave,
    required this.weekSum,
  });

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  int? _itch;
  int? _wheal;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _syncFromState();
  }

  @override
  void didUpdateWidget(covariant DetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.selectedRecord?.id != widget.state.selectedRecord?.id) {
      _syncFromState();
    }
  }

  void _syncFromState() {
    final rec = widget.state.selectedRecord;
    if (rec != null) {
      _itch = rec.itchLevel;
      _wheal = rec.whealLevel;
      _noteController.text = rec.note ?? '';
    } else {
      _itch = null;
      _wheal = null;
      _noteController.text = '';
    }
    setState(() {});
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = widget.state.selectedDate;
    final rec = widget.state.selectedRecord;

    if (selectedDate == null) {
      return const Center(
        child: Text('Chọn một ngày trên lịch để xem UAS7.'),
      );
    }

    if (rec == null) {
      return Center(
        child: Text(
          'Bệnh nhân chưa điền UAS7 cho ngày '
          '${selectedDate.toIso8601String().split("T").first}.',
        ),
      );
    }

    const itchOptions = [
      '0 - Không ngứa',
      '1 - Ngứa nhẹ',
      '2 - Ngứa vừa',
      '3 - Ngứa nhiều',
    ];
    const whealOptions = [
      '0 - Không nổi sẩn',
      '1 - Sẩn ít',
      '2 - Sẩn vừa',
      '3 - Sẩn nhiều',
    ];

    final iss7 = widget.weekSum['iss7'] ?? 0;
    final hss7 = widget.weekSum['hss7'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chấm điểm ngày '
                '${selectedDate.toIso8601String().split("T").first}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _itch,
                decoration: const InputDecoration(
                  labelText: 'Mức độ ngứa (0-3)',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  4,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(itchOptions[i]),
                  ),
                ),
                onChanged: (v) => setState(() => _itch = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _wheal,
                decoration: const InputDecoration(
                  labelText: 'Mức độ sẩn phù (0-3)',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(
                  4,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text(whealOptions[i]),
                  ),
                ),
                onChanged: (v) => setState(() => _wheal = v),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú (tuỳ chọn)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_itch == null || _wheal == null)
                      ? null
                      : () {
                          widget.onSave(
                            _itch!,
                            _wheal!,
                            _noteController.text.trim().isEmpty
                                ? null
                                : _noteController.text.trim(),
                          );
                        },
                  child: const Text('Lưu'),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Tổng điểm ngứa (ISS7)'),
                      const SizedBox(height: 4),
                      Text(
                        '$iss7',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Tổng điểm sẩn phù (HSS7)'),
                      const SizedBox(height: 4),
                      Text(
                        '$hss7',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
