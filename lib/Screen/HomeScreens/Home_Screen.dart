import 'package:flutter/material.dart';
import 'package:game/Screen/HomeScreens/tic_tac_toe_home_Screen.dart';
import 'Memory_Match_Screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Color(0xFFEA580C), // Orange
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo7.png'),
                          fit: BoxFit.fitWidth,
                          //colorFilter: ColorFilter.mode(Colors.orange, BlendMode.color)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFEA580C).withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MindPlay',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'Choose Your Game',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Games Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      _buildGameCard(
                        context,
                        title: 'Tic Tac Toe',
                        image: AssetImage('assets/images/tictac.png'),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2563EB), // Blue
                            Color(0xFF1E40AF),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TicTacToeHome()),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildGameCard(
                        context,
                        title: 'Memory Match',
                        image: AssetImage('assets/images/match.png'),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFEA580C), // Orange
                            Color(0xFFC2410C),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MemoryMatchScreen()),
                        ),
                      ),
                      const SizedBox(height: 80),
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

  Widget _buildGameCard(
      BuildContext context, {
        required String title,
        required AssetImage image,
        required Gradient gradient,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(image.assetName,width: 60,)
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Play arrow
            Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Color(0xFF1E3A8A),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}