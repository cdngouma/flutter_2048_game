import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048_game/game/board_widget.dart';
import 'package:flutter_2048_game/game/game_board.dart';
import 'package:flutter_2048_game/game/score_bar.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int currentScore = 0;
  int bestScore = 0;
  GameBoard board = GameBoard(size: 4);

  void resetBoard() {
    board.reset();
    setState(() {
      board = board;
      currentScore = 0;
      //bestScore = 0;
    });
  }

  void moveTiles(int direction) {
    // Move and merge tiles
    switch(direction) {
      case 0:
        board.moveRight();
      case 1:
        board.moveUp();
      case 2:
        board.moveLeft();
      case 3:
        board.moveDown();
    }

    // Create a new tile
    board.createTile();

    setState(() {
      board = board;
      currentScore = board.getScore();
      bestScore = max(bestScore, currentScore);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text("2048 Game"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ScoreBar(
              resetBoard: () => { resetBoard() },
              currentScore: currentScore,
              bestScore: bestScore,
            ),
            GameBoardWidget(
              updateScore: (int score) { print("Debug:: Implement updateScore()"); },
              moveTiles: ({required int direction}) { moveTiles(direction); },
              boardElements: board.getElements(),
            )
          ],
        ),
      ),
    );
  }
}