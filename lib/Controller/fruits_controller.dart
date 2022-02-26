import 'package:flutter/material.dart';

enum Fruits { apple, mango, banana, orange }

extension FruitsExtension on Fruits {
  String getUrl() {
    switch (this) {
      case Fruits.apple:
        return 'https://www.transparentpng.com/thumb/apple-fruit/iVyuBZ-apple-fruit-clipart-hd.png';
      case Fruits.mango:
        return 'https://www.transparentpng.com/thumb/mango/jUo5vz-mango-free-cut-out.png';
      case Fruits.banana:
        return 'https://www.transparentpng.com/thumb/banana/8azLEk-banana-clipart-png-file.png';
      case Fruits.orange:
        return 'http://clipart-library.com/img/990750.png';
    }
  }

  List<Color> getColors() {
    switch (this) {
      case Fruits.apple:
        return [
          Colors.orange,
          Colors.red,
          Colors.red,
          Colors.red,
        ];
      case Fruits.mango:
        return [
          Colors.green,
          Colors.amber,
          Colors.amber,
          Colors.orange,
        ];
      case Fruits.banana:
        return [
          Colors.orange,
          Colors.amber,
          Colors.amber,
          Colors.amber,
        ];
      case Fruits.orange:
        return [
          Colors.orange,
          Colors.orange,
          Colors.orange,
          Colors.amber,
        ];
    }
  }
}

Fruits getFruit(String str) {
  switch (str.toLowerCase()) {
    case 'apple':
      return Fruits.apple;
    case 'mango':
      return Fruits.mango;
    case 'bananna':
      return Fruits.banana;
    case 'orange':
      return Fruits.orange;
  }
  return Fruits.apple;
}
