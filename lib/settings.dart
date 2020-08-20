import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  final int initialPage;

  Settings({this.initialPage});

  _setBoardColor(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('boardColor', page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SettingsTitle("Board color"),
          CarouselSlider(
            items: [
              Image.asset('assets/images/greenBoard.png'),
              Image.asset('assets/images/blueYellowBoard.png'),
            ],
            options: CarouselOptions(
              initialPage: initialPage,
              enlargeCenterPage: true,
              onPageChanged: (int page, _) => _setBoardColor(page),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          SettingsTitle("Player names"),
          PlayerName("player1", "Player 1"),
          PlayerName("player2", "Player 2"),
        ],
      ),
    );
  }
}

class SettingsTitle extends StatelessWidget {
  final String title;

  SettingsTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

class PlayerName extends StatelessWidget {
  final String name;
  final String hint;

  PlayerName(this.name, this.hint);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        onChanged: (value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(name, value);
        },
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}
