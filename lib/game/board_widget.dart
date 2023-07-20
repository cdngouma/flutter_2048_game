import 'package:flutter/material.dart';

class GameBoardWidget extends StatelessWidget {
  final Function updateScore;
  final Function moveTiles;
  final List boardElements;

  const GameBoardWidget({
    super.key, required this.updateScore,
    required this.moveTiles, required this.boardElements
  });

  void updateBoard(velocity, direction) {
    // Horizontal: 0, Vertical: 1
    if(direction == 0) {
      // Swipe right
      if(velocity > 0) {
        moveTiles(direction: 0);
      }
      // Swipe left
      else if(velocity < 0) {
        moveTiles(direction: 2);
      }
    } else if(direction == 1) {
      // Swipe down
      if(velocity > 0) {
        moveTiles(direction: 3);
      }
      // Swipe up
      else if(velocity < 0) {
        moveTiles(direction: 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 20.0),
        alignment: Alignment.center,
        child: GestureDetector(
          onHorizontalDragEnd: (details) { updateBoard(details.primaryVelocity, 0); },
          onVerticalDragEnd: (details) { updateBoard(details.primaryVelocity, 1); },
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: boardElements.map((e) => BoardTileWidget(
              position: e["position"], value: e["value"], state: e["state"]
            )).toList(),
          ),
        ),
      ),
    );
  }
}

class BoardTileWidget extends StatelessWidget {
  final int position;
  final int value;
  final int state;
  const BoardTileWidget({super.key, required this.position, required this.value, this.state=0});

  List<Color> pickColor(int value) {
    Color backgroundColor = Colors.grey[900] ?? Colors.black45;
    Color textColor = Colors.white70;
    switch(value) {
      case 0:
        backgroundColor = Colors.grey[900] ?? Colors.black45;
        textColor = Colors.white70;
      case 2:
        backgroundColor = Colors.grey[200] ?? Colors.white70;
        textColor = Colors.black87;
      case 4:
        backgroundColor = Colors.amber[100] ?? Colors.amberAccent;
        textColor = Colors.grey[900] ?? Colors.black87;
      case 8:
        backgroundColor = Colors.orange[300] ?? Colors.orangeAccent;
      case 16:
        backgroundColor = Colors.deepOrange[400] ?? Colors.deepOrangeAccent;
      case 32:
        backgroundColor = Colors.deepOrange[700] ?? Colors.deepOrange;
      case 64:
        backgroundColor = Colors.red[600] ?? Colors.red;
      case 128:
        backgroundColor = Colors.yellow;
        textColor = Colors.black45;
      case 256:
        backgroundColor = Colors.yellow[400] ?? Colors.yellowAccent;
        textColor = Colors.black45;
      case 512:
        backgroundColor = Colors.lime[400] ?? Colors.limeAccent;
      case 1024:
        backgroundColor = Colors.lightGreenAccent;
        textColor = Colors.black45;
      default:
        backgroundColor = Colors.deepPurpleAccent;
    }
    return [backgroundColor, textColor];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          color: Colors.grey[900] ?? Colors.black45,
        ),
        alignment: Alignment.center,
        child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: pickColor(value)[0],
            ),
            alignment: Alignment.center,
            child: TileTextWidget(
                value: value,
                textColor: pickColor(value)[1]
            )
        ),
    );
  }
}

class TileTextWidget extends StatelessWidget {
  final int value;
  final Color textColor;
  const TileTextWidget({
    super.key, required this.value, required this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      value == 0 ? "" : "$value",
      style: TextStyle(
          color: textColor,
          fontSize: 28.0,
          fontWeight: FontWeight.bold
      ),
    );
  }
}


