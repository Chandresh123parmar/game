import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game/Screen/tic_tac_toe_Screen.dart';

import 'Placeholder_Screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MindPlay"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildGameCard(
              context,
              title: "Tic Tac Toe",
              icon: Icons.grid_3x3,
              color: Colors.blue,
              page: const TicTacToeScreen(),
            ),
            _buildGameCard(
              context,
              title: "Sudoku",
              icon: Icons.table_chart,
              color: Colors.orange,
              page: const PlaceholderScreen(title: "Sudoku"),
            ),
            _buildGameCard(
              context,
              title: "Memory Match",
              icon: Icons.style,
              color: Colors.green,
              page: const PlaceholderScreen(title: "Memory Match"),
            ),
            _buildGameCard(
              context,
              title: "Leaderboard",
              icon: Icons.leaderboard,
              color: Colors.purple,
              page: const PlaceholderScreen(title: "Leaderboard"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required Widget page}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    );
  }
}