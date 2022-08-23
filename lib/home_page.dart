import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_flutter/blank_pixel.dart';
import 'package:snake_flutter/food_pixel.dart';
import 'package:snake_flutter/snake_pixel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum snakeDirection { UP, DOWN, LEFT, RIGHT }

class _MyHomePageState extends State<MyHomePage> {
  // Grid Dimensions
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  // Snake Pos
  List<int> snakePos = [
    0,
    1,
    2,
  ];

  // Food Pos
  int foodPos = 55;

  // Start Game
  void startGame() {
    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        setState(() {
          // Add new Head
          snakePos.add(snakePos.last + 1);
          // Remove tail
          snakePos.removeAt(0);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // HighScore
          Expanded(
            child: Container(),
          ),
          // Game Area
          Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0) {
                    print('move down');
                  }
                  if (details.delta.dy < 0) {
                    print('move up');
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0) {
                    print('move right');
                  }
                  if (details.delta.dx < 0) {
                    print('move left');
                  }
                },
                child: GridView.builder(
                  itemCount: totalNumberOfSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return const SnakePixel();
                    } else if (foodPos == index) {
                      return const FoodPixel();
                    } else {
                      return const BlankPixel();
                    }
                  },
                ),
              )),
          // Play Button
          Expanded(
            child: Center(
              child: MaterialButton(
                onPressed: startGame,
                color: Colors.pink,
                child: const Text('Play'),
              ),
            ),
          ),
          //Branding
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 30),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: const [
          //       Text(
          //         'Created By Yash',
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
