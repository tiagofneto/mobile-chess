import 'package:flutter/material.dart';
import 'package:chess/piece.dart';
import 'package:chess/tile.dart';

typedef void OnPieceKilled(Piece piece);
typedef void OnCheck(String currentPlayer);

//TODO table instead of grid (no scrolling)
//TODO create own gridview
class Board extends StatefulWidget {
  final Color color1;
  final Color color2;
  final Color movingColor;
  final bool reversed;
  final OnPieceKilled onPieceKilled;
  final OnCheck onCheck;
  final OnCheck onCheckmate;
  final VoidCallback onPlayerChanged;
  //TODO add more colors

  Board({
    @required this.color1,
    @required this.color2,
    this.movingColor = Colors.pink,
    this.onPieceKilled,
    this.onCheck,
    this.onCheckmate,
    this.onPlayerChanged,
    this.reversed = false,
  });

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<bool>> canMove;
  List<List<Piece>> pieces;
  //TODO change movignPiece to bool
  Piece movingPiece;
  String currentPlayer;
  bool over;

  @override
  void initState() {
    super.initState();
    _clearMoves();
    _initialBoard();
    currentPlayer = "white";
    over = false;
  }

  void _initialBoard() {
    pieces = List.generate(8, (row) {
      return List.generate(8, (col) {
        String pieceColor;
        row <= 1 ? pieceColor = "black" : pieceColor = "white";
        Piece piece;
        if (row == 0 || row == 7) {
          piece = Piece(_initPieceName(col), pieceColor, Position(col, row));
        } else if (row == 1 || row == 6) {
          piece = Piece("pawn", pieceColor, Position(col, row));
        }
        return piece;
      });
    });
  }

  String _initPieceName(int col) {
    //TODO enum
    switch (col) {
      case 0:
        return "rook";
      case 1:
        return "knight";
      case 2:
        return "bishop";
      case 3:
        return "queen";
      case 4:
        return "king";
      case 5:
        return "bishop";
      case 6:
        return "knight";
      case 7:
        return "rook";
      default:
        return null;
    }
  }

  //TODO optimize
  void _onTileClicked(Position tilePos) {
    if (!over) {
      //MOVING PIECE
      if (movingPiece != null) {
        if (canMove[tilePos.row][tilePos.col]) {
          Piece killedPiece = _movePiece(movingPiece, tilePos);
          if (killedPiece is King) over = true;
          if (killedPiece != null) widget.onPieceKilled(killedPiece);
          _swapPlayers();
          //TODO fix moving own piece not triggering check
          if (!over && _check(currentPlayer)) widget.onCheck(currentPlayer);
        }
        setState(_clearMoves);
      }
      //CHOOSING PIECE TO MOVE
      else {
        setState(_clearMoves);
        Piece piece = pieces[tilePos.row][tilePos.col];
        if (piece != null && piece.color == currentPlayer) {
          movingPiece = piece;
          _validMoves(piece).forEach((pos) {
            setState(() {
              canMove[pos.row][pos.col] = true;
            });
          });
        }
      }
    }
  }

  //TODO remove move placing own king in check
  List<Position> _validMoves(Piece piece) {
    List<Position> validMoves = List<Position>();
    List<List<Position>> moves = piece.listMoves();
    for (List<Position> direction in moves) {
      for (Position pos in direction) {
        Piece currPiece = pieces[pos.row][pos.col];
        if (currPiece != null && currPiece.color == piece.color) break;

        //FIXME lowercase
        if (piece is Pawn) {
          int index = moves.indexOf(direction);
          //Can only move diagonal to eat
          if (currPiece == null) {
            if (index == 0 || index == 2) break;
          } else {
            if (index == 1) break;
          }
        }

        validMoves.add(pos);

        if (currPiece != null) break;
      }
    }

    return validMoves;
  }

  void _clearMoves() {
    movingPiece = null;
    canMove = List.generate(8, (index) => List.generate(8, (index) => false));
  }

  //Moves piece and returns the killed piece, null if no piece was killed
  Piece _movePiece(Piece piece, Position tilePos) {
    if (tilePos == piece.pos) throw "Moving to same position!";

    Piece targetPiece = pieces[tilePos.row][tilePos.col];
    pieces[tilePos.row][tilePos.col] = Piece(
      //FIXME lowercase
      piece.name.toLowerCase(),
      piece.color,
      tilePos,
    );

    pieces[piece.pos.row][piece.pos.col] = null;

    return targetPiece;
  }

  void _swapPlayers() {
    widget.onPlayerChanged();
    if (currentPlayer == "white") {
      currentPlayer = "black";
    } else {
      currentPlayer = "white";
    }
  }

  //Checks if the king with the given color is in check
  bool _check(String color) {
    King king;
    for (List<Piece> row in pieces) {
      for (Piece piece in row) {
        //FIXME lowercase
        if (piece != null && piece is King && piece.color == color) {
          king = piece;
        }
      }
    }

    for (List<Piece> row in pieces) {
      for (Piece piece in row) {
        if (piece != null &&
            piece.color != color &&
            _validMoves(piece).contains(king.pos)) return true;
      }
    }

    return false;
  }

  List<Tile> _generateTiles() {
    return List.generate(64, (index) {
      int row = widget.reversed ? 7 - index ~/ 8 : index ~/ 8;
      int col = widget.reversed ? 7 - index % 8 : index % 8;
      return Tile(
        color: _calculateTileColor(col, row),
        pos: Position(col, row),
        piece: pieces[row][col],
        onTileClicked: _onTileClicked,
        canMove: canMove[row][col],
      );
    });
  }

  Color _calculateTileColor(int col, int row) {
    if (movingPiece != null && movingPiece.pos == Position(col, row))
      return widget.movingColor;

    if ((row.isEven && col.isEven) || (row.isOdd && col.isOdd))
      return widget.color1;
    else
      return widget.color2;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 8,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      //TODO automap
      // children: pieces.expand((piece) => Tile()).toList(),
      children: _generateTiles(),
    );
  }
}
