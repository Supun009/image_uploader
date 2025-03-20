import 'package:flutter/material.dart';
import 'package:imageuploader/pages/upload_image_page.dart';
import 'package:imageuploader/utills/show_snackbar.dart';
import 'package:imageuploader/view_model/image_view_model.dart';
import 'package:imageuploader/widgets/post_container.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPost();
    });
  }

  Future<void> _fetchPost() async {
    try {
      final res = await context.read<ImageViewModel>().fetchPost();
      if (!res['success']) {
        if (mounted) {
          showCustomSnackbar(context, res['message']);
        }
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackbar(context, 'An error occurred while fetching posts');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final postList = context.watch<ImageViewModel>().postList;
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Uploader'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadImagePage(),
                    )),
                icon: Icon(Icons.add)),
          ),
        ],
      ),
      body: postList.isEmpty
          ? Center(
              child: Text(
                'No posts found',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                return PostContainer(post: postList[index]);
              },
            ),
    );
  }
}
