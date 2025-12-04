import 'dart:async';

import 'package:dr_urticaria/medical_record_v2/cubit/medical_record_list_cubit.dart';
import 'package:dr_urticaria/medical_record_v2/cubit/medical_record_list_state.dart';
import 'package:dr_urticaria/medical_record_v2/screens/vital_record_detail_page.dart';
import 'package:dr_urticaria/models/medical_record_list_item.dart';
import 'package:dr_urticaria/utils/snack_bar.dart';
import 'package:dr_urticaria/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalRecordListScreen extends StatelessWidget {
  const MedicalRecordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          MedicalRecordListCubit()..fetch(page: 1, limit: 20), // load lần đầu
      child: const _MedicalRecordListView(),
    );
  }
}

class _MedicalRecordListView extends StatefulWidget {
  const _MedicalRecordListView({super.key});

  @override
  State<_MedicalRecordListView> createState() => _MedicalRecordListViewState();
}

class _MedicalRecordListViewState extends State<_MedicalRecordListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  DateTime? _createdAtFrom;
  DateTime? _createdAtTo;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (mounted) {
          context.read<MedicalRecordListCubit>().loadMore(
                fullName: _searchController.text.isEmpty
                    ? null
                    : _searchController.text,
                phone: _searchController.text.isEmpty
                    ? null
                    : _searchController.text,
                createdAtFrom: _createdAtFrom,
                createdAtTo: _createdAtTo,
                // nếu cần search theo symptoms/diagnosis, set thêm ở đây
              );
        }
      }
    });

    _searchController.addListener(() {
      if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
      _searchDebounce = Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.read<MedicalRecordListCubit>().fetch(
                page: 1,
                limit: 20,
                fullName: _searchController.text.isEmpty
                    ? null
                    : _searchController.text,
                // phone: _searchController.text.isEmpty
                //     ? null
                //     : _searchController.text,
                createdAtFrom: _createdAtFrom,
                createdAtTo: _createdAtTo,
              );
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _showFilterDialog() {
    DateTime? tempCreatedAtFrom = _createdAtFrom;
    DateTime? tempCreatedAtTo = _createdAtTo;

    final cubit = context.read<MedicalRecordListCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Lọc bệnh án'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ngày tạo từ:'),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: dialogContext,
                      initialDate: tempCreatedAtFrom ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setDialogState(() => tempCreatedAtFrom = selectedDate);
                    }
                  },
                  child: Text(
                    tempCreatedAtFrom?.toString().split(' ')[0] ?? 'Chọn ngày',
                    style: TextStyle(color: Colors.blue.shade600),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Ngày tạo đến:'),
                TextButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: dialogContext,
                      initialDate: tempCreatedAtTo ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setDialogState(() => tempCreatedAtTo = selectedDate);
                    }
                  },
                  child: Text(
                    tempCreatedAtTo?.toString().split(' ')[0] ?? 'Chọn ngày',
                    style: TextStyle(color: Colors.blue.shade600),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (tempCreatedAtFrom != null &&
                  tempCreatedAtTo != null &&
                  tempCreatedAtFrom!.isAfter(tempCreatedAtTo!)) {
                if (mounted) {
                  context.showSnackBarFail(
                    text: 'Ngày bắt đầu phải trước ngày kết thúc',
                    positionTop: true,
                  );
                }
                return;
              }

              setState(() {
                _createdAtFrom = tempCreatedAtFrom;
                _createdAtTo = tempCreatedAtTo;
              });

              cubit.fetch(
                page: 1,
                limit: 20,
                fullName: _searchController.text.isEmpty
                    ? null
                    : _searchController.text,
                phone: _searchController.text.isEmpty
                    ? null
                    : _searchController.text,
                createdAtFrom: _createdAtFrom,
                createdAtTo: _createdAtTo,
              );

              Navigator.pop(dialogContext);
            },
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: const Text('Danh sách bệnh án')),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<MedicalRecordListCubit, MedicalRecordListState>(
              builder: (context, state) {
                if (state is MedicalRecordListLoading &&
                    state is! MedicalRecordListSuccess) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MedicalRecordListFailure) {
                  return Center(child: Text('Lỗi: ${state.message}'));
                } else if (state is MedicalRecordListSuccess) {
                  final items = state.items;
                  if (items.isEmpty) return _buildEmptyState();

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<MedicalRecordListCubit>().refresh(
                            limit: state.limit,
                            fullName: _searchController.text.isEmpty
                                ? null
                                : _searchController.text,
                            phone: _searchController.text.isEmpty
                                ? null
                                : _searchController.text,
                            createdAtFrom: _createdAtFrom,
                            createdAtTo: _createdAtTo,
                          );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final record = items[index];
                        return _buildRecordCard(record);
                      },
                    ),
                  );
                }
                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm theo tên hoặc số điện thoại...',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: Colors.grey.shade500),
              onPressed: _showFilterDialog,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(MedicalRecordListItem record) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VitalRecordDetailPage(medicalRecordId: record.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên bệnh nhân
            Text(
              record.patient.fullname,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            // SĐT
            if (record.patient.phone != null)
              Text(
                'SĐT: ${record.patient.phone}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            const SizedBox(height: 4),
            // Template
            Text(
              'Mẫu: ${record.template.name}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            if (record.diagnosis != null && record.diagnosis!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Chẩn đoán: ${record.diagnosis}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  record.createdAt.toLocal().toString().split('.').first,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: ${record.id}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Chưa có bệnh án nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
