import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mobile_screen.dart';

class StartGame extends StatefulWidget {
  const StartGame({super.key});

  @override
  _StartGameState createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  String _selectedDifficulty = 'Easy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09b0d5),
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(500),
                  bottomRight: Radius.circular(500), // 50% of the height of the image (adjust as necessary)
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 + 160,
            left: 0,
            right: 0,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFffe71a), // #ffe71a
                              Color(0xFFe4482f), // #e4482f
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: DropdownButton<String>(
                            value: _selectedDifficulty,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedDifficulty = newValue!;
                              });
                            },
                            items: <String>['Easy', 'Hard']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value,
                                      style: GoogleFonts.lilitaOne(
                                        fontSize: 35,
                                        letterSpacing: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 80),
                                  ],
                                ),
                              );
                            }).toList(),
                            dropdownColor: Colors.black,
                            iconEnabledColor: Colors.white,
                            underline: const SizedBox.shrink(),
                            iconSize: 35,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation,
                                secondaryAnimation) =>
                                MobileViewScreen(difficulty: _selectedDifficulty),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              // Fade transition animation
                              const begin = 0.0;
                              const end = 1.4;
                              const curve = Curves.easeIn;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var opacityAnimation = animation.drive(tween);

                              return FadeTransition(
                                  opacity: opacityAnimation, child: child);
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFffe71a), // #ffe71a
                              Color(0xFFe4482f), // #e4482f
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            "Start",
                            style: GoogleFonts.lilitaOne(
                              fontSize: 50,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Positioned info icon at the top right corner
          Positioned(
            top: 45,
            right: 10,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Column(
                        children: [
                          Center(
                            child: Text(
                              'Game Rules',
                              style: GoogleFonts.lilitaOne(fontSize: 40),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Center(
                            child: Text(
                              'Welcome to the game! Your goal is to defend against the Enemies by tapping the screen to launch Defenders upwards. Each missed Enemy costs a life, and the game ends when your lives run out. Good luck!',
                              style: GoogleFonts.lilitaOne(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),

                          ),
                        ],
                      ),
                      content: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  _buildTitleWithImages('Defenders', [
                                    [
                                      'assets/images/target1.png',
                                      'assets/images/target2.png',
                                      'assets/images/target3.png'
                                    ],
                                  ]),
                                  const SizedBox(height: 20), // Space between titles
                                  _buildTitleWithImages('Enemies', [
                                    [
                                      'assets/images/nontarget1.png',
                                      'assets/images/nontarget2.png',
                                      'assets/images/nontarget3.png'
                                    ],
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFffe71a), // #ffe71a
                                  Color(0xFFe4482f), // #e4482f
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Close",
                              style: GoogleFonts.lilitaOne(
                                fontSize: 20,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFffe71a), // #ffe71a
                      Color(0xFFe4482f), // #e4482f
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleWithImages(String title, List<List<String>> imageData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lilitaOne(fontSize: 28),
        ),
        const SizedBox(height: 10),
        Column(
          children: imageData.map(
                (data) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data
                    .map(
                      (imagePath) => Image.asset(
                    imagePath,
                    height: 70,
                    width: 70,
                  ),
                )
                    .toList(),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
