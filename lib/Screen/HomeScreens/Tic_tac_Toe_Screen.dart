import 'dart:math';
import 'package:flutter/material.dart';
import '../../helper/DB_helper.dart';

class TicTacToeScreen extends StatefulWidget {
  final String playerX;
  final String playerO;
  final bool singlePlayer;
  const TicTacToeScreen({
    super.key,
    required this.playerX,
    required this.playerO,
    required this.singlePlayer,
  });

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
  }

  void restartRound() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      gameOver = false;
    });
  }

  Future<void> handleTap(int idx) async {
    if (board[idx] != '' || gameOver) return;
    setState(() {
      board[idx] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn;
    });
    await checkStateAfterMove();

    if (widget.singlePlayer && !gameOver && !isXTurn) {
      await Future.delayed(const Duration(milliseconds: 400));
      await aiMove();
    }
  }

  Future<void> checkStateAfterMove() async {
    final winner = _checkWinner();
    if (winner != '') {
      gameOver = true;
      final winnerName = winner == 'X' ? widget.playerX : widget.playerO;
      if (winner != 'D') {
        await DatabaseHelper.instance.insertWin(winnerName, 1);
        final total = await DatabaseHelper.instance.totalPoints(winnerName);
        await showResultDialog('$winnerName Wins!', 'Total Score: $total');
      } else {
        await showResultDialog("It's a Draw!", 'No points awarded');
      }
    }
  }

  Future<void> showResultDialog(String title, String subtitle) async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          subtitle,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              restartRound();
            },
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF2563EB),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Play Again', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Exit', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  String _checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var p in winPatterns) {
      final a = board[p[0]];
      if (a != '' && a == board[p[1]] && a == board[p[2]]) {
        return a;
      }
    }
    if (!board.contains('')) return 'D';
    return '';
  }

  Future<void> aiMove() async {
    int? move;
    move = findWinningMove('O');
    move ??= findWinningMove('X');
    move ??= (board[4] == '') ? 4 : null;
    move ??= pickRandomFrom([0, 2, 6, 8].where((i) => board[i] == '').toList());
    move ??= pickRandomFrom(List.generate(9, (i) => i).where((i) => board[i] == '').toList());
    if (move != null) {
      setState(() {
        board[move!] = 'O';
        isXTurn = true;
      });
      await checkStateAfterMove();
    }
  }

  int? findWinningMove(String player) {
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var p in winPatterns) {
      final vals = [board[p[0]], board[p[1]], board[p[2]]];
      if (vals.where((v) => v == player).length == 2 && vals.contains('')) {
        for (var idx in p) {
          if (board[idx] == '') return idx;
        }
      }
    }
    return null;
  }

  int? pickRandomFrom(List<int> list) {
    if (list.isEmpty) return null;
    return list[Random().nextInt(list.length)];
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final boardSize = (sw < sh) ? sw * 0.85 : sh * 0.6;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.singlePlayer ? 'vs Computer' : 'Player vs Player',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),

              // Player Indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: isXTurn
                              ? LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1E40AF)])
                              : null,
                          color: isXTurn ? null : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isXTurn ? Color(0xFF2563EB) : Colors.white.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'X',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.playerX,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: isXTurn ? FontWeight.bold : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: !isXTurn
                              ? LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFC2410C)])
                              : null,
                          color: !isXTurn ? null : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: !isXTurn ? Color(0xFFEA580C) : Colors.white.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'O',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEA580C),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.playerO,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: !isXTurn ? FontWeight.bold : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      // Game Board
                      Center(
                        child: Container(
                          width: boardSize,
                          height: boardSize,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 2,
                            ),
                          ),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (widget.singlePlayer) {
                                    if (!isXTurn || gameOver) return;
                                    await handleTap(index);
                                  } else {
                                    if (gameOver) return;
                                    await handleTap(index);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: board[index] == 'X'
                                        ? LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF1E40AF)])
                                        : board[index] == 'O'
                                        ? LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFC2410C)])
                                        : null,
                                    color: board[index] == '' ? Colors.white.withOpacity(0.05) : null,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: board[index] != ''
                                        ? [
                                      BoxShadow(
                                        color: board[index] == 'X'
                                            ? Color(0xFF2563EB).withOpacity(0.3)
                                            : Color(0xFFEA580C).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      board[index],
                                      style: TextStyle(
                                        fontSize: boardSize * 0.12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2563EB),
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: restartRound,
                                    icon: Icon(Icons.refresh, color: Colors.white),
                                    label: Text('Restart', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFEA580C),
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final top = await DatabaseHelper.instance.topPlayers();
                                      if (!mounted) return;
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          backgroundColor: Color(0xFF1E293B),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: Row(
                                            children: [
                                              Icon(Icons.emoji_events, color: Color(0xFFEA580C)),
                                              SizedBox(width: 8),
                                              Text('Leaderboard', style: TextStyle(color: Colors.white)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            width: double.maxFinite,
                                            child: top.isEmpty
                                                ? Text('No scores yet', style: TextStyle(color: Colors.white70))
                                                : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: top.length,
                                              itemBuilder: (c, i) {
                                                final r = top[i];
                                                return Container(
                                                  margin: EdgeInsets.only(bottom: 8),
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.05),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 32,
                                                        height: 32,
                                                        decoration: BoxDecoration(
                                                          color: i == 0
                                                              ? Color(0xFFEA580C)
                                                              : Color(0xFF2563EB),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '#${i + 1}',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          r['name'],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFEA580C).withOpacity(0.2),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          '${r['score']}',
                                                          style: TextStyle(
                                                            color: Color(0xFFEA580C),
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('Close', style: TextStyle(color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.emoji_events, color: Colors.white),
                                    label: Text('Board', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade900,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  await DatabaseHelper.instance.resetAllScores();
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('All scores cleared'),
                                      backgroundColor: Colors.red.shade900,
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete_forever, color: Colors.white),
                                label: Text('Reset All Scores', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}