import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game/Screen/HomeScreens/tic_tac_toe_home_Screen.dart';

import 'Leaderboard_Screen.dart';
import 'Memory_Match_Screen.dart';
//import 'Sudoku_Home_Screen.dart';
import 'Sudoku_Screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final tileStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(title: const Text('MindPlay')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildTile(
              context,
              title: 'Tic Tac Toe',
              icon: Icons.grid_on,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TicTacToeHome()),
              ),
            ),
            /*_buildTile(
              context,
              title: 'Sudoku',
              icon: Icons.table_rows,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SudokuHomeScreen()),
              ),
            ),*/
            _buildTile(
              context,
              title: 'Memory Match',
              icon: Icons.memory,
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MemoryMatchScreen()),
              ),
            ),
            _buildTile(
              context,
              title: 'Leaderboard',
              icon: Icons.leaderboard,
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}