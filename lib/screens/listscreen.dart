import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettest/bloc/post_bloc/post_bloc.dart';
import 'package:pettest/bloc/post_bloc/post_state.dart';
import 'package:pettest/model/post_model.dart';
import 'package:pettest/widgets/post_tile.dart';

class ListBuilderScreen extends StatefulWidget {
  const ListBuilderScreen({Key? key}) : super(key: key);

  @override
  State<ListBuilderScreen> createState() => _ListBuilderScreenState();
}

class _ListBuilderScreenState extends State<ListBuilderScreen> {
  List postData = <PostDataModel>[];

  bool isLoaded = false;
  bool hasError = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PostBloc>().add(LoadPost());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MultiBlocListener(
            listeners: [
              BlocListener<PostBloc, PostState>(
                listener: ((context, state) {
                  if (state is PostLoaded) {
                    setState(() {
                      isLoaded = true;
                      hasError = false;
                      postData = state.postData;
                    });
                  }
                  if (state is PostLoading) {
                    setState(() {
                      isLoaded = false;
                      hasError = false;
                    });
                  }
                  if (state is PostFailedError) {
                    setState(() {
                      isLoaded = true;
                      hasError = true;
                    });
                  }
                }),
              )
            ],
            child: Container(),
          ),
          if (!isLoaded) const CircularProgressIndicator(),
          if (isLoaded && !hasError) ...[
            if (postData.isEmpty) ...[
              const Center(
                child: Text("Post are empty"),
              )
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: postData.length,
                  itemBuilder: ((context, index) {
                    return PostTile(postDataModel: postData[index]);
                  }),
                ),
              )
            ]
          ] else if (hasError) ...[
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Something went wrong",
                    style: TextStyle(fontSize: 18),
                  ),
                  ElevatedButton(
                    child: const Text("Retry"),
                    onPressed: () {
                      context.read<PostBloc>().add(LoadPost());
                    },
                  )
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}
