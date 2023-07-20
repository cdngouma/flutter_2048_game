import 'package:flutter/material.dart';

class ScoreBar extends StatelessWidget {
  final int currentScore;
  final int bestScore;
  final Function resetBoard;

  const ScoreBar({
    super.key, required this.resetBoard, this.currentScore=0, this.bestScore=0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15.0, 13.0, 15.0, 13.0),
      decoration: BoxDecoration(
          color: Colors.grey[900]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                resetBoard();
              },
              child: const Text(
                "New Game",
                style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 1.0
                ),
              )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ScoreText(title: "SCORE", text: "${currentScore}"),
              const SizedBox(width: 15.0),
              ScoreText(title: "BEST SCORE", text: "${bestScore}")
            ],
          )
        ],
      ),
    );
  }
}

class ScoreText extends StatelessWidget {
  final String text;
  final String title;

  const ScoreText({super.key, required this.text, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(title,
            style: TextStyle(
                fontSize: 15.0, letterSpacing: 2.0, color: Colors.brown[100]
            ),
          ),
          const SizedBox(height: 5.0),
          Text(text,
            style: const TextStyle(
                fontSize: 30.0,
                letterSpacing: 2.0,
                color: Colors.white70,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}