import 'package:flutter/material.dart';
import 'package:pettest/model/post_model.dart';

class PostTile extends StatelessWidget {
  final PostDataModel postDataModel;
  const PostTile({Key? key, required this.postDataModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        tileColor: Colors.black.withOpacity(0.4),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postDataModel.title ?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              thickness: 0.6,
            ),
            const SizedBox(height: 5),
          ],
        ),
        subtitle: Text(
          postDataModel.body ?? "",
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
