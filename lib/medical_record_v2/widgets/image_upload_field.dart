// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:get_it/get_it.dart';
//
// import '../../utils/shared_preferences_manager.dart';
//
// class ImageUploadField extends StatefulWidget {
//   final String label;
//   final int templateId;
//   final String? initialImageUrl;
//   final String? selectedOption; // để map overlay
//   final ValueChanged<String?> onChanged;
//
//   const ImageUploadField({
//     super.key,
//     required this.label,
//     required this.templateId,
//     this.initialImageUrl,
//     this.selectedOption,
//     required this.onChanged,
//   });
//
//   @override
//   State<ImageUploadField> createState() => _ImageUploadFieldState();
// }
//
// class _ImageUploadFieldState extends State<ImageUploadField> {
//   final ImagePicker _picker = ImagePicker();
//   File? _selectedImage;
//   bool _isUploading = false;
//   String? _uploadedUrl;
//
//   String? get _overlayAsset => widget.selectedOption != null
//       ? optionToOverlay[widget.selectedOption!]
//       : null;
//
//   @override
//   void initState() {
//     super.initState();
//     _uploadedUrl = widget.initialImageUrl;
//   }
//
//   Future<void> _uploadFile(File file) async {
//     final sfm = await GetIt.instance<SharedPreferencesManager>();
//     final userId = sfm.getInt("user_id");
//
//     setState(() => _isUploading = true);
//
//     try {
//       final uri = Uri.parse(
//         "https://drmayday.ibme.edu.vn/urticaria-collector/api/v1/medical-records/upload"
//         "?user_id=$userId&record_type=${widget.templateId}",
//       );
//
//       final request = http.MultipartRequest("POST", uri);
//       request.files.add(await http.MultipartFile.fromPath("file", file.path));
//
//       final response = await request.send();
//       if (response.statusCode == 201) {
//         final body = await response.stream.bytesToString();
//         setState(() {
//           _uploadedUrl = body;
//           _isUploading = false;
//         });
//         widget.onChanged(body);
//       } else {
//         throw Exception("Upload thất bại: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() => _isUploading = false);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Lỗi upload: $e")),
//         );
//       }
//     }
//   }
//
//   Future<void> _pickFromGallery() async {
//     final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
//     if (picked == null) return;
//     final file = File(picked.path);
//     setState(() => _selectedImage = file);
//     await _uploadFile(file);
//   }
//
//   Future<void> _openCamera() async {
//     final cameras = await availableCameras();
//     final firstCamera = cameras.first;
//
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => _CustomCameraScreen(
//           camera: firstCamera,
//           overlayAsset: _overlayAsset,
//           onCapture: (file) async {
//             setState(() => _selectedImage = file);
//             await _uploadFile(file);
//           },
//         ),
//       ),
//     );
//   }
//
//   void _showFullImage(String imageUrl) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => Scaffold(
//           backgroundColor: Colors.black,
//           body: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: Center(
//               child: InteractiveViewer(
//                 child: Image.network(imageUrl),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final hasImage =
//         _selectedImage != null || (_uploadedUrl?.isNotEmpty ?? false);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         if (hasImage)
//           Stack(
//             children: [
//               GestureDetector(
//                 onTap: _uploadedUrl != null
//                     ? () => _showFullImage(_uploadedUrl!)
//                     : null,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: _selectedImage != null
//                       ? Image.file(_selectedImage!,
//                           height: 160,
//                           width: double.infinity,
//                           fit: BoxFit.cover)
//                       : Image.network(
//                           _uploadedUrl!,
//                           height: 160,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) =>
//                               const Center(child: Text("❌ Không tải được ảnh")),
//                         ),
//                 ),
//               ),
//               Positioned(
//                 top: 8,
//                 right: 8,
//                 child: InkWell(
//                   onTap: () {
//                     setState(() {
//                       _selectedImage = null;
//                       _uploadedUrl = null;
//                     });
//                     widget.onChanged(null);
//                   },
//                   child: Container(
//                     decoration: const BoxDecoration(
//                         color: Colors.black54, shape: BoxShape.circle),
//                     padding: const EdgeInsets.all(6),
//                     child:
//                         const Icon(Icons.close, color: Colors.white, size: 20),
//                   ),
//                 ),
//               ),
//             ],
//           )
//         else
//           Container(
//             height: 120,
//             width: double.infinity,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.grey[100],
//             ),
//             child: const Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
//                 SizedBox(height: 6),
//                 Text("Chọn ảnh", style: TextStyle(color: Colors.grey)),
//               ],
//             ),
//           ),
//         const SizedBox(height: 8),
//         if (_isUploading)
//           const Center(child: CircularProgressIndicator())
//         else
//           Row(
//             children: [
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.photo),
//                 label: const Text("Chọn ảnh"),
//                 onPressed: _pickFromGallery,
//               ),
//               const SizedBox(width: 12),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.camera_alt),
//                 label: const Text("Chụp ảnh"),
//                 onPressed: _openCamera,
//               ),
//             ],
//           ),
//       ],
//     );
//   }
// }
//
// /// Custom Camera với overlay
// class _CustomCameraScreen extends StatefulWidget {
//   final CameraDescription camera;
//   final String? overlayAsset;
//   final Function(File) onCapture;
//
//   const _CustomCameraScreen({
//     required this.camera,
//     this.overlayAsset,
//     required this.onCapture,
//   });
//
//   @override
//   State<_CustomCameraScreen> createState() => _CustomCameraScreenState();
// }
//
// class _CustomCameraScreenState extends State<_CustomCameraScreen>
//     with TickerProviderStateMixin {
//   CameraController? _controller;
//   late Future<void> _initializeControllerFuture;
//   bool _isCapturing = false;
//   bool _showOverlay = true;
//
//   // Animation controllers
//   late AnimationController _captureAnimationController;
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller!.initialize();
//
//     _captureAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 150),
//       vsync: this,
//     );
//
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(
//       begin: 0.6,
//       end: 0.2,
//     ).animate(CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeInOut,
//     ));
//
//     debugPrint(
//         "[CustomCameraScreen] Init with overlay: ${widget.overlayAsset}");
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     _captureAnimationController.dispose();
//     _fadeController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _takePicture() async {
//     if (_isCapturing) return;
//
//     try {
//       setState(() {
//         _isCapturing = true;
//       });
//
//       // Animation hiệu ứng chụp ảnh
//       await _captureAnimationController.forward();
//       await _captureAnimationController.reverse();
//
//       debugPrint("[CustomCameraScreen] Taking picture...");
//       await _initializeControllerFuture;
//       final image = await _controller!.takePicture();
//
//       final dir = await getTemporaryDirectory();
//       final filePath =
//           '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final file = File(filePath);
//       await image.saveTo(filePath);
//
//       debugPrint("[CustomCameraScreen] Saved to $filePath");
//       widget.onCapture(file);
//       if (mounted) Navigator.pop(context);
//     } catch (e) {
//       debugPrint("[CustomCameraScreen] Error capturing image: $e");
//       setState(() {
//         _isCapturing = false;
//       });
//     }
//   }
//
//   void _switchCamera() async {
//     final cameras = await availableCameras();
//     if (cameras.length < 2) return;
//
//     final currentCamera = _controller?.description;
//     CameraDescription newCamera;
//
//     if (currentCamera?.lensDirection == CameraLensDirection.back) {
//       newCamera = cameras.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.front,
//         orElse: () => cameras.first,
//       );
//     } else {
//       newCamera = cameras.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.back,
//         orElse: () => cameras.first,
//       );
//     }
//
//     await _controller?.dispose();
//     _controller = CameraController(newCamera, ResolutionPreset.high);
//     _initializeControllerFuture = _controller!.initialize();
//     setState(() {});
//   }
//
//   void _toggleOverlay() {
//     setState(() {
//       _showOverlay = !_showOverlay;
//     });
//
//     if (_showOverlay) {
//       _fadeController.reverse();
//     } else {
//       _fadeController.forward();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint(
//         "[CustomCameraScreen] build() overlayAsset = ${widget.overlayAsset}");
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Camera Preview
//           Positioned.fill(
//             child: FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return CameraPreview(_controller!);
//                 } else {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//
//           // Overlay với hiệu ứng mờ
//           if (widget.overlayAsset != null && _showOverlay)
//             Positioned.fill(
//               child: IgnorePointer(
//                 child: AnimatedBuilder(
//                   animation: _fadeAnimation,
//                   builder: (context, child) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage(widget.overlayAsset!),
//                           fit: BoxFit.contain,
//                           opacity: _fadeAnimation.value,
//                         ),
//                       ),
//                       child: CustomPaint(
//                         painter: DashedBorderPainter(),
//                         child: Container(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//           // Top Controls
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 10,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Back button
//                 Container(
//                   margin: const EdgeInsets.only(left: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//
//                 // Overlay toggle button
//                 if (widget.overlayAsset != null)
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black54,
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: IconButton(
//                       icon: Icon(
//                         _showOverlay ? Icons.visibility : Icons.visibility_off,
//                         color: Colors.white,
//                       ),
//                       onPressed: _toggleOverlay,
//                     ),
//                   ),
//
//                 // Camera switch button
//                 Container(
//                   margin: const EdgeInsets.only(right: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: IconButton(
//                     icon:
//                         const Icon(Icons.flip_camera_ios, color: Colors.white),
//                     onPressed: _switchCamera,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Bottom Controls
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 120,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.8),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Gallery button
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.white24,
//                       borderRadius: BorderRadius.circular(25),
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: IconButton(
//                       icon:
//                           const Icon(Icons.photo_library, color: Colors.white),
//                       onPressed: () {
//                         Navigator.pop(context);
//                         // Có thể gọi _pickFromGallery ở đây nếu cần
//                       },
//                     ),
//                   ),
//
//                   // Capture button với animation
//                   GestureDetector(
//                     onTap: _takePicture,
//                     child: AnimatedBuilder(
//                       animation: _captureAnimationController,
//                       builder: (context, child) {
//                         return Transform.scale(
//                           scale:
//                               1.0 - (_captureAnimationController.value * 0.1),
//                           child: Container(
//                             width: 80,
//                             height: 80,
//                             decoration: BoxDecoration(
//                               color: _isCapturing ? Colors.red : Colors.white,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 4,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black26,
//                                   blurRadius: 10,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: _isCapturing
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                   )
//                                 : const Icon(
//                                     Icons.camera_alt,
//                                     color: Colors.black,
//                                     size: 35,
//                                   ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//
//                   // Flash button (placeholder)
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.white24,
//                       borderRadius: BorderRadius.circular(25),
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.flash_auto, color: Colors.white),
//                       onPressed: () {
//                         // Implement flash toggle nếu cần
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Instruction text
//           if (widget.overlayAsset != null)
//             Positioned(
//               top: MediaQuery.of(context).size.height * 0.15,
//               left: 20,
//               right: 20,
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   "Căn chỉnh theo khung hướng dẫn và nhấn chụp",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Custom painter để vẽ viền nét đứt
// class DashedBorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white.withOpacity(0.6)
//       ..strokeWidth = 2.0
//       ..style = PaintingStyle.stroke;
//
//     const dashWidth = 8.0;
//     const dashSpace = 4.0;
//
//     // Vẽ viền nét đứt xung quanh
//     final path = Path()
//       ..addRRect(RRect.fromRectAndRadius(
//         Rect.fromLTWH(
//             20, size.height * 0.1, size.width - 40, size.height * 0.8),
//         const Radius.circular(12),
//       ));
//
//     _drawDashedPath(canvas, path, paint, dashWidth, dashSpace);
//   }
//
//   void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashWidth,
//       double dashSpace) {
//     final pathMetrics = path.computeMetrics();
//     for (final pathMetric in pathMetrics) {
//       double distance = 0.0;
//       bool draw = true;
//       while (distance < pathMetric.length) {
//         final length = draw ? dashWidth : dashSpace;
//         final extractPath = pathMetric.extractPath(
//           distance,
//           distance + length,
//         );
//         if (draw) {
//           canvas.drawPath(extractPath, paint);
//         }
//         distance += length;
//         draw = !draw;
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// /// Map option -> overlay asset
// const Map<String, String> optionToOverlay = {
//   "Mặt thẳng": "assets/overlays/mat.png",
//   "Nghiêng trái": "assets/overlays/mat.png",
//   "Nghiêng phải": "assets/overlays/mat.png",
//   "Miệng": "assets/overlays/mieng.png",
//   "Thân trước": "assets/overlays/than.png",
//   "Thân sau": "assets/overlays/than.png",
//   "Bàn tay - Mặt mu": "assets/overlays/bantay.png",
//   "Bàn tay - Mặt lòng (chụp 2 tay)": "assets/overlays/bantay.png",
//   "Cẳng tay - Mặt trong": "assets/overlays/cangtay.png",
//   "Cẳng tay - Mặt ngoài": "assets/overlays/cangtay.png",
//   "Cánh tay - Mặt trong": "assets/overlays/canhtay.png",
//   "Cánh tay - Mặt ngoài": "assets/overlays/canhtay.png",
//   "Sinh dục": "assets/overlays/sinhduc.png",
//   "Đùi - Mặt trong": "assets/overlays/dui.png",
//   "Đùi - Mặt ngoài": "assets/overlays/dui.png",
//   "Cẳng chân - Mặt trong": "assets/overlays/cangchan.png",
//   "Cẳng chân - Mặt ngoài": "assets/overlays/cangchan.png",
//   "Bàn chân - Mặt mu": "assets/overlays/banchan.png",
//   "Bàn chân - Mặt lòng (chụp 2 chân)": "assets/overlays/banchan.png",
// };
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import '../../utils/shared_preferences_manager.dart';

