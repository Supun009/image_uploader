import 'package:flutter/material.dart';

class InputFeild extends StatelessWidget {
  final TextEditingController commentController;
  const InputFeild({
    super.key,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: commentController,
      decoration: InputDecoration(
        hintText: 'Add a comment',
        hintStyle:
            TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blueAccent,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      validator: (value) => value!.isEmpty ? 'Please enter a comment' : null,
    );
  }
}
