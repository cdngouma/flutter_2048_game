import 'package:flutter/material.dart';

import 'game/game.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/game',
      routes: {
        "/game": (context) => Game()
      }
  ));
}