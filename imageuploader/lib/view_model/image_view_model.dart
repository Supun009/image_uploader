import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imageuploader/constant/server_url.dart';
import 'package:imageuploader/models/post.dart';
import 'package:imageuploader/utills/permisiion_handler.dart';
import 'package:path/path.dart';

class ImageViewModel extends ChangeNotifier {
  final Constant _constant = Constant();
  bool _isLoading = false;
  List<Post> _posts = [];

  bool get isLoading => _isLoading;
  List<Post> get postList => _posts;

  Future<Map<String, dynamic>> uploadImage(
      {required File selectedImage, required String comment}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${_constant.serverUrl}/upload_image.php'),
      );

      request.fields['comment'] = comment;

      request.files.add(
        http.MultipartFile(
          'image',
          selectedImage.readAsBytes().asStream(),
          selectedImage.lengthSync(),
          filename: basename(selectedImage.path),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        _isLoading = false;
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);
        notifyListeners();
        fetchPost();
        return data;
      }
      return {'success': false, 'message': 'An error occurred'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> fetchPost() async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await http.get(
        Uri.parse('${_constant.serverUrl}/get_images.php'),
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        final List<dynamic> data = json.decode(response.body);
        _posts = data.map((e) => Post.fromMap(e)).toList();
        notifyListeners();
        _saveImagesLocal();
        return {'success': true};
      }
      return {'success': false, 'message': 'An error occurred'};
    } catch (e) {
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  Future<void> _saveImagesLocal() async {
    try {
      if (await handlePermission()) {
        final imageDirectory = Directory('/storage/emulated/0/imageuploader');
        if (!imageDirectory.existsSync()) {
          imageDirectory.createSync(recursive: true);
        }

        final imageDirectoryPath = imageDirectory.path;
        for (final post in _posts) {
          final imageFile = File('$imageDirectoryPath/${post.id}.jpg');
          if (await imageFile.exists()) {
            continue;
          }
          final image = await http.get(Uri.parse(post.imageUrl));

          imageFile.writeAsBytesSync(image.bodyBytes);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
