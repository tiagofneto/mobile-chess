import 'package:flutter/material.dart';
import 'package:chess/piece.dart';
import 'package:chess/tile.dart';

typedef void OnPieceKilled(Piece piece);

//TODO table instead of grid (no scrolling)
//TODO create own gridview
class Board extends StatefulWidget {
  final Color color1;
  final Color color2;
  final Color movingColor;
  final bool reversed;
  final OnPieceKilled onPieceKilled;
  final VoidCallback onPlayerChanged;
  //TODO add more colors

  Board(
      {@required this.color1,
      @required this.color2,
      this.movingColor = Colors.pink,
      this.onPieceKilled,
      this.onPlayerChanged,
      this.reversed = false});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<bool>> canMove;
  List<List<Piece>> pieces;
  //TODO change movignPiece to bool
  Piece movingPiece;
  String currentPlayer;

  @override
  void initState() {
    super.initState();
    _clearMoves();
    _initialBoard();
    currentPlayer = "white";
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
  void _onTileClicked(Piece piece, Position tilePos) {
    if (movingPiece != null) {
      if (canMove[tilePos.row][tilePos.col]) {
        //FIXME lowercase
        Piece targetPiece = pieces[tilePos.row][tilePos.col];
        //TODO
        if (targetPiece != null) widget.onPieceKilled(piece);
        pieces[tilePos.row][tilePos.col] = Piece(movingPiece.name.toLowerCase(),
            movingPiece.color, Position(tilePos.col, tilePos.row));

        pieces[movingPiece.pos.row][movingPiece.pos.col] = null;
        _swapPlayers();
      }
      setState(_clearMoves);
    } else {
      setState(_clearMoves);
      if (piece != null && piece.color == currentPlayer) {
        movingPiece = piece;
        //Getting valid move positions
        List<List<Position>> moves = piece.listMoves();
        for (List<Position> direction in moves) {
          for (Position pos in direction) {
            Piece currPiece = pieces[pos.row][pos.col];
            if (currPiece != null && currPiece.color == piece.color) break;

            //FIXME lowercase
            if (piece.name.toLowerCase() == "pawn") {
              int index = moves.indexOf(direction);
              //Can only move diagonal to eat
              if (currPiece == null) {
                if (index == 0 || index == 2) break;
              } else {
                if (index == 1) break;
              }
            }

            setState(() {
              canMove[pos.row][pos.col] = true;
            });

            if (currPiece != null) break;
          }
        }
      }
    }
  }

  void _clearMoves() {
    movingPiece = null;
    canMove = List.generate(8, (index) => List.generate(8, (index) => false));
  }

  void _swapPlayers() {
    widget.onPlayerChanged();
    if (currentPlayer == "white") {
      currentPlayer = "black";
    } else {
      currentPlayer = "white";
    }
  }

  List<Tile> _generateTiles() {}

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 8,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      //TODO automap
      // children: pieces.expand((piece) => Tile()).toList(),
      children: List.generate(64, (index) {
        int row = widget.reversed ? 7 - index ~/ 8 : index ~/ 8;
        int col = widget.reversed ? 7 - index % 8 : index % 8;
        return Tile(
          color: _calculateTileColor(col, row),
          pos: Position(col, row),
          piece: pieces[row][col],
          onTileClicked: _onTileClicked,
          canMove: canMove[row][col],
        );
      }),
    );
  }

  Color _calculateTileColor(int col, int row) {
    if (movingPiece != null) if (movingPiece.pos.col == col &&
        movingPiece.pos.row == row) return widget.movingColor;

    if ((row.isEven && col.isEven) || (row.isOdd && col.isOdd))
      return widget.color1;
    else
      return widget.color2;
  }
}
