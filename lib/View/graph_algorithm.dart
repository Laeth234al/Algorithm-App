import 'dart:collection';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'dart:math' as m;

import '../Model/Maze.dart';

class GraphAlgorithm extends StatefulWidget {
  const GraphAlgorithm({super.key});

  @override
  State<GraphAlgorithm> createState() => _GraphAlgorithmState();
}

class _GraphAlgorithmState extends State<GraphAlgorithm> {
  int h = 24;
  final w = 24;
  List<List<bool>> g = List.generate(24, (index) => List.generate(24, (index) => m.Random().nextBool()));
  Maze maze = Maze(24, 24); // Create a 24X24 maze
  bool run = false;
  List<bool> runs = List.filled(7, false);
  late double valueOfSlider;
  @override
  void initState() {
    super.initState();
    Maze.generateMaze(maze, 0, 0);
    valueOfSlider = 3.0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Graph Algorithm',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: () {
              // g = List.generate(h, (index) => List.generate(w, (index) => m.Random().nextBool()));
              maze = Maze(24, 24);
              Maze.generateMaze(maze, 0, 0);
              setState(() {});
            },
            icon: const Icon(
              Icons.replay,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: size.width - 16.0,
              height: size.width - 16.0,
              child: Container(
                color: Colors.black12,
                child: MazeWidget(
                  maze: maze,
                  path: const [],
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // BFS
                  GraphAlgorithmButton(
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[0] = true;
                        for (var cells in maze.cells) {
                          for (var cell in cells) {
                            cell.color = Colors.white;
                          }
                        }
                      });
                      // BFS ALgorithms

                      List<Map<String, int>> reconstructPath(Map<String, Map<String, int>> parent, int startX, int startY, int endX, int endY) {
                        List<Map<String, int>> path = [];
                        String current = '$endX,$endY';
                        while (current.isNotEmpty && run) {
                          final parts = current.split(',');
                          final x = int.parse(parts[0]);
                          final y = int.parse(parts[1]);
                          path.add({'x': x, 'y': y});
                          if (x == startX && y == startY) {
                            break; // Reached the start
                          }
                          current = '${parent[current]!['x']},${parent[current]!['y']}';
                        }
                        path = path.reversed.toList(); // Reverse to get the correct order
                        return path;
                      }

                      Future<List<Map<String, int>>> findPath(Maze maze, int startX, int startY, int endX, int endY) async {
                        Queue<Map<String, int>> queue = Queue(); // BFS queue
                        Map<String, Map<String, int>> parent = {}; // Track parent nodes for path reconstruction
                        queue.add({'x': startX, 'y': startY});
                        parent['$startX,$startY'] = {}; // Mark the start as visited
                        while (queue.isNotEmpty && run) {
                          final current = queue.removeFirst();
                          final x = current['x']!;
                          final y = current['y']!;
                          maze.cells[y][x].color = Colors.red;
                          setState(() {});
                          // If we reach the endpoint, reconstruct the path
                          if (x == endX && y == endY) {
                            return reconstructPath(parent, startX, startY, endX, endY);
                          }
                          // Get all neighbors from the current cell
                          final neighbors = maze.getNeighbors(x, y);
                          for (final neighbor in neighbors) {
                            if (!run) break;
                            final nx = neighbor['x']!;
                            final ny = neighbor['y']!;
                            final direction = neighbor['dir']!;
                            // Check if there's a passage to the neighbor
                            if ((direction == 0 && maze.cells[y][x].top) ||
                                (direction == 1 && maze.cells[y][x].right) ||
                                (direction == 2 && maze.cells[y][x].bottom) ||
                                (direction == 3 && maze.cells[y][x].left)) {
                              final key = '$nx,$ny';
                              if (!parent.containsKey(key)) {
                                // If not visited
                                parent[key] = {'x': x, 'y': y}; // Set parent for path reconstruction
                                queue.add({'x': nx, 'y': ny}); // Add to the queue for exploration
                                setState(() {
                                  maze.cells[ny][nx].color = Colors.blue;
                                });
                              }
                            }
                          }
                          await Future.delayed(Duration(milliseconds: ((100 / valueOfSlider) * 3).toInt()));
                          maze.cells[y][x].color = Colors.yellow;
                          setState(() {});
                        }
                        return []; // Return an empty list if no path is found
                      }

                      final path = await findPath(maze, 0, 0, 23, 23); // تشغيل BFS من البداية إلى النهاية
                      print(path);
                      for (int i = 0; i < path.length && run; i++) {
                        maze.cells[path[i]['y']!][path[i]['x']!].color = Colors.green;
                        await Future.delayed(Duration(milliseconds: ((20 / valueOfSlider) * 3).toInt()));
                        setState(() {});
                      }

                      setState(() {
                        run = false;
                        runs[0] = false;
                      });
                    },
                    run: runs[0],
                    title: 'BFS',
                  ),
                  // DFS
                  GraphAlgorithmButton(
                      onTap: () async {
                        setState(() {
                          run = true;
                          runs[1] = true;
                          for (var cells in maze.cells) {
                            for (var cell in cells) {
                              cell.color = Colors.white;
                            }
                          }
                        });
                        // BFS ALgorithm

                        List<Map<String, int>> reconstructPath(Map<String, Map<String, int>> parent, int startX, int startY, int endX, int endY) {
                          List<Map<String, int>> path = [];
                          String current = '$endX,$endY';
                          while (current.isNotEmpty && run) {
                            final parts = current.split(',');
                            final x = int.parse(parts[0]);
                            final y = int.parse(parts[1]);
                            path.add({'x': x, 'y': y});
                            if (x == startX && y == startY) {
                              break; // Reached the start
                            }
                            current = '${parent[current]!['x']},${parent[current]!['y']}';
                          }
                          path = path.reversed.toList(); // Reverse to get the correct order
                          return path;
                        }

                        Future<List<Map<String, int>>> findPath(Maze maze, int startX, int startY, int endX, int endY) async {
                          Stack<Map<String, int>> stack = Stack(); // BFS queue
                          Map<String, Map<String, int>> parent = {}; // Track parent nodes for path reconstruction
                          stack.push({'x': startX, 'y': startY});
                          parent['$startX,$startY'] = {}; // Mark the start as visited
                          while (stack.isNotEmpty && run) {
                            final current = stack.pop();
                            final x = current['x']!;
                            final y = current['y']!;
                            maze.cells[y][x].color = Colors.red;
                            setState(() {});
                            // If we reach the endpoint, reconstruct the path
                            if (x == endX && y == endY) {
                              return reconstructPath(parent, startX, startY, endX, endY);
                            }
                            // Get all neighbors from the current cell
                            final neighbors = maze.getNeighbors(x, y);
                            for (final neighbor in neighbors) {
                              if (!run) break;
                              final nx = neighbor['x']!;
                              final ny = neighbor['y']!;
                              final direction = neighbor['dir']!;
                              // Check if there's a passage to the neighbor
                              if ((direction == 0 && maze.cells[y][x].top) ||
                                  (direction == 1 && maze.cells[y][x].right) ||
                                  (direction == 2 && maze.cells[y][x].bottom) ||
                                  (direction == 3 && maze.cells[y][x].left)) {
                                final key = '$nx,$ny';
                                if (!parent.containsKey(key)) {
                                  // If not visited
                                  parent[key] = {'x': x, 'y': y}; // Set parent for path reconstruction
                                  stack.push({'x': nx, 'y': ny}); // Add to the stack for exploration
                                  setState(() {
                                    maze.cells[ny][nx].color = Colors.blue;
                                  });
                                }
                              }
                            }
                            await Future.delayed(Duration(milliseconds: ((100 / valueOfSlider) * 3).toInt()));
                            maze.cells[y][x].color = Colors.yellow;
                            setState(() {});
                          }
                          return []; // Return an empty list if no path is found
                        }

                        final path = await findPath(maze, 0, 0, 23, 23); // تشغيل DFS من البداية إلى النهاية
                        print(path);
                        for (int i = 0; i < path.length && run; i++) {
                          maze.cells[path[i]['y']!][path[i]['x']!].color = Colors.green;
                          await Future.delayed(Duration(milliseconds: ((20 / valueOfSlider) * 3).toInt()));
                          setState(() {});
                        }

                        setState(() {
                          run = false;
                          runs[1] = false;
                        });
                      },
                      run: runs[1],
                      title: 'DFS'),
                  // A*
                  GraphAlgorithmButton(
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[2] = true;
                        for (var cells in maze.cells) {
                          for (var cell in cells) {
                            cell.color = Colors.white;
                          }
                        }
                      });
                      //A* Algorithm
                      int heuristic(int x1, int y1, int x2, int y2) {
                        return (x1 - x2).abs() + (y1 - y2).abs(); // Manhattan distance
                      }

                      Future<List<Map<String, int>>> reconstructPath(Map<String, Map<String, int>> parent, int startX, int startY, int endX, int endY) async {
                        List<Map<String, int>> path = [];
                        String current = '$endX,$endY';

                        while (current.isNotEmpty && run) {
                          final parts = current.split(',');
                          final x = int.parse(parts[0]);
                          final y = int.parse(parts[1]);
                          await Future.delayed(Duration(milliseconds: ((50 / valueOfSlider) * 3).toInt()));
                          setState(() {
                            maze.cells[y][x].color = Colors.green;
                          });

                          path.add({'x': x, 'y': y});

                          if (x == startX && y == startY) {
                            break; // Reached the start
                          }

                          current = '${parent[current]!['x']},${parent[current]!['y']}';
                        }

                        path = path.reversed.toList(); // Reverse to get the correct order
                        return path;
                      }

                      Future<List<Map<String, int>>> findPath(Maze maze, int startX, int startY, int endX, int endY) async {
                        PriorityQueue<Map<String, dynamic>> queue = PriorityQueue(
                          (a, b) => a['f'] - b['f'], // Priority queue sorted by 'f' value
                        );
                        Map<String, int> gScore = {}; // Cost from start to a node
                        Map<String, int> fScore = {}; // Estimated total cost
                        Map<String, Map<String, int>> parent = {}; // Track parent nodes

                        String startKey = '$startX,$startY';
                        // String endKey = '$endX,$endY';

                        gScore[startKey] = 0; // Cost to reach start
                        fScore[startKey] = heuristic(startX, startY, endX, endY); // Estimated total cost

                        queue.add({'x': startX, 'y': startY, 'f': fScore[startKey]});

                        while (queue.isNotEmpty && run) {
                          final current = queue.removeFirst();
                          final x = current['x']!;
                          final y = current['y']!;
                          setState(() {
                            maze.cells[y][x].color = Colors.red;
                          });

                          // If we reach the endpoint, reconstruct the path
                          if (x == endX && y == endY) {
                            return reconstructPath(parent, startX, startY, endX, endY);
                          }

                          // Get neighbors
                          final neighbors = maze.getNeighbors(x, y);

                          for (final neighbor in neighbors) {
                            if (!run) break;
                            final nx = neighbor['x']!;
                            final ny = neighbor['y']!;
                            final direction = neighbor['dir']!;

                            // Check if there's a passage to the neighbor
                            if ((direction == 0 && maze.cells[y][x].top) ||
                                (direction == 1 && maze.cells[y][x].right) ||
                                (direction == 2 && maze.cells[y][x].bottom) ||
                                (direction == 3 && maze.cells[y][x].left)) {
                              final key = '$nx,$ny';

                              int tentativeGScore = gScore['$x,$y']! + 1; // Cost to reach this neighbor

                              if (!gScore.containsKey(key) || tentativeGScore < gScore[key]!) {
                                parent[key] = {'x': x, 'y': y}; // Set parent for path reconstruction

                                gScore[key] = tentativeGScore;
                                fScore[key] = tentativeGScore + heuristic(nx, ny, endX, endY); // Total cost

                                queue.add({'x': nx, 'y': ny, 'f': fScore[key]});
                                setState(() {
                                  maze.cells[ny][nx].color = Colors.blue;
                                });
                              }
                            }
                          }

                          await Future.delayed(Duration(milliseconds: ((100 / valueOfSlider) * 3).toInt())); // Delay for visualization
                          setState(() {
                            maze.cells[y][x].color = Colors.yellow;
                          });
                        }

                        return []; // If no path is found
                      }

                      await findPath(maze, 0, 0, 23, 23);

                      setState(() {
                        run = false;
                        runs[2] = false;
                      });
                    },
                    run: runs[2],
                    title: 'A*',
                  ),
                  // UCS
                  GraphAlgorithmButton(
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[3] = true;
                        for (var cells in maze.cells) {
                          for (var cell in cells) {
                            cell.color = Colors.white;
                          }
                        }
                      });
                      //UCS Algorithm
                      // Function to reconstruct the path from parent map
                      Future<List<Map<String, int>>> reconstructPath(Map<String, Map<String, int>> parent, int startX, int startY, int endX, endY) async {
                        List<Map<String, int>> path = [];
                        String current = '$endX,$endY';

                        while (current.isNotEmpty && run) {
                          final parts = current.split(',');
                          final x = int.parse(parts[0]);
                          final y = int.parse(parts[1]);
                          maze.cells[y][x].color = Colors.green;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: ((50 / valueOfSlider) * 3).toInt()));
                          path.add({'x': x, 'y': y});

                          if (x == startX && y == startY) {
                            break; // Reached the start
                          }

                          current = '${parent[current]!['x']},${parent[current]!['y']}';
                        }

                        path = path.reversed.toList(); // Reverse to get the correct order
                        return path;
                      }

                      Future<List<Map<String, int>>> findPath(Maze maze, int startX, int startY, int endX, int endY) async {
                        PriorityQueue<Map<String, dynamic>> queue = PriorityQueue(
                          (a, b) => a['cost'] - b['cost'], // Priority queue sorted by cost
                        );
                        Map<String, int> cost = {}; // Cumulative cost from the start
                        Map<String, Map<String, int>> parent = {}; // Track parent nodes for path reconstruction

                        String startKey = '$startX,$startY';
                        // String endKey = '$endX,$endY';

                        cost[startKey] = 0; // Starting cost
                        queue.add({'x': startX, 'y': startY, 'cost': cost[startKey]});

                        while (queue.isNotEmpty && run) {
                          final current = queue.removeFirst();
                          final x = current['x']!;
                          final y = current['y']!;
                          setState(() {
                            maze.cells[y][x].color = Colors.red;
                          });

                          // If we reach the endpoint, reconstruct the path
                          if (x == endX && y == endY) {
                            return reconstructPath(parent, startX, startY, endX, endY);
                          }

                          // Get neighbors of the current cell
                          final neighbors = maze.getNeighbors(x, y);

                          for (final neighbor in neighbors) {
                            if (!run) break;
                            final nx = neighbor['x']!;
                            final ny = neighbor['y']!;
                            final direction = neighbor['dir']!;

                            // Check if there's a passage to the neighbor
                            if ((direction == 0 && maze.cells[y][x].top) ||
                                (direction == 1 && maze.cells[y][x].right) ||
                                (direction == 2 && maze.cells[y][x].bottom) ||
                                (direction == 3 && maze.cells[y][x].left)) {
                              final key = '$nx,$ny';

                              int tentativeCost = cost['$x,$y']! + 1; // Uniform cost for each step

                              if (!cost.containsKey(key) || tentativeCost < cost[key]!) {
                                parent[key] = {'x': x, 'y': y}; // Set parent for path reconstruction

                                cost[key] = tentativeCost;
                                queue.add({'x': nx, 'y': ny, 'cost': cost[key]});
                                setState(() {
                                  maze.cells[ny][nx].color = Colors.blue;
                                });
                              }
                            }
                          }

                          await Future.delayed(Duration(milliseconds: ((100 / valueOfSlider) * 3).toInt())); // Delay for visualization
                          setState(() {
                            maze.cells[y][x].color = Colors.yellow;
                          });
                        }

                        return []; // If no path is found
                      }

                      await findPath(maze, 0, 0, 23, 23);

                      setState(() {
                        run = false;
                        runs[3] = false;
                      });
                    },
                    run: runs[3],
                    title: 'UCS',
                  ),
                  // Greedy
                  GraphAlgorithmButton(
                    // Not Working in Color red yellow green blue
                    onTap: () async {
                      setState(() {
                        run = true;
                        runs[4] = true;
                        for (var cells in maze.cells) {
                          for (var cell in cells) {
                            cell.color = Colors.white;
                          }
                        }
                      });
                      int manhattanDistance(int x1, int y1, int x2, int y2) {
                        return (x1 - x2).abs() + (y1 - y2).abs();
                      }

                      Future<List<Map<String, int>>> findPath(Maze maze, int startX, int startY, int endX, int endY) async {
                        List<Map<String, int>> path = []; // To store the path
                        Set<String> visited = {}; // To track visited cells

                        int currentX = startX;
                        int currentY = startY;
                        visited.add('$currentX,$currentY'); // Mark start as visited
                        path.add({'x': currentX, 'y': currentY});

                        while ((currentX != endX || currentY != endY) && run) {
                          // Get neighbors and choose the one that minimizes the distance to the goal
                          setState(() {
                            maze.cells[currentY][currentX].color = Colors.red;
                          });
                          await Future.delayed(Duration(milliseconds: ((100 / valueOfSlider) * 3).toInt()));
                          final neighbors = maze.getNeighbors(currentX, currentY);

                          neighbors.sort((a, b) {
                            int distA = manhattanDistance(a['x']!, a['y']!, endX, endY);
                            int distB = manhattanDistance(b['x']!, b['y']!, endX, endY);
                            return distA - distB; // Sort by closest distance to the goal
                          });

                          bool found = false;
                          for (final neighbor in neighbors) {
                            if (!run) break;
                            final nx = neighbor['x']!;
                            final ny = neighbor['y']!;
                            final direction = neighbor['dir']!;

                            // Check if there's a passage and the neighbor is not visited
                            if ((direction == 0 && maze.cells[currentY][currentX].top) ||
                                (direction == 1 && maze.cells[currentY][currentX].right) ||
                                (direction == 2 && maze.cells[currentY][currentX].bottom) ||
                                (direction == 3 && maze.cells[currentY][currentX].left)) {
                              final key = '$nx,$ny';

                              if (!visited.contains(key)) {
                                setState(() {
                                  maze.cells[currentY][currentX].color = Colors.yellow;
                                });
                                // Ensure it's not visited
                                visited.add(key);
                                path.add({'x': nx, 'y': ny});
                                currentX = nx;
                                currentY = ny;
                                found = true;

                                break; // Move to the next cell
                              }
                            }
                          }

                          if (!found) {
                            // If no new direction, backtrack (should not happen in a well-constructed maze)
                            path.removeLast(); // Remove the last step
                            if (path.isEmpty) {
                              break; // No path found
                            }
                            setState(() {
                              maze.cells[currentY][currentX].color = Colors.yellow;
                            });
                            final lastStep = path.last;
                            currentX = lastStep['x']!;
                            currentY = lastStep['y']!;
                            setState(() {
                              maze.cells[currentY][currentX].color = Colors.red;
                            });
                          }
                        }

                        for (var cell in path) {
                          if (!run) break;
                          int x = cell['x']!;
                          int y = cell['y']!;
                          setState(() {
                            maze.cells[y][x].color = Colors.green;
                          });
                          await Future.delayed(Duration(milliseconds: ((50 / valueOfSlider) * 3).toInt()));
                        }

                        return path; // Return the path
                      }

                      await findPath(maze, 0, 0, 23, 23);

                      setState(() {
                        run = false;
                        runs[4] = false;
                      });
                    },
                    run: runs[4],
                    title: 'Greedy',
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            SizedBox(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Clear Maze Sol
                  SizedBox(
                    height: 40.0,
                    child: MaterialButton(
                      color: Colors.green,
                      onPressed: () {
                        for (var cells in maze.cells) {
                          for (var cell in cells) {
                            cell.color = Colors.white;
                          }
                        }
                        setState(() {});
                      },
                      child: const Text('Clear Maze Solution'),
                    ),
                  ),
                  // Stop
                  SizedBox(
                    height: 40.0,
                    child: MaterialButton(
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          run = false;
                        });
                      },
                      child: const Text('Stop'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
              child: Slider(
                onChanged: (val) {
                  valueOfSlider = val;
                  print('Slider Value : $val');
                  setState(() {});
                },
                min: 1.0,
                max: 5.0,
                divisions: 4,
                value: valueOfSlider,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GraphAlgorithmButton extends StatelessWidget {
  const GraphAlgorithmButton({
    super.key,
    required this.onTap,
    required this.run,
    required this.title,
  });
  final void Function() onTap;
  final bool run;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: run ? Colors.red : Colors.cyan,
        ),
        height: 40.0,
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class MazeCell extends StatelessWidget {
  final Cell cell;
  final bool isPath; // للإشارة إلى أن هذه الخلية جزء من المسار

  const MazeCell({super.key, required this.cell, this.isPath = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cell.color, //isPath ? Colors.green : Colors.white,
        border: Border(
          top: cell.top ? BorderSide.none : const BorderSide(color: Colors.black),
          right: cell.right ? BorderSide.none : const BorderSide(color: Colors.black),
          bottom: cell.bottom ? BorderSide.none : const BorderSide(color: Colors.black),
          left: cell.left ? BorderSide.none : const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}

// Widget to represent the maze
class MazeWidget extends StatelessWidget {
  final Maze maze;
  final List<Map<String, int>> path; // المسار الذي تم إيجاده

  const MazeWidget({super.key, required this.maze, this.path = const []});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: maze.width,
      children: List.generate(
        maze.width * maze.height,
        (index) {
          int x = index % maze.width;
          int y = index ~/ maze.width;
          bool isPartOfPath = path.any((p) => p['x'] == x && p['y'] == y);
          return MazeCell(cell: maze.cells[y][x], isPath: isPartOfPath);
        },
      ),
    );
  }
}

// Stack implementation
class Stack<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  E get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}
