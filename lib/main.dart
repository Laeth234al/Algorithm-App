import 'package:algorithms_app/View/graph_algorithm.dart';
import 'package:flutter/material.dart';
import 'package:algorithms_app/View/list_algorithm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text(
          'Algorithms App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AlgorithmButton(
              icon: Icons.view_array_outlined,
              title: 'List Algorithm',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ListAlgorithm()));
              },
            ),
            AlgorithmButton(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GraphAlgorithm()));
              },
              title: 'Graph Algorithm',
              icon: Icons.workspaces_filled,
            ),
          ],
        ),
      ),
    );
  }
}

class AlgorithmButton extends StatelessWidget {
  const AlgorithmButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });
  final void Function() onTap;
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200.0,
        height: 200.0,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: Colors.blue[700]!,
              width: 5.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60.0,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
