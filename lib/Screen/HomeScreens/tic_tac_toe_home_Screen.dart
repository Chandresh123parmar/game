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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E3A8A), // Deep Blue
                Color(0xFF0F172A), // Dark Blue/Black
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
                      const SizedBox(width: 12),
                      const Text(
                        'Tic-Tac-Toe',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Mode Selection Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Mode',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildModeButton('Single Player', isSinglePlayer, true),
                              const SizedBox(height: 12),
                              _buildModeButton('Player vs Player', !isSinglePlayer, false),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Player Names Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Player Names',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: playerController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Player 1 (X)',
                                  labelStyle: TextStyle(color: Color(0xFF2563EB)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.05),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFF2563EB).withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFF2563EB),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: opponentController,
                                enabled: !isSinglePlayer,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: isSinglePlayer ? 'Opponent (Computer - O)' : 'Player 2 (O)',
                                  labelStyle: TextStyle(color: Color(0xFFEA580C)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.05),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFEA580C).withOpacity(0.3),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Color(0xFFEA580C),
                                      width: 2,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Start Game Button
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFEA580C),
                                Color(0xFFC2410C),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFEA580C).withOpacity(0.4),
                                blurRadius: 15,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
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
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Start Game',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.play_arrow, color: Colors.white, size: 28),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
          )
              : null,
          color: selected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Color(0xFF2563EB) : Colors.white.withOpacity(0.2),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Color(0xFF2563EB).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                setSingle ? Icons.person : Icons.people,
                color: selected ? Color(0xFF2563EB) : Colors.white70,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
            if (selected) ...[
              const Spacer(),
              Icon(Icons.check_circle, color: Colors.white, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}