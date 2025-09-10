// import 'package:flutter/material.dart';
// import 'image_upload_widget.dart';
//
// class CustomMultipleChoiceWithImages extends StatefulWidget {
//   final String label;
//   final List<String> selectedValues;
//   final List<String> options;
//   final Map<String, List<String>>? subOptions;
//   final Map<String, List<String>> imagePaths;
//   final Function(List<String>) onChanged;
//   final Function(Map<String, List<String>>) onImagesChanged;
//   final bool isRequired;
//
//   const CustomMultipleChoiceWithImages({
//     Key? key,
//     required this.label,
//     required this.selectedValues,
//     required this.options,
//     this.subOptions,
//     required this.imagePaths,
//     required this.onChanged,
//     required this.onImagesChanged,
//     this.isRequired = false,
//   }) : super(key: key);
//
//   @override
//   State<CustomMultipleChoiceWithImages> createState() =>
//       _CustomMultipleChoiceWithImagesState();
// }
//
// class _CustomMultipleChoiceWithImagesState
//     extends State<CustomMultipleChoiceWithImages> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.isRequired ? '${widget.label} *' : widget.label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Column(
//             children: widget.options.map((option) {
//               final isSelected = widget.selectedValues.contains(option);
//               return Column(
//                 children: [
//                   CheckboxListTile(
//                     title: Text(option),
//                     value: isSelected,
//                     onChanged: (bool? value) {
//                       List<String> newSelected =
//                           List.from(widget.selectedValues);
//                       if (value == true) {
//                         newSelected.add(option);
//                       } else {
//                         newSelected.remove(option);
//                       }
//                       widget.onChanged(newSelected);
//                     },
//                     controlAffinity: ListTileControlAffinity.leading,
//                     contentPadding: EdgeInsets.zero,
//                   ),
//                   if (isSelected && option != 'Thanh quản') ...[
//                     // Show sub-options if available
//                     if (widget.subOptions?.containsKey(option) == true) ...[
//                       Padding(
//                         padding: const EdgeInsets.only(left: 32),
//                         child: Column(
//                           children:
//                               widget.subOptions![option]!.map((subOption) {
//                             return CheckboxListTile(
//                               title: Text(subOption),
//                               value: widget.selectedValues
//                                   .contains('$option - $subOption'),
//                               onChanged: (bool? value) {
//                                 List<String> newSelected =
//                                     List.from(widget.selectedValues);
//                                 if (value == true) {
//                                   newSelected.add('$option - $subOption');
//                                 } else {
//                                   newSelected.remove('$option - $subOption');
//                                 }
//                                 widget.onChanged(newSelected);
//                               },
//                               controlAffinity: ListTileControlAffinity.leading,
//                               contentPadding: EdgeInsets.zero,
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                     // Image upload for this location
//                     Container(
//                       margin:
//                           const EdgeInsets.only(left: 16, top: 8, bottom: 8),
//                       child: ImageUploadWidget(
//                         label: 'Ảnh vị trí $option',
//                         imagePaths: widget.imagePaths[option] ?? [],
//                         onImagesChanged: (images) {
//                           Map<String, List<String>> newImagePaths =
//                               Map.from(widget.imagePaths);
//                           newImagePaths[option] = images;
//                           widget.onImagesChanged(newImagePaths);
//                         },
//                       ),
//                     ),
//                   ],
//                 ],
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../constant/color.dart';
import 'image_upload_widget.dart';

class CustomMultipleChoiceWithImages extends StatefulWidget {
  final String label;
  final List<String> selectedValues;
  final List<String> options;
  final Map<String, List<String>>? subOptions;
  final Map<String, List<String>> imagePaths;
  final Function(List<String>) onChanged;
  final Function(Map<String, List<String>>) onImagesChanged;
  final bool isRequired;

  const CustomMultipleChoiceWithImages({
    Key? key,
    required this.label,
    required this.selectedValues,
    required this.options,
    this.subOptions,
    required this.imagePaths,
    required this.onChanged,
    required this.onImagesChanged,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<CustomMultipleChoiceWithImages> createState() =>
      _CustomMultipleChoiceWithImagesState();
}

class _CustomMultipleChoiceWithImagesState
    extends State<CustomMultipleChoiceWithImages> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(covariant CustomMultipleChoiceWithImages oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Đồng bộ khi parent update value
    if (oldWidget.selectedValues != widget.selectedValues) {
      _selectedValues = List.from(widget.selectedValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RichText(
              text: TextSpan(
                text: widget.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                  letterSpacing: 0.2,
                ),
                children: [
                  if (widget.isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.redColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Options
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.borderColor,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: widget.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = _selectedValues.contains(option);

                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                          border: index < widget.options.length - 1
                              ? Border(
                                  bottom: BorderSide(
                                    color:
                                        AppColors.borderColor.withOpacity(0.5),
                                    width: 0.8,
                                  ),
                                )
                              : null,
                        ),
                        child: CheckboxListTile(
                          title: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.primaryColor,
                              letterSpacing: 0.1,
                            ),
                          ),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedValues.add(option);
                              } else {
                                _selectedValues.remove(option);
                              }
                            });
                            widget.onChanged(_selectedValues);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          activeColor: AppColors.primaryColor,
                          checkColor: AppColors.whiteColor,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.comfortable,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      // Sub-options + Image Upload
                      if (isSelected && option != 'Thanh quản') ...[
                        // Sub-options
                        if (widget.subOptions?.containsKey(option) == true) ...[
                          Container(
                            margin: const EdgeInsets.only(
                                left: 24, right: 16, bottom: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.borderColor.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tùy chọn phụ cho $option:',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grayColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...widget.subOptions![option]!.map((subOption) {
                                  final subKey = '$option - $subOption';
                                  final isSubSelected =
                                      _selectedValues.contains(subKey);

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    decoration: BoxDecoration(
                                      color: isSubSelected
                                          ? AppColors.primaryColor
                                              .withOpacity(0.08)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: CheckboxListTile(
                                      title: Text(
                                        subOption,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isSubSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: isSubSelected
                                              ? AppColors.primaryColor
                                              : AppColors.primaryColor,
                                        ),
                                      ),
                                      value: isSubSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _selectedValues.add(subKey);
                                          } else {
                                            _selectedValues.remove(subKey);
                                          }
                                        });
                                        widget.onChanged(_selectedValues);
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8),
                                      dense: true,
                                      activeColor: AppColors.primaryColor,
                                      checkColor: AppColors.whiteColor,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                        // Image Upload
                        Container(
                          margin: const EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 16),
                          child: ImageUploadWidget(
                            label: 'Ảnh vị trí $option',
                            imagePaths: widget.imagePaths[option] ?? [],
                            onImagesChanged: (images) {
                              Map<String, List<String>> newImagePaths =
                                  Map.from(widget.imagePaths);
                              newImagePaths[option] = images;
                              widget.onImagesChanged(newImagePaths);
                            },
                          ),
                        ),
                      ],
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
