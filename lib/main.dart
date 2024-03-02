import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Player ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    play();
    super.initState();
  }

  Future<void> play() async {
    const url = 'https://youtu.be/BOHFN7FnWlo?si=mWPtXW7WNrXuMzz2';
    final convertUrl = YoutubePlayer.convertUrlToId(url);
    if (convertUrl == null) return;
    _controller = YoutubePlayerController(
      initialVideoId: convertUrl,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
      ),
    )..addListener(() {
        if (mounted) {
          print('set');
          setState(() {});
        }
      });
    print('==================================================');
    print('initState');
    print(url);
    print(convertUrl);
    print('==================================================');

    // if new url
    // _controller?.load(videoId);
  }

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> listener() async {
    if (mounted) {
      print('setState');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text('Youtube Player'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: false,
              onReady: () {
                _controller?.addListener(listener);
              },
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                  setState(() {});
                },
                iconSize: 42,
                color: _controller!.value.isPlaying ? Colors.red : Colors.green,
                icon: Icon(
                  _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
