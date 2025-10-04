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

  @override
  void initState() {
    super.initState();
    _generateCards();
  }

  void _generateCards() {
    final emojis = ['🍎', '🍌', '🍇', '🍒', '🍉', '🍍', '🍓', '🥝'];
    _cards = [...emojis, ...emojis]
        .map((e) => _CardModel(icon: e))
        .toList()
      ..shuffle(Random());
    _score = 0;
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
      builder: (_) => AlertDialog(
        title: const Text("🎉 You Won!"),
        content: Text("Your score: $_score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generateCards();
            },
            child: const Text("Play Again"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🧠 Memory Match"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _generateCards,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double gridSize = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;

          int crossAxisCount = gridSize > 600 ? 6 : 4;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Score: $_score",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: gridSize * 0.9,
                  width: gridSize * 0.8,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      return GestureDetector(
                        onTap: () => _onCardTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: card.isFlipped || card.isMatched
                                ? Colors.white
                                : Colors.blueAccent,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2))
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            card.isFlipped || card.isMatched ? card.icon : '',
                            style: TextStyle(
                              fontSize: gridSize * 0.09,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _generateCards,
                  icon: const Icon(Icons.restart_alt),
                  label: const Text("Reset Game"),
                )
              ],
            ),
          );
        },
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
