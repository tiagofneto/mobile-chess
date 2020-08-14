import 'package:flutter/material.dart';
import 'package:chess/game.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_state.dart';

typedef void OnPressed();

class HomeBut extends StatelessWidget {
  final String text;
  final OnPressed onPressed;

  HomeBut({@required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              onPressed: onPressed,
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.lightBlueAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        "Choose a color combination",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        SettingsOption(text: "Pattern 1", value: 0),
        Divider(),
        SettingsOption(text: "Pattern 2", value: 1),
      ],
    );
  }
}

//TODO show preview of colors
//TODO carrousel slider for boards
class SettingsOption extends StatelessWidget {
  final int value;
  final String text;

  SettingsOption({@required this.value, @required this.text});

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      child: Text(text),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('boardColor', value);
        Navigator.pop(context);
      },
    );
  }
}

class Home extends StatelessWidget {
  Future<Color> _getColorPreferences(bool primary) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int colorPreference = prefs.getInt('boardColor') ?? 0;

    if (primary) {
      switch (colorPreference) {
        case 0:
          return Colors.lightGreen[100];
        case 1:
          return Colors.yellow;
      }
    } else {
      switch (colorPreference) {
        case 0:
          return Colors.green;
        case 1:
          return Colors.lightBlue;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chess"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HomeBut(
            text: "Play",
            onPressed: () async {
              Color color1 = await _getColorPreferences(true);
              Color color2 = await _getColorPreferences(false);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Game(
                          color1: color1,
                          color2: color2,
                        )),
              );
            },
          ),
          HomeBut(
            text: "Settings",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => Settings(),
              );
            },
          )
        ],
      ),
    );
  }
}