class ImageUploadField extends StatefulWidget {
  final String label;
  final int templateId;
  final List<String>?
      initialImageUrls; // Đổi thành List<String> để hỗ trợ nhiều ảnh
  final String? selectedOption; // để map overlay
  final ValueChanged<List<String>?>
      onChanged; // Đổi onChanged thành List<String>?

  const ImageUploadField({
    super.key,
    required this.label,
    required this.templateId,
    this.initialImageUrls,
    this.selectedOption,
    required this.onChanged,
  });

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = []; // Danh sách ảnh local chưa upload
  List<String> _uploadedUrls = []; // Danh sách URL đã upload
  bool _isUploading = false;

  String? get _overlayAsset => widget.selectedOption != null
      ? optionToOverlay[widget.selectedOption!]
      : null;

  @override
  void initState() {
    super.initState();
    _uploadedUrls = List<String>.from(widget.initialImageUrls ?? []);
  }

  Future<void> _uploadFile(File file) async {
    final sfm = await GetIt.instance<SharedPreferencesManager>();
    final userId = sfm.getInt("user_id");

    try {
      final uri = Uri.parse(
        "https://drmayday.ibme.edu.vn/urticaria-collector/api/v1/medical-records/upload"
        "?user_id=$userId&record_type=${widget.templateId}",
      );

      final request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath("file", file.path));

      final response = await request.send();
      if (response.statusCode == 201) {
        final body = await response.stream.bytesToString();
        setState(() {
          _uploadedUrls.add(body);
          _selectedImages.remove(file);
        });
        widget.onChanged(_uploadedUrls.isNotEmpty ? _uploadedUrls : null);
      } else {
        throw Exception("Upload thất bại: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi upload: $e")),
        );
      }
    }
  }

  Future<void> _uploadAllSelected() async {
    setState(() => _isUploading = true);
    for (final file in List<File>.from(_selectedImages)) {
      await _uploadFile(file);
    }
    setState(() => _isUploading = false);
  }

  Future<void> _pickFromGallery() async {
    final List<XFile>? picked = await _picker
        .pickMultiImage(); // Sử dụng pickMultiImage để chọn nhiều ảnh
    if (picked == null || picked.isEmpty) return;
    final files = picked.map((x) => File(x.path)).toList();
    setState(() {
      _selectedImages.addAll(files);
    });
    await _uploadAllSelected();
  }

  Future<void> _openCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CustomCameraScreen(
          camera: firstCamera,
          overlayAsset: _overlayAsset,
          onCapture: (file) async {
            setState(() {
              _selectedImages.add(file);
            });
            await _uploadAllSelected();
          },
        ),
      ),
    );
  }

  void _removeImage(String url) {
    setState(() {
      _uploadedUrls.remove(url);
    });
    widget.onChanged(_uploadedUrls.isNotEmpty ? _uploadedUrls : null);
  }

  void _removeLocalImage(File file) {
    setState(() {
      _selectedImages.remove(file);
    });
  }

  void _showFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(
                child: Image.network(imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullLocalImage(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(
                child: Image.file(file),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = _selectedImages.isNotEmpty || _uploadedUrls.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (hasImages)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  3, // Hiển thị 3 ảnh mỗi hàng, bạn có thể điều chỉnh
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: _uploadedUrls.length + _selectedImages.length,
            itemBuilder: (context, index) {
              if (index < _uploadedUrls.length) {
                final url = _uploadedUrls[index];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => _showFullImage(url),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Center(child: Text("❌")),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => _removeImage(url),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.black54, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                final file = _selectedImages[index - _uploadedUrls.length];
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => _showFullLocalImage(file),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(file, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => _removeLocalImage(file),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.black54, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          )
        else
          Container(
            height: 120,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                SizedBox(height: 6),
                Text("Chọn ảnh", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        if (_isUploading)
          const Center(child: CircularProgressIndicator())
        else
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text("Chọn ảnh"),
                onPressed: _pickFromGallery,
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Chụp ảnh"),
                onPressed: _openCamera,
              ),
            ],
          ),
      ],
    );
  }
}

// Lớp _CustomCameraScreen giữ nguyên, vì chỉ chụp 1 ảnh/lần, nhưng sẽ add vào list

/// Custom Camera với overlay
class _CustomCameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final String? overlayAsset;
  final Function(File) onCapture;

  const _CustomCameraScreen({
    required this.camera,
    this.overlayAsset,
    required this.onCapture,
  });

  @override
  State<_CustomCameraScreen> createState() => _CustomCameraScreenState();
}

