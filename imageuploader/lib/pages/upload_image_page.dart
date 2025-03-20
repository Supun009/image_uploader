import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imageuploader/utills/show_snackbar.dart';
import 'package:imageuploader/view_model/image_view_model.dart';
import 'package:imageuploader/widgets/input_feild.dart';
import 'package:provider/provider.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _commentController = TextEditingController();
  File? _selectedImage;
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        _selectedImage = File(image.path);
      });
    } catch (e) {
      if (mounted) {
        showCustomSnackbar(context, 'An error occurred while picking image');
      }
    }
  }

  void _uploadImage() async {
    try {
      if (_selectedImage == null) {
        showCustomSnackbar(context, 'Please select an image');
        return;
      }

      String comment = _commentController.text.trim();
      comment = comment.replaceAll(RegExp(r'\s+'), ' ');
      if (comment.isEmpty) {
        showCustomSnackbar(context, 'Please enter a comment');
        return;
      }
      final res = await context.read<ImageViewModel>().uploadImage(
          selectedImage: _selectedImage!, comment: _commentController.text);
      if (res['success']) {
        if (mounted) {
          showCustomSnackbar(context, res['message']);
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          showCustomSnackbar(context, res['message']);
        }
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackbar(context, 'An error occurred');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<ImageViewModel>(
                builder: (context, state, child) {
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 2,
                                style: BorderStyle.solid,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: _selectedImage == null
                                ? Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: _pickImage,
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              InputFeild(commentController: _commentController),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _uploadImage();
                }
              },
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade500,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'upload image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
