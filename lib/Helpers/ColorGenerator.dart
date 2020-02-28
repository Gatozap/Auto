import 'package:flutter/material.dart';

class ColorGenerator {

// Listen to keyup
  Color getRandomColor(String s) {
    var value = s,
        result = List();

    try {
      var v = value.split('');

      // Filter non hex values
      for (var i = 0; i < value.length; i++) {
        var val = value[i];

    result.add(val);
    }
    }catch(err){
      print('erro');
    }

    // Multiple of 3
    if (result.length % 3 == 0) {
    result.add((3 - result.length % 3) + 1+0);
    }

    // Multiple of 6
    if (result.length % 6 == 0) {
      result.add((6 - result.length % 6) + 1+0);
    }

    // Split in 3 groups with equal size
    //var regexp = new RegExp("([A-Z0-9]${result.length / 3},i");

    // Remove first 0 (if there is one at first postion of every group
    if (result[1].length > 2) {
   /* if (result[1].charAt(0) == result[3].charAt(0) == result[5].charAt(0) == 0) {
    result[1] = result[1].substr(1);
    result[3] = result[3].substr(1);
    result[5] = result[5].substr(1);
    }*/
    }

    // Truncate (first 2 chars stay, the rest gets deleted)
    result[1] = result[1].slice(0, 2);
    result[3] = result[3].slice(0, 2);
    result[5] = result[5].slice(0, 2);

    // Add element if color consists of just 1 char per color
    if (result[1].length == 1) {
    result[1] += result[1];
    result[3] += result[3];
    result[5] += result[5];
    }

    // Output

    // Convert to RGB
    var r = int.parse(result[1]);
    var g = int.parse(result[3]);
    var b = int.parse(result[5]);
    return Color.fromARGB(255, r, g, b);
    }
  }