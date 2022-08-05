import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pettest/bloc/asset_bloc/asset_bloc.dart';
import 'package:pettest/bloc/post_bloc/post_bloc.dart';
import 'package:pettest/model/asset_model.dart';
import 'package:pettest/repo/asset_repo.dart';
import 'package:pettest/repo/post_repo.dart';
import 'package:pettest/screens/listscreen.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'bloc/asset_bloc/asset_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AssetBloc>(
          create: (context) => AssetBloc(
            assetRepo: AssetRepo(),
          ),
        ),
        BlocProvider(
          create: (context) => PostBloc(
            postRepo: PostRepo(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AssetModel assetModel = AssetModel();
  bool isLoading = false;
  bool showError = false;
  ValueNotifier<bool> isSuccessFullyLoaded = ValueNotifier(false);
  late VideoPlayerController _controller;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AssetBloc>().add(LoadAsset());
      isSuccessFullyLoaded.addListener(() {
        setState(() {});
      });
    });
    super.initState();
  }

  void errorDialog() async {
    var result = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Something went Wrong",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              const Text(
                "Try Again",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Retry"),
                ),
              )
            ],
          ),
        ),
      ),
    );
    if (result != null) {
      context.read<AssetBloc>().add(LoadAsset());
    }
  }

  Future<Box> openHiveBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      Directory directory =
          await pathProvider.getApplicationDocumentsDirectory();
      Hive.init(directory.path);
    }
    return await Hive.openBox(boxName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: isSuccessFullyLoaded.value
            ? FloatingActionButton(
                child: const Icon(Icons.chevron_right),
                onPressed: () async {
                  try {
                    var box = await openHiveBox('assetBox');
                    box.put('asset_url', assetModel.url);
                  } catch (e) {
                    print("failed");
                  }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ListBuilderScreen()));
                },
              )
            : Container(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MultiBlocListener(
              listeners: [
                BlocListener<AssetBloc, AssetState>(
                  listener: ((context, state) {
                    if (state is AssetLoaded) {
                      setState(() {
                        isLoading = false;
                        assetModel = state.assetModel;
                        showError = false;
                        isSuccessFullyLoaded.value = true;
                      });
                      if (state.assetModel.isVideo) {
                        _controller = VideoPlayerController.network(state
                                .assetModel.url ??
                            'https://random.dog/e58bf454-eca8-4cdb-9997-cf016ed92ad8.mp4')
                          ..initialize().then((value) {
                            setState(() {
                              _controller.play();
                              isSuccessFullyLoaded.value = true;
                            });
                          });
                      }
                    }
                    if (state is AssetLoading) {
                      setState(() {
                        isLoading = true;
                        showError = false;
                        isSuccessFullyLoaded.value = false;
                      });
                    }
                    if (state is AssetFailedError) {
                      setState(() {
                        isLoading = false;
                        showError = true;
                        isSuccessFullyLoaded.value = false;
                      });
                      errorDialog();
                    }
                  }),
                ),
              ],
              child: Container(),
            ),
            if (isLoading) ...[
              const CircularProgressIndicator(),
            ] else ...[
              if (assetModel.url != null) ...[
                if (assetModel.isVideo) ...[
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : const CircularProgressIndicator(),
                    ),
                  ),
                ] else ...[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    child: Image.network(
                      assetModel.url ?? "www.google.com",
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          isSuccessFullyLoaded.value = true;
                        }
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ]
            ]
          ],
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