class _CustomCameraScreenState extends State<_CustomCameraScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCapturing = false;
  bool _showOverlay = true;

  // Animation controllers
  late AnimationController _captureAnimationController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();

    _captureAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.6,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    debugPrint(
        "[CustomCameraScreen] Init with overlay: ${widget.overlayAsset}");
  }

  @override
  void dispose() {
    _controller?.dispose();
    _captureAnimationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isCapturing) return;

    try {
      setState(() {
        _isCapturing = true;
      });

      // Animation hiệu ứng chụp ảnh
      await _captureAnimationController.forward();
      await _captureAnimationController.reverse();

      debugPrint("[CustomCameraScreen] Taking picture...");
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();

      final dir = await getTemporaryDirectory();
      final filePath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);
      await image.saveTo(filePath);

      debugPrint("[CustomCameraScreen] Saved to $filePath");
      widget.onCapture(file);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("[CustomCameraScreen] Error capturing image: $e");
      setState(() {
        _isCapturing = false;
      });
    }
  }

  void _switchCamera() async {
    final cameras = await availableCameras();
    if (cameras.length < 2) return;

    final currentCamera = _controller?.description;
    CameraDescription newCamera;

    if (currentCamera?.lensDirection == CameraLensDirection.back) {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
    } else {
      newCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
    }

    await _controller?.dispose();
    _controller = CameraController(newCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });

    if (_showOverlay) {
      _fadeController.reverse();
    } else {
      _fadeController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "[CustomCameraScreen] build() overlayAsset = ${widget.overlayAsset}");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),

          // Overlay với hiệu ứng mờ
          if (widget.overlayAsset != null && _showOverlay)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.overlayAsset!),
                          fit: BoxFit.contain,
                          opacity: _fadeAnimation.value,
                        ),
                      ),
                      child: CustomPaint(
                        painter: DashedBorderPainter(),
                        child: Container(),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Top Controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Overlay toggle button
                if (widget.overlayAsset != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _showOverlay ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: _toggleOverlay,
                    ),
                  ),

                // Camera switch button
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.flip_camera_ios, color: Colors.white),
                    onPressed: _switchCamera,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.photo_library, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        // Có thể gọi _pickFromGallery ở đây nếu cần
                      },
                    ),
                  ),

                  // Capture button với animation
                  GestureDetector(
                    onTap: _takePicture,
                    child: AnimatedBuilder(
                      animation: _captureAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              1.0 - (_captureAnimationController.value * 0.1),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _isCapturing ? Colors.red : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: _isCapturing
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  )
                                : const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Flash button (placeholder)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.flash_auto, color: Colors.white),
                      onPressed: () {
                        // Implement flash toggle nếu cần
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Instruction text
          if (widget.overlayAsset != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Căn chỉnh theo khung hướng dẫn và nhấn chụp",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom painter để vẽ viền nét đứt
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 4.0;

    // Vẽ viền nét đứt xung quanh
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
            20, size.height * 0.1, size.width - 40, size.height * 0.8),
        const Radius.circular(12),
      ));

    _drawDashedPath(canvas, path, paint, dashWidth, dashSpace);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashWidth,
      double dashSpace) {
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < pathMetric.length) {
        final length = draw ? dashWidth : dashSpace;
        final extractPath = pathMetric.extractPath(
          distance,
          distance + length,
        );
        if (draw) {
          canvas.drawPath(extractPath, paint);
        }
        distance += length;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Map option -> overlay asset
const Map<String, String> optionToOverlay = {
  "Mặt thẳng": "assets/overlays/mat.png",
  "Nghiêng trái": "assets/overlays/mat.png",
  "Nghiêng phải": "assets/overlays/mat.png",
  "Miệng": "assets/overlays/mieng.png",
  "Thân trước": "assets/overlays/than.png",
  "Thân sau": "assets/overlays/than.png",
  "Bàn tay - Mặt mu": "assets/overlays/bantay.png",
  "Bàn tay - Mặt lòng (chụp 2 tay)": "assets/overlays/bantay.png",
  "Cẳng tay - Mặt trong": "assets/overlays/cangtay.png",
  "Cẳng tay - Mặt ngoài": "assets/overlays/cangtay.png",
  "Cánh tay - Mặt trong": "assets/overlays/canhtay.png",
  "Cánh tay - Mặt ngoài": "assets/overlays/canhtay.png",
  "Sinh dục": "assets/overlays/sinhduc.png",
  "Đùi - Mặt trong": "assets/overlays/dui.png",
  "Đùi - Mặt ngoài": "assets/overlays/dui.png",
  "Cẳng chân - Mặt trong": "assets/overlays/cangchan.png",
  "Cẳng chân - Mặt ngoài": "assets/overlays/cangchan.png",
  "Bàn chân - Mặt mu": "assets/overlays/banchan.png",
  "Bàn chân - Mặt lòng (chụp 2 chân)": "assets/overlays/banchan.png",
};
