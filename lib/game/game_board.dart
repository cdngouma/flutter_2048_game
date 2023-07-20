import 'dart:math';

class GameBoard {
  int boardSize = 4;
  List<Map<String, int> > tiles = [];
  List<List<int> > grid = [];
  List<int> emptyTilesPos = [];

  int score = 0;

  GameBoard({required int size}) {
    boardSize = size;
    reset();
  }

  void reset() {
    tiles = [];
    grid = [];
    emptyTilesPos = [];

    for(int r=0; r < boardSize; r++) {
      grid.add([]);
      for(int c=0; c < boardSize; c++) {
        grid[r].add(0);
        emptyTilesPos.add(toIndex(r, c, boardSize));
        tiles.add({
          "state": 0, // 0 = disabled, 1 = active
          "position": toIndex(r, c, boardSize), // Position on the tiles list
          "value": 0
        });
      }
    }

    // Add initial first 2 tiles
    createTile();
    createTile();

    // Reset score
    score = 0;
  }

  void createTile() {
    if(emptyTilesPos.isEmpty) {
      return;
    }

    var random = Random();
    int position = emptyTilesPos[random.nextInt(emptyTilesPos.length)];
    List<int> coor = to2d(position, boardSize);
    // Mark tile on 2d grid
    grid[coor[0]][coor[1]] = 2;
    // Update tile data
    tiles[position]["state"] = 1;
    tiles[position]["value"] = 2;
    // Remove tile from list of empty tiles
    emptyTilesPos.removeWhere((e) => e == position);
  }

  void updateTile(int idx, int crossAxisIdx, state, value, updateIdx, int direction) {
    int position;
    if(direction == 0 || direction == 2) {
      // Update inner grid
      grid[crossAxisIdx][idx] = value;
      position = toIndex(crossAxisIdx, idx, boardSize);
    } else if(direction == 1 || direction == 3){
      // Update inner grid
      grid[idx][crossAxisIdx] = value;
      position = toIndex(idx, crossAxisIdx, boardSize);
    } else {
      throw Exception("Unknown direction: $direction");
    }

    tiles[position]["state"] = state;
    tiles[position]["value"] = value;
    tiles[position]["position"] = position;
    // Update empty tiles list
    if(state != 0) {
      emptyTilesPos.removeWhere((e) => e == position);
    } else if(!emptyTilesPos.contains(position)) {
      emptyTilesPos.add(position);
    }
  }

  void moveTile(int direction) {
    // 0: Left, 1: Up, 2: Right, 3: Down
    if(direction < 0 || direction > 3) {
      throw Exception("Unknown direction: $direction");
    }
    int getIncrement(int direction) {
      if(direction == 0 || direction == 1) {
        return 1;
      } else {
        return -1;
      }
    }

    bool loopCondition(idx, direction) {
      if(direction == 0 || direction == 1) {
        return idx < boardSize;
      } else {
        return idx >= 0;
      }
    }

    int getTileValue(int idx, int crossAxisIdx, int direction) {
      if(direction == 1 || direction == 3) {
        return grid[idx][crossAxisIdx];
      } else {
        return grid[crossAxisIdx][idx];
      }
    }

    final INCREMENT = getIncrement(direction);

    for(int crossAxisIdx=0; crossAxisIdx < boardSize; crossAxisIdx++) {
      List<List<int>> updatedRowsOrCols = [];
      int tile1Idx = direction == 0 || direction == 1 ? 0 : boardSize-1;
      int tile2Idx = tile1Idx + INCREMENT;

      // Skip empty tiles before the first numbered tile
      while(loopCondition(tile1Idx, direction)) {
        if(getTileValue(tile1Idx, crossAxisIdx, direction) == 0) {
          tile1Idx += INCREMENT;
          tile2Idx = tile1Idx + INCREMENT;
          continue;
        }

        // Skip empty tiles between the numbered tile considered and the closest
        // one on the same main axis
        while(loopCondition(tile2Idx, direction) &&
            getTileValue(tile2Idx, crossAxisIdx, direction) == 0) {
          tile2Idx += INCREMENT;
        }

        // If the merge condition fails do not merge
        if(!loopCondition(tile2Idx, direction) ||
            getTileValue(tile1Idx, crossAxisIdx, direction) != getTileValue(tile2Idx, crossAxisIdx, direction)) {
          updatedRowsOrCols.add([getTileValue(tile1Idx, crossAxisIdx, direction), 2]);
          tile1Idx = tile2Idx;
          tile2Idx = tile1Idx + INCREMENT;
        }
        // If two adjacent tiles have the same number, merge them
        // Multiply their common value by 2
        else {
          int value = getTileValue(tile1Idx, crossAxisIdx, direction)*2;
          updatedRowsOrCols.add([value, 3]);
          tile1Idx = tile2Idx + INCREMENT;
          tile2Idx = tile1Idx + INCREMENT;
          score += value;
        }
      }

      // Cleanup grid
      // Move numbered tiles to the appropriate end
      for(int idx=0; idx<updatedRowsOrCols.length; idx++) {
        int value = updatedRowsOrCols[idx][0];
        int state = updatedRowsOrCols[idx][1];
        int updateIdx;
        if(direction == 0 || direction == 1) {
          updateIdx = idx;
        } else {
          updateIdx = boardSize-1-idx;
        }
        updateTile(updateIdx, crossAxisIdx, state, value, tile1Idx, direction);
      }

      int startIdx;
      int endIdx;

      if(direction == 0 || direction == 1) {
        startIdx = updatedRowsOrCols.length;
        endIdx = boardSize;
      } else {
        startIdx = 0;
        endIdx = boardSize - updatedRowsOrCols.length;
      }

      // Free up tiles
      for(int idx=startIdx; idx < endIdx; idx++) {
        updateTile(idx, crossAxisIdx, 0, 0, tile1Idx, direction);
      }
    }
  }

  // 0: Left, 1: Up, 2: Right, 3: Down
  void moveDown() {
    moveTile(3);
  }

  void moveUp() {
    moveTile(1);
  }

  void moveLeft() {
    moveTile(0);
  }

  void moveRight() {
    moveTile(2);
  }

  List<Map<String, int>> getElements() {
    return tiles;
  }

  int getScore() {
    return score;
  }
}

int toIndex(int r, int c, int rows) {
  // Convert 2D indices to 1D
  return r * rows + c;
}

List<int> to2d(int index, int cols) {
  // Convert 1D index to 2D
  int r = index ~/ cols;
  int c = index % cols;
  return [r, c];
}