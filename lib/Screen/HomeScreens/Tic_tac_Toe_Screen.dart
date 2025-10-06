import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../helper/DB_helper.dart';
import '../../main.dart';


class TicTacToeScreen extends StatefulWidget {
  final String playerX;
  final String playerO;
  final bool singlePlayer;
  const TicTacToeScreen({super.key, required this.playerX, required this.playerO, required this.singlePlayer});

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

    // If single player and game not over and it's AI's turn -> AI move
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
        // save 1 point for winner
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
        title: Text(title),
        content: Text(subtitle),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              restartRound();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  String _checkWinner() {
    List<List<int>> winPatterns = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6]
    ];
    for (var p in winPatterns) {
      final a = board[p[0]];
      if (a != '' && a == board[p[1]] && a == board[p[2]]) {
        return a; // 'X' or 'O'
      }
    }
    if (!board.contains('')) return 'D'; // Draw
    return '';
  }

  // Simple smart AI: try win -> block -> center -> random
  Future<void> aiMove() async {
    int? move;
    // try to win
    move = findWinningMove('O');
    // block player
    move ??= findWinningMove('X');
    // take center
    move ??= (board[4] == '') ? 4 : null;
    // corner preference
    move ??= pickRandomFrom([0,2,6,8].where((i) => board[i] == '').toList());
    // random
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
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6]
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
    final sw = MediaQuery.of(context).size.width ;
    final sh = MediaQuery.of(context).size.height;
    final boardSize = (sw < sh) ? sw * 0.85 : sh * 0.6;
    final cellSize = boardSize / 3;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Tic Tac Toe'),
      centerTitle: true,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(widget.singlePlayer ? 'Single Player' : 'Player vs Player',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(isXTurn ? '${widget.playerX}\'s Turn (X)' : '${widget.playerO}\'s Turn (O)',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: boardSize,
                height: boardSize,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        if (widget.singlePlayer) {
                          // only allow player taps when it's X's turn
                          if (!isXTurn || gameOver) return;
                          await handleTap(index);
                        } else {
                          // PvP: both players can tap
                          if (gameOver) return;
                          await handleTap(index);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        width: cellSize,
                        height: cellSize,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                          boxShadow: [
                            BoxShadow(blurRadius: 20)
                          ]
                        ),
                        child: Center(
                          child: Text(
                            board[index],
                            style: TextStyle(
                              fontSize: cellSize * 0.30,
                              fontWeight: FontWeight.bold,
                              color: board[index] == 'X' ? Colors.blue : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 15,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    )
                  ),
                    onPressed: restartRound, 
                    child: const Text('Restart Round',style: TextStyle(color: Colors.lightGreen),)),
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.resetAllScores();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All scores cleared')));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                  child: const Text('Reset Scores',style: TextStyle(color: Colors.red),),
                ),
        
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      )
                    ),
                    onPressed: () async {
                      // quick show top players
                      final top = await DatabaseHelper.instance.topPlayers();
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Top Players'),
                          content: SizedBox(
                            width: double.maxFinite,
                            child: top.isEmpty
                                ? const Text('No scores yet')
                                : ListView.builder(
                              shrinkWrap: true,
                              itemCount: top.length,
                              itemBuilder: (c, i) {
                                final r = top[i];
                                return Card(
                                  //color: Colors.white70,
                                  child: ListTile(
                                    leading: Text('#${i + 1}'),
                                    title: Text(r['name'],style: TextStyle(fontSize: 12),),
                                    trailing: Text('Score: ${r['score']}'),
                                  ),
                                );
                              },
                            ),
                          ),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                        ),
                      );
                    },
                    child: const Text('Leaderboard',style: TextStyle(color: Colors.amber),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}