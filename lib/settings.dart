import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  Settings() {
    _setBoardColor(0);
  }

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
      body: CarouselSlider(
        items: [
          CarouselItem(
            value: 0,
            color1: Colors.lightGreen,
            color2: Colors.green,
          ),
          CarouselItem(
            value: 1,
            color1: Colors.yellow,
            color2: Colors.lightBlue,
          ),
        ],
        options: CarouselOptions(
          enlargeCenterPage: true,
          onPageChanged: (int page, _) => _setBoardColor(page),
        ),
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  final int value;
  final Color color1;
  final Color color2;

  CarouselItem(
      {@required this.value, @required this.color1, @required this.color2});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          2,
          (index) =>
              index == 0 ? Container(color: color1) : Container(color: color2),
        ));
  }
}
