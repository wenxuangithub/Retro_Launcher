import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cube/flutter_cube.dart';

void main() {
  runApp(GameLauncherApp());
}

class GameLauncherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Layout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.pressStart2pTextTheme()
            .apply(bodyColor: Colors.cyanAccent),
      ),
      home: GameLauncherHome(),
    );
  }
}

class GameLauncherHome extends StatefulWidget {
  @override
  _GameLauncherHomeState createState() => _GameLauncherHomeState();
}

class _GameLauncherHomeState extends State<GameLauncherHome>
    with SingleTickerProviderStateMixin {
  final List<String> games = [
    'Space Blaster 3000',
    'Cyber Kart 1989',
    'Dungeon DOS X2',
    'Neo Ninja Hunter',
    'Pixel Invaders 64',
    'Toxic Tetris 2',
  ];

  // For chat
  final List<String> chatMessages = [
    "> User: Hello!",
    "> Bot: Welcome to Retro Chat.",
    "> User: Launch game."
  ];
  final TextEditingController _chatController = TextEditingController();

  Object? model;
  late Ticker _ticker;
  Scene? scene;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      if (model != null && scene != null) {
        model!.rotation.y += 5;
        scene!.update();
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _chatController.dispose();
    super.dispose();
  }

  Widget retroBox({required Widget child}) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(color: Colors.greenAccent, width: 2),
      ),
      child: child,
    );
  }
  final ScrollController _chatScrollController = ScrollController();
  final FocusNode _chatFocusNode = FocusNode();

  void _sendMessage() {
    String text = _chatController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        chatMessages.add("> User: $text");
        chatMessages.add("> Bot: [Echo] $text");
      });
      _chatController.clear();

      // Auto-scroll to bottom
      Future.delayed(Duration(milliseconds: 50), () {
        _chatScrollController.jumpTo(
          _chatScrollController.position.maxScrollExtent,
        );
      });

      // Re-focus so user can keep typing
      Future.delayed(Duration(milliseconds: 100), () {
        _chatFocusNode.requestFocus();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A0033), Color(0xFF330066), Color(0xFF660066)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // LEFT PANEL - SELECTION
          Expanded(
            child: retroBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SELECTION", style: TextStyle(fontSize: 10)),
                  SizedBox(height: 10),
                  ...games.map((game) => GameTile(title: game)).toList(),
                ],
              ),
            ),
          ),

          // MIDDLE PANEL - CONTENT (human.obj)
          Expanded(
            child: retroBox(
              child: Column(
                children: [
                  Text("CONTENT", style: TextStyle(fontSize: 10)),
                  SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: Cube(
                        onSceneCreated: (Scene s) {
                          model = Object(
                            scale: Vector3(8.0, 8.0, 8.0),
                            fileName: 'assets/human.obj',
                          );
                          s.world.add(model!);
                          scene = s;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT PANEL - CHAT INTERFACE (Terminal Style)
          Expanded(
            child: retroBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("TERMINAL", style: TextStyle(fontSize: 10)),
                  SizedBox(height: 5),
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: ListView.builder(
                        controller: _chatScrollController,
                        itemCount: chatMessages.length,
                        itemBuilder: (context, index) {
                          return Text(
                            chatMessages[index],
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'monospace',
                              color: Colors.greenAccent,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child:TextField(
                      controller: _chatController,
                      focusNode: _chatFocusNode,
                      autofocus: true, // Focus immediately on app start
                      onSubmitted: (_) => _sendMessage(),
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'monospace',
                        color: Colors.greenAccent,
                      ),
                      cursorColor: Colors.greenAccent,
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        hintStyle: TextStyle(
                          color: Colors.greenAccent.withOpacity(0.4),
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
        ],
      )
    );
  }
}

class GameTile extends StatelessWidget {
  final String title;
  const GameTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: TextStyle(fontSize: 10)),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Launching $title... (just kidding!)')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: Text('START', style: TextStyle(fontSize: 8)),
          ),
        ],
      ),
    );
  }
}
