import 'dart:math';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:chess/piece.dart';

typedef void OnTileClicked(Piece piece, Position pos);

class Tile extends StatelessWidget {
  final Piece piece;
  final Color color;
  final OnTileClicked onTileClicked;
  final bool canMove;
  final Position pos;

  Tile(
      {@required this.color,
      this.pos,
      this.piece,
      this.onTileClicked,
      this.canMove = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTileClicked(piece, pos),
      child: Container(
        child: canMove
            ? piece == null
                ? Icon(
                    Icons.fiber_manual_record,
                    color: Colors.blue,
                  )
                : Stack(
                    children: <Widget>[
                      piece,
                      Icon(
                        Icons.fiber_manual_record,
                        color: Colors.red,
                      )
                    ],
                    alignment: Alignment.center,
                  )
            : piece,
        //TODO choose how the tiles are presented
        // color: canMove ? piece == null ? Colors.blue : Colors.red : color,
        color: color,
      ),
    );
  }
}

class Position extends Equatable {
  final int col;
  final int row;

  Position(this.col, this.row) {
    if (col < 0 || col > 7 || row < 0 || row > 7) {
      throw "Out of bounds!";
    }
  }

  @override
  List<Object> get props => [col, row];

  static List<Position> getMove(int currentCol, int currentRow) {
    try {
      return [Position(currentCol, currentRow)];
    } catch (e) {
      return [];
    }
  }

  //TODO return iterator or list
  List<List<Position>> getStraight() {
    List<List<Position>> moves = List<List<Position>>(4);

    //Comments considering white pieces
    //UP
    moves[0] = List.generate(row, (index) => Position(col, row - index - 1));
    //DOWN
    moves[1] =
        List.generate(7 - row, (index) => Position(col, row + index + 1));
    //LEFT
    moves[2] = List.generate(col, (index) => Position(col - index - 1, row));
    //RIGHT
    moves[3] =
        List.generate(7 - col, (index) => Position(col + index + 1, row));

    return moves;
  }

  List<List<Position>> getDiagonal() {
    List<List<Position>> moves = List<List<Position>>(4);

    //Comments considering white pieces
    //TOP LEFT
    moves[0] = List.generate(
        min(col, row), (index) => Position(col - index - 1, row - index - 1));
    //TOP RIGHT
    moves[1] = List.generate(min(7 - col, row),
        (index) => Position(col + index + 1, row - index - 1));
    //BOTTOM LEFT
    moves[2] = List.generate(min(col, 7 - row),
        (index) => Position(col - index - 1, row + index + 1));
    //BOTTOM LEFT
    moves[3] = List.generate(min(7 - col, 7 - row),
        (index) => Position(col + index + 1, row + index + 1));

    return moves;
  }

  //Considering white
  List<List<Position>> getFront() {
    List<List<Position>> moves = List<List<Position>>(3);

    //TOP LEFT
    moves[0] = getMove(col - 1, row - 1);

    //TOP
    moves[1] = getMove(col, row - 1);

    //TOP RIGHT
    moves[2] = getMove(col + 1, row - 1);

    return moves;
  }

  //Considering white
  List<List<Position>> getBack() {
    List<List<Position>> moves = List<List<Position>>(3);

    //TOP LEFT
    moves[0] = getMove(col - 1, row + 1);

    //TOP
    moves[1] = getMove(col, row + 1);

    //TOP RIGHT
    moves[2] = getMove(col + 1, row + 1);

    return moves;
  }
}
