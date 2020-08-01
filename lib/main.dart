import 'package:flutter/material.dart';
import 'package:chess/piece.dart';
import 'package:chess/tile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Board(),
    );
  }
}

//TODO organize methods
class Board extends StatefulWidget {

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<List<Widget>> tiles;

  @override
  void initState() {
    _initialBoard();
  }

  void _initialBoard() {
    tiles = List.generate(8, (row) {
      return List.generate(8, (col) {
        String pieceColor;
        row <= 1 ? pieceColor = "black" : pieceColor = "white";
        Piece piece;
        if (row == 0 || row == 7) {
          piece = _fabricatePiece(col, row, pieceColor);
        } else if (row == 1 || row == 6) {
          piece = Pawn(pieceColor, Position(col, row));
        }
        return Tile(_calculateTileColor(col, row), piece);
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
          children: tiles.expand((element) => element).toList(),
        ));
  }
}
