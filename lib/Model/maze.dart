import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Cell {
  bool top;
  bool right;
  bool bottom;
  bool left;
  Color color = Colors.white;

  Cell({
    this.top = false,
    this.right = false,
    this.bottom = false,
    this.left = false,
  });
}

class Maze {
  final int width;
  final int height;
  late List<List<Cell>> cells;

  Maze(this.width, this.height) {
    // Initialize the maze with all walls
    cells = List.generate(
      height,
      (_) => List.generate(
        width,
        (_) => Cell(),
      ),
    );
  }

  // Utility function to get neighboring cells
  List<Map<String, int>> getNeighbors(int x, int y) {
    final List<Map<String, int>> neighbors = [];

    if (y > 0) neighbors.add({'x': x, 'y': y - 1, 'dir': 0}); // Top
    if (x < width - 1) neighbors.add({'x': x + 1, 'y': y, 'dir': 1}); // Right
    if (y < height - 1) neighbors.add({'x': x, 'y': y + 1, 'dir': 2}); // Bottom
    if (x > 0) neighbors.add({'x': x - 1, 'y': y, 'dir': 3}); // Left

    return neighbors;
  }

  static void generateMaze(Maze maze, int x, int y) {
    final random = Random();
    final List<Map<String, int>> neighbors = maze.getNeighbors(x, y);

    while (neighbors.isNotEmpty) {
      // Randomly choose a neighboring cell
      final neighborIndex = random.nextInt(neighbors.length);
      final neighbor = neighbors[neighborIndex];

      int nx = neighbor['x']!;
      int ny = neighbor['y']!;
      int direction = neighbor['dir']!;

      // If the neighboring cell has no connections (unvisited), create a passage
      if (!maze.cells[ny][nx].top && !maze.cells[ny][nx].right && !maze.cells[ny][nx].bottom && !maze.cells[ny][nx].left) {
        switch (direction) {
          case 0:
            maze.cells[y][x].top = true;
            maze.cells[ny][nx].bottom = true;
            break;
          case 1:
            maze.cells[y][x].right = true;
            maze.cells[ny][nx].left = true;
            break;
          case 2:
            maze.cells[y][x].bottom = true;
            maze.cells[ny][nx].top = true;
            break;
          case 3:
            maze.cells[y][x].left = true;
            maze.cells[ny][nx].right = true;
            break;
        }

        // Recursive call to generate the maze
        generateMaze(maze, nx, ny);
      }

      // Remove the chosen neighbor from the list to avoid revisiting
      neighbors.removeAt(neighborIndex);
    }
  }
}

// ------------------------------------------------------------------------------------

