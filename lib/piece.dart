import 'package:flutter/material.dart';
import 'package:chess/tile.dart';

enum Pieces { Pawn, Knight, Rook, Bishop, Queen, King }
enum PieceColors { black, white }

extension on Pieces {
  String get name => this.toString().split('.').last;
}

extension on PieceColors {
  String get color => this.toString().split('.').last;
}

abstract class Piece extends StatelessWidget {
  final Pieces type;
  final PieceColors color;
  final Position pos;

  factory Piece(Pieces piece, PieceColors color, Position pos) {
    switch (piece.name.toLowerCase()) {
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

  Piece._init(this.type, this.color, this.pos);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/${color.color}${type.name}.png');
  }

  List<List<Position>> listMoves();
}

class Pawn extends Piece {
  Pawn(PieceColors color, Position pos) : super._init(Pieces.Pawn, color, pos);

  @override
  List<List<Position>> listMoves() {
    List<List<Position>> moves =
        color == PieceColors.white ? pos.getFront() : pos.getBack();

    //TOP (first move)
    if ((color == PieceColors.white && pos.row == 6) ||
        (color == PieceColors.black && pos.row == 1))
      moves[1].add(Position(pos.col, pos.row + (color == PieceColors.white ? -2 : 2)));

    return moves;
  }
}

class Rook extends Piece {
  Rook(PieceColors color, Position pos) : super._init(Pieces.Rook, color, pos);

  @override
  List<List<Position>> listMoves() {
    return pos.getStraight();
  }
}

class Knight extends Piece {
  Knight(PieceColors color, Position pos)
      : super._init(Pieces.Knight, color, pos);

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
    //RIGHT BOTTOM
    moves[7] = Position.getMove(pos.col + 2, pos.row + 1);

    return moves;
  }
}

class Bishop extends Piece {
  Bishop(PieceColors color, Position pos)
      : super._init(Pieces.Bishop, color, pos);

  @override
  List<List<Position>> listMoves() {
    return pos.getDiagonal();
  }
}

class Queen extends Piece {
  Queen(PieceColors color, Position pos)
      : super._init(Pieces.Queen, color, pos);

  @override
  List<List<Position>> listMoves() {
    return pos.getStraight() + pos.getDiagonal();
  }
}

class King extends Piece {
  King(PieceColors color, Position pos) : super._init(Pieces.King, color, pos);

  @override
  List<List<Position>> listMoves() {
    List<List<Position>> moves = pos.getFront() + pos.getBack();
    moves.add(Position.getMove(pos.col - 1, pos.row));
    moves.add(Position.getMove(pos.col + 1, pos.row));
    return moves;
  }
}
