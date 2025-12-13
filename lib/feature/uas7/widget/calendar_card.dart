import 'package:dr_urticaria/constant/color.dart';
import 'package:dr_urticaria/cubits/uas7/uas7_daily_state.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarCard extends StatelessWidget {
  final Uas7DailyState state;
  final void Function(DateTime day) onDaySelected;

  const CalendarCard({
    super.key,
    required this.state,
    required this.onDaySelected,
  });

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    final marked = state.records.map((e) => _normalize(e.recordDate)).toSet();
    final focused = state.selectedDate ?? (_normalize(DateTime.now()));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focused,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) =>
              state.selectedDate != null && isSameDay(state.selectedDate, day),
          onDaySelected: (selected, _) => onDaySelected(selected),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final d = _normalize(day);
              final hasRecord = marked.contains(d);
              final isSelected = state.selectedDate != null &&
                  isSameDay(state.selectedDate, day);

              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor.withOpacity(0.1)
                      : null,
                  border: hasRecord
                      ? Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              final d = _normalize(day);
              final hasRecord = marked.contains(d);
              final isSelected = state.selectedDate != null &&
                  isSameDay(state.selectedDate, day);
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: hasRecord
                      ? Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        )
                      : Border.all(
                          color: Colors.blue.shade100,
                        ),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
