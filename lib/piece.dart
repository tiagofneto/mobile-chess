import 'package:flutter/material.dart';
import 'package:chess/tile.dart';

abstract class Piece extends StatelessWidget {
  //FIXME name getter lower case
  final String name;
  final String color;
  final Position pos;

  factory Piece(String name, String color, Position pos) {
    switch (name) {
      case 'pawn':
        return Pawn(color, pos);
      case 'knight':
        return Knight(color, pos);
      case 'rook':
        return Rook(color, pos);
      case 'bishop':
        return Bishop(color, pos);
      case 'queen':
        return Queen(color, pos);
      case 'king':
        return King(color, pos);
      default:
        throw 'Invalid piece name';
    }
  }

  Piece._init(this.name, this.color, this.pos);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/$color$name.png');
  }

  List<List<Position>> listMoves();
}

class Pawn extends Piece {
  Pawn(String color, Position pos) : super._init("Pawn", color, pos);

  @override
  List<List<Position>> listMoves() {
    List<List<Position>> moves =
        color == "white" ? pos.getFront() : pos.getBack();

    //TOP (first move)
    if ((color == "white" && pos.row == 6) ||
        (color == "black" && pos.row == 1))
      moves[1].add(Position(pos.col, pos.row + (color == "white" ? -2 : 2)));

    return moves;
  }
}

class Rook extends Piece {
  Rook(String color, Position pos) : super._init("Rook", color, pos);

  @override
  List<List<Position>> listMoves() {
    return pos.getStraight();
  }
}

class Knight extends Piece {
  Knight(String color, Position pos) : super._init("Knight", color, pos);

  @override
  List<List<Position>> listMoves() {
    List<List<Position>> moves = List<List<Position>>(8);

    //TODO optimize
    //TOP LEFT
    moves[0] = Position.getMove(pos.col - 1, pos.row - 2);
    //TOP RIGHT
    moves[1] = Position.getMove(pos.col + 1, pos.row - 2);
    //BOTTOM LEFT
    moves[2] = Position.getMove(pos.col - 1, pos.row + 2);
    //BOTTOM RIGHT
    moves[3] = Position.getMove(pos.col + 1, pos.row + 2);
    //LEFT TOP
    moves[4] = Position.getMove(pos.col - 2, pos.row - 1);
    //LEFT BOTTOM
    moves[5] = Position.getMove(pos.col - 2, pos.row + 1);
    //RIGHT TOP
    moves[6] = Position.getMove(pos.col + 2, pos.row - 1);
    //TOP LEFT
    moves[7] = Position.getMove(pos.col - 2, pos.row + 1);

    return moves;
  }
}

class Bishop extends Piece {
  Bishop(String color, Position pos) : super._init("Bishop", color, pos);

  @override
  List<List<Position>> listMoves() {
    return pos.getDiagonal();
  }
}

class Queen extends Piece {
  Queen(String color, Position pos) : super._init("Queen", color, pos);

  @override
  List<List<Position>> listMoves() {
    return pos.getStraight() + pos.getDiagonal();
  }
}

class King extends Piece {
  King(String color, Position pos) : super._init("King", color, pos);

  @override
  List<List<Position>> listMoves() {
    List<List<Position>> moves = pos.getFront() + pos.getBack();
    moves.add(Position.getMove(pos.col - 1, pos.row));
    moves.add(Position.getMove(pos.col + 1, pos.row));
    return moves;
  }
}
