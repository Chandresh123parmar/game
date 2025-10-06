import 'package:flutter/material.dart';
import 'Tic_tac_Toe_Screen.dart';

class TicTacToeHome extends StatefulWidget {
  const TicTacToeHome({super.key});
  @override
  State<TicTacToeHome> createState() => _TicTacToeHomeState();
}

class _TicTacToeHomeState extends State<TicTacToeHome> {
  bool isSinglePlayer = true;
  final TextEditingController playerController = TextEditingController(text: 'You');
  final TextEditingController opponentController = TextEditingController(text: 'Computer');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Tic-Tac-Toe'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildModeButton('Single Player', isSinglePlayer, true),
                  const SizedBox(height: 20),
                  _buildModeButton('Player vs Player', !isSinglePlayer, false),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: playerController,
                decoration: const InputDecoration(
                    labelText: 'Player 1 (X)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: opponentController,
                decoration: InputDecoration(
                    labelText:
                    isSinglePlayer ? 'Opponent (Computer - O)' : 'Player 2 (O)',
                    border: const OutlineInputBorder()),
                enabled: !isSinglePlayer ? true : false,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  final p1 = playerController.text.trim().isEmpty
                      ? 'Player X'
                      : playerController.text.trim();
                  final p2 = isSinglePlayer
                      ? (opponentController.text.trim().isEmpty
                      ? 'Computer'
                      : opponentController.text.trim())
                      : (opponentController.text.trim().isEmpty
                      ? 'Player O'
                      : opponentController.text.trim());

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TicTacToeScreen(
                        playerX: p1,
                        playerO: p2,
                        singlePlayer: isSinglePlayer,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(double.infinity, 50)),
                child: Text('Start Game',style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.w500),),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildModeButton(String text, bool selected, bool setSingle) {
    return GestureDetector(
      onTap: () => setState(() => isSinglePlayer = setSingle),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.9),
              offset: const Offset(0, 6),
              blurRadius: 6,
            ),
          ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
