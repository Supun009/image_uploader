import 'package:flutter/material.dart';
import 'package:imageuploader/models/post.dart';

class PostContainer extends StatelessWidget {
  final Post post;
  const PostContainer({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 10,
            color: Colors.grey.shade300,
          ),
        ],
      ),
      child: Column(
        children: [
          Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              post.comment,
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
