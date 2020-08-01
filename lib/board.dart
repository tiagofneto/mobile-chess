import 'package:flutter/material.dart';
import 'package:chess/piece.dart';
import 'package:chess/tile.dart';

class Board extends StatefulWidget {
  List<List<Piece>> pieces;

  Board() {
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

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<Tile> tiles;

  @override
  void initState() {
    //BUILDING TILES
    tiles = List<Tile>();
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        tiles.add(Tile(
          _calculateTileColor(col, row),
          widget.pieces[row][col],
          onTileClicked: (Piece piece) {
            print(piece.color + " " + piece.image);
          },
        ));
      }
    }
  }

  Color _calculateTileColor(int col, int row) {
    if ((row.isEven && col.isEven) || (row.isOdd && col.isOdd))
      return Colors.lightGreen[100];
    else
      return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chess"),
        ),
        body: GridView.count(
          crossAxisCount: 8,
          // children: tiles.expand((element) => element).toList(),
          children: tiles,
        ));
  }
}
