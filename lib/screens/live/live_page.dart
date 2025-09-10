import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'live_cubit.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;
  String? _result;

  Future<void> _createLive() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập title")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final api = LiveApi();
      final created = await api.createLive(_titleController.text);
      final res = await api.joinLive(
          created!.id!, created.doctorId!, created.channelName!);
      Navigator.of(context).pushNamed('/live-detail', arguments: res);
    } catch (e) {
      setState(() {
        _result = "Lỗi: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    [Permission.microphone, Permission.camera].request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Page")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Nhập title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createLive,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Tạo Live"),
                ),
                const SizedBox(height: 20),
                if (_result != null)
                  Text(
                    _result!,
                    style: TextStyle(
                      color: _result!.contains("thành công")
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
