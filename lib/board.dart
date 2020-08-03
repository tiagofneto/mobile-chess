import 'package:flutter/material.dart';
import 'package:chess/piece.dart';
import 'package:chess/tile.dart';

class Board extends StatefulWidget {
  final Color color1;
  final Color color2;

  Board(this.color1, this.color2);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<bool>> canMove;
  List<List<Piece>> pieces;
  Piece movingPiece;

  @override
  void initState() {
    super.initState();
    canMove = List.generate(8, (index) => List.generate(8, (index) => false));
    movingPiece = null;
    _initialBoard();
  }

  void _initialBoard() {
    pieces = List.generate(8, (row) {
      return List.generate(8, (col) {
        String pieceColor;
        row <= 1 ? pieceColor = "black" : pieceColor = "white";
        Piece piece;
        if (row == 0 || row == 7) {
          piece = _fabricatePiece(col, row, pieceColor);
        } else if (row == 1 || row == 6) {
          piece = Pawn(pieceColor, Position(col, row));
        }
        return piece;
      });
    });
  }

  Piece _fabricatePiece(int col, int row, String pieceColor) {
    Position pos = Position(col, row);
    switch (col) {
      case 0:
        return Rook(pieceColor, pos);
      case 1:
        return Knight(pieceColor, pos);
      case 2:
        return Bishop(pieceColor, pos);
      case 3:
        return Queen(pieceColor, pos);
      case 4:
        return King(pieceColor, pos);
      case 5:
        return Bishop(pieceColor, pos);
      case 6:
        return Knight(pieceColor, pos);
      case 7:
        return Rook(pieceColor, pos);
      default:
        return null;
    }
  }

  void _onTileClicked(Piece piece, Position tilePos) {
    if (movingPiece == null) {
      setState(() {
        canMove =
            List.generate(8, (index) => List.generate(8, (index) => false));
      });
      if (piece != null) {
        movingPiece = piece;
        //Getting valid move positions
        for (List<Position> direction in piece.listMoves()) {
          print("SWITCH");
          for (Position pos in direction) {
            print(
                "Row: " + pos.row.toString() + " | Col: " + pos.col.toString());
            // setState(() {
            //   if (pieces[pos.row][pos.col].color == )
            //   canMove[pos.row][pos.col] = true;
            // });
            Piece currPiece = pieces[pos.row][pos.col];
            if (currPiece != null && currPiece.color == piece.color) break;

            setState(() {
              canMove[pos.row][pos.col] = true;
            });

            if (currPiece != null) break;
          }
        }
      }
    } else {
      //TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chess"),
        ),
        body: GridView.count(
          crossAxisCount: 8,
          //TODO automap
          // children: pieces.expand((piece) => Tile()).toList(),
          children: List.generate(64, (index) {
            int row = index ~/ 8;
            int col = index % 8;
            return Tile(
              color: _calculateTileColor(col, row),
              pos: Position(col, row),
              piece: pieces[row][col],
              onTileClicked: _onTileClicked,
              canMove: canMove[row][col],
            );
          }),
        ));
  }

  Color _calculateTileColor(int col, int row) {
    if ((row.isEven && col.isEven) || (row.isOdd && col.isOdd))
      return widget.color1;
    else
      return widget.color2;
  }
}
