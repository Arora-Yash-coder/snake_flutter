import 'dart:async';
import 'dart:math';

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

  // Game Score
  int currentScore = 0;

  // Game State
  bool isGameRunning = false;

  // Snake Pos
  List<int> snakePos = [
    0,
    1,
    2,
  ];

  // Snake Direction
  var currentDirection = snakeDirection.RIGHT;

  // Food Pos
  int foodPos = 55;

  // Start Game
  void startGame() {
    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        setState(() {
          isGameRunning = true;
          moveSnake();
          if (gameOver()) {
            timer.cancel();
            isGameRunning = false;
            // Display Score
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Game Over'),
                  content: Text('Your Score is $currentScore'),
                  actions: [
                    MaterialButton(
                      color: Colors.pink,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          resetSnake();
                        });
                      },
                      child: const Text('New Game'),
                    ),
                  ],
                );
              },
            );
          }
        });
      },
    );
  }

  void resetSnake() {
    snakePos = [
      0,
      1,
      2,
    ];
    currentScore = 0;
    currentDirection = snakeDirection.RIGHT;
  }

  void moveSnake() {
    switch (currentDirection) {
      case snakeDirection.RIGHT:
        {
          // Right Wall Detection
          if (snakePos.last % rowSize == 9) {
            // Add new Head
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            // Add new Head
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snakeDirection.LEFT:
        {
          // Left Wall Detection
          if (snakePos.last % rowSize == 0) {
            // Add new Head
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            // Add new Head
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case snakeDirection.UP:
        {
          // Top Wall Detection
          if (snakePos.last < rowSize) {
            // Add new Head
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            // Add new Head
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snakeDirection.DOWN:
        {
          // Bottom Wall Detection
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            // Add new Head
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            // Add new Head
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }

    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      // Remove tail
      snakePos.removeAt(0);
    }
  }

  void eatFood() {
    currentScore++;
    // Making sure food not spawns on snakes body
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  bool gameOver() {
    List<int> snakeBody = snakePos.sublist(0, snakePos.length - 1);
    if (snakeBody.contains(snakePos.last)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Column(
          children: [
            // HighScore
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Current Score',
                    style: TextStyle(fontSize: 28),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    currentScore.toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            // Game Area
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > 0 &&
                          currentDirection != snakeDirection.UP) {
                        currentDirection = snakeDirection.DOWN;
                      }
                      if (details.delta.dy < 0 &&
                          currentDirection != snakeDirection.DOWN) {
                        currentDirection = snakeDirection.UP;
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 0 &&
                          currentDirection != snakeDirection.LEFT) {
                        currentDirection = snakeDirection.RIGHT;
                      }
                      if (details.delta.dx < 0 &&
                          currentDirection != snakeDirection.RIGHT) {
                        currentDirection = snakeDirection.LEFT;
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
                  ),
                )),
            // Play Button
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: MaterialButton(
                      onPressed: isGameRunning ? () {} : startGame,
                      color: isGameRunning ? Colors.grey : Colors.pink,
                      child: const Text('Play'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Created By Yash',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Branding
          ],
        ),
      ),
    );
  }
}
