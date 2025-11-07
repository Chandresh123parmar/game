import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  late List<_CardModel> _cards;
  _CardModel? _firstSelected;
  bool _canTap = true;
  int _score = 0;
  int _moves = 0;

  @override
  void initState() {
    super.initState();
    _generateCards();
  }

  void _generateCards() {
    final emojis = ['💩', '🤡', '💀', '🤮', '👽', '🤖', '💼', '🥽'];
    _cards = [...emojis, ...emojis]
        .map((e) => _CardModel(icon: e))
        .toList()
    ..shuffle(Random());
    _score = 0;
    _moves = 0;
    _firstSelected = null;
    setState(() {});
  }

  void _onCardTap(int index) {
    if (!_canTap) return;
    final selected = _cards[index];

    if (selected.isFlipped || selected.isMatched) return;

    setState(() => selected.isFlipped = true);

    if (_firstSelected == null) {
      _firstSelected = selected;
    } else {
      _moves++;
      if (_firstSelected!.icon == selected.icon) {
        _firstSelected!.isMatched = true;
        selected.isMatched = true;
        _score++;
        _firstSelected = null;

        if (_score == _cards.length ~/ 2) {
          Future.delayed(const Duration(milliseconds: 500), _showWinDialog);
        }
      } else {
        _canTap = false;
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _firstSelected!.isFlipped = false;
            selected.isFlipped = false;
            _firstSelected = null;
            _canTap = true;
          });
        });
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: Color(0xFFEA580C), size: 32),
            SizedBox(width: 12),
            Text("You Won!", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Matches: $_score",
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Total Moves: $_moves",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generateCards();
            },
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFEA580C),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Play Again", style: TextStyle(color: Colors.white)),
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
            child: Text('Exit', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        child: const Text(
                          "Memory Match",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _generateCards,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFFEA580C).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.refresh, color: Color(0xFFEA580C)),
                      ),
                    ),
                  ],
                ),
              ),

              // Score Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF2563EB).withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 28),
                            SizedBox(height: 8),
                            Text(
                              "$_score",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Matches",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
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
                          gradient: LinearGradient(
                            colors: [Color(0xFFEA580C), Color(0xFFC2410C)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFEA580C).withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.touch_app, color: Colors.white, size: 28),
                            SizedBox(height: 8),
                            Text(
                              "$_moves",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Moves",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double gridSize = constraints.maxWidth < constraints.maxHeight
                        ? constraints.maxWidth
                        : constraints.maxHeight;

                    int crossAxisCount = gridSize > 600 ? 6 : 4;

                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.all(20),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 2,
                                ),
                              ),
                              child: SizedBox(
                                height: gridSize * 0.75,
                                width: gridSize * 0.75,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: _cards.length,
                                  itemBuilder: (context, index) {
                                    final card = _cards[index];
                                    return GestureDetector(
                                      onTap: () => _onCardTap(index),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          gradient: card.isFlipped || card.isMatched
                                              ? LinearGradient(
                                            colors: [Colors.white, Colors.white.withOpacity(0.9)],
                                          )
                                              : LinearGradient(
                                            colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: card.isFlipped || card.isMatched
                                                  ? Colors.white.withOpacity(0.3)
                                                  : Color(0xFF2563EB).withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        child: card.isFlipped || card.isMatched
                                            ? Text(
                                          card.icon,
                                          style: TextStyle(
                                            fontSize: gridSize * 0.08,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                            : Icon(
                                          Icons.question_mark,
                                          color: Colors.white,
                                          size: gridSize * 0.06,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFFEA580C), Color(0xFFC2410C)],
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
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: _generateCards,
                                  icon: const Icon(Icons.restart_alt, color: Colors.white, size: 24),
                                  label: const Text(
                                    "New Game",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardModel {
  final String icon;
  bool isFlipped;
  bool isMatched;

  _CardModel({
    required this.icon,
    this.isFlipped = false,
    this.isMatched = false,
  });
}