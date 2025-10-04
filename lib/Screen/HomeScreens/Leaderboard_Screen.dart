import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/DB_helper.dart';
import '../../main.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> topPlayers = [];

  @override
  void initState() {
    super.initState();
    loadTopPlayers();
  }

  Future<void> loadTopPlayers() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'scores',
      orderBy: 'score DESC',
      limit: 5,
    );
    setState(() => topPlayers = result);
  }

  Future<void> resetScores() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('scores');
    loadTopPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏆 Leaderboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: topPlayers.isEmpty
                  ? const Center(
                child: Text(
                  "No scores yet!",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: topPlayers.length,
                itemBuilder: (context, index) {
                  final player = topPlayers[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          "#${index + 1}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        player['name'] ?? 'Unknown',
                        style:
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        "Score: ${player['score']}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: resetScores,
              icon: const Icon(Icons.delete),
              label: const Text("Reset Scores"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
