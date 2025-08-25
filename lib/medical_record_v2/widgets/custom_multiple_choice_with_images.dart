import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isRequired ? '${widget.label} *' : widget.label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: widget.options.map((option) {
              final isSelected = widget.selectedValues.contains(option);
              return Column(
                children: [
                  CheckboxListTile(
                    title: Text(option),
                    value: isSelected,
                    onChanged: (bool? value) {
                      List<String> newSelected =
                          List.from(widget.selectedValues);
                      if (value == true) {
                        newSelected.add(option);
                      } else {
                        newSelected.remove(option);
                      }
                      widget.onChanged(newSelected);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (isSelected && option != 'Thanh quản') ...[
                    // Show sub-options if available
                    if (widget.subOptions?.containsKey(option) == true) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Column(
                          children:
                              widget.subOptions![option]!.map((subOption) {
                            return CheckboxListTile(
                              title: Text(subOption),
                              value: widget.selectedValues
                                  .contains('$option - $subOption'),
                              onChanged: (bool? value) {
                                List<String> newSelected =
                                    List.from(widget.selectedValues);
                                if (value == true) {
                                  newSelected.add('$option - $subOption');
                                } else {
                                  newSelected.remove('$option - $subOption');
                                }
                                widget.onChanged(newSelected);
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    // Image upload for this location
                    Container(
                      margin:
                          const EdgeInsets.only(left: 16, top: 8, bottom: 8),
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
        ],
      ),
    );
  }
}
