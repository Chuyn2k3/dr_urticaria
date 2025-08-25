import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUploadWidget extends StatefulWidget {
  final String label;
  final List<String> imagePaths;
  final Function(List<String>) onImagesChanged;
  final bool enabled;
  final int maxImages;

  const ImageUploadWidget({
    Key? key,
    required this.label,
    required this.imagePaths,
    required this.onImagesChanged,
    this.enabled = true,
    this.maxImages = 5,
  }) : super(key: key);

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (widget.imagePaths.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tối đa ${widget.maxImages} ảnh')),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final List<String> newPaths = List.from(widget.imagePaths);
        newPaths.add(image.path);
        widget.onImagesChanged(newPaths);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi chọn ảnh')),
      );
    }
  }

  void _removeImage(int index) {
    final List<String> newPaths = List.from(widget.imagePaths);
    newPaths.removeAt(index);
    widget.onImagesChanged(newPaths);
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Chụp ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn từ thư viện'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: widget.enabled ? Colors.white : Colors.grey[50],
            ),
            child: Column(
              children: [
                if (widget.imagePaths.isNotEmpty) ...[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: widget.imagePaths.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(widget.imagePaths[index]),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (widget.enabled)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                if (widget.enabled &&
                    widget.imagePaths.length < widget.maxImages)
                  ElevatedButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.add_a_photo),
                    label: Text(
                      widget.imagePaths.isEmpty ? 'Thêm ảnh' : 'Thêm ảnh khác',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                if (!widget.enabled && widget.imagePaths.isEmpty)
                  const Text(
                    'Chưa có ảnh',
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
