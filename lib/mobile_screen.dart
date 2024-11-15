import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileViewScreen extends StatefulWidget {
  const MobileViewScreen({super.key, required this.difficulty});

  final String difficulty;

  @override
  State<StatefulWidget> createState() {
    return _MobileViewScreenState();
  }
}

class _MobileViewScreenState extends State<MobileViewScreen> {
  late Timer _movementTimer;
  late Timer _spawnTimer;
  final Random _random = Random();
  int _lives = 0;
  int _fallSpeed = 0;
  int _riseSpeed = 3;
  int _spawnInterval = 0;
  List<_FallingObject> _fallingObjects = [];
  List<_RisingObject> _risingObjects = [];

  // Countdown-related variables
  int _countdown = 3;
  bool _isCountdownVisible = true;

  @override
  void initState() {
    super.initState();
    _setDifficultySettings();
    _startCountdown();
  }

  void _setDifficultySettings() {
    switch (widget.difficulty.toLowerCase()) {
      case 'easy':
        _lives = 20;
        _fallSpeed = 6;
        _spawnInterval = 1500;
        _riseSpeed = 6;
        break;
      case 'hard':
        _lives = 10;
        _fallSpeed = 7;
        _spawnInterval = 1000;
        _riseSpeed = 7;
        break;
      default:
        _lives = 30;
        _fallSpeed = 3;
        _spawnInterval = 2000;
        _riseSpeed = 3;
        break;
    }
  }

  @override
  void dispose() {
    if (_movementTimer.isActive) _movementTimer.cancel();
    if (_spawnTimer.isActive) _spawnTimer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    double timeRun = 1.3;

    Timer.periodic(Duration(seconds: timeRun.toInt()), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else if (_countdown == 1) {
          _countdown--;
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _isCountdownVisible = false;
              _countdown = 0;
            });
            _startGame();
          });
        }
      });
    });
  }

  void _startGame() {
    setState(() {
      _fallingObjects.clear();
      _risingObjects.clear();
    });

    _movementTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        for (var obj in _fallingObjects) {
          obj.position += _fallSpeed;
        }
        _fallingObjects.removeWhere((obj) {
          if (obj.position > MediaQuery.of(context).size.height - 50) {
            _lives -= 1;
            if (_lives <= 0) {
              _movementTimer.cancel();
              _spawnTimer.cancel();
              _showGameOverDialog();
            }
            return true;
          }
          return false;
        });

        for (var obj in _risingObjects) {
          obj.position -= _riseSpeed;
        }
        _risingObjects.removeWhere((obj) => obj.position < -50);
        _checkCollisions();
      });
    });

    _spawnTimer =
        Timer.periodic(Duration(milliseconds: _spawnInterval), (timer) {
      _spawnNewFallingObject();
    });
  }

  void _showGameOverDialog() {
    setState(() {
      _fallingObjects.clear();
      _risingObjects.clear();
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFffe71a), Color(0xFFe4482f)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Game Over",
                    style: GoogleFonts.lilitaOne(
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "You've run out of lives.",
                    style: GoogleFonts.lilitaOne(
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _restartGame();
                        },
                        child: Text(
                          "Restart",
                          style: GoogleFonts.lilitaOne(
                            textStyle:
                            const TextStyle(color: Colors.white, fontSize: 35),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Quit",
                          style: GoogleFonts.lilitaOne(
                            textStyle:
                            const TextStyle(color: Colors.white, fontSize: 35),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _restartGame() {
    _setDifficultySettings();
    setState(() {
      _isCountdownVisible = true;
      _countdown = 3;
    });
    _startCountdown();
  }

  void _spawnNewFallingObject() {
    String newImage = 'assets/images/nontarget${_random.nextInt(3) + 1}.png';

    double xPosition = widget.difficulty.toLowerCase() == 'hard'
        ? _random.nextDouble() * (MediaQuery.of(context).size.width - 80)
        : MediaQuery.of(context).size.width / 2 - 40;

    setState(() {
      _fallingObjects.add(
        _FallingObject(
            imagePath: newImage, position: 0.0, xPosition: xPosition),
      );
    });
  }

  void _spawnNewRisingObject(Offset tapPosition) {
    String newImage = 'assets/images/target${_random.nextInt(3) + 1}.png';

    double xPosition = widget.difficulty.toLowerCase() == 'hard'
        ? tapPosition.dx - 40
        : MediaQuery.of(context).size.width / 2 - 40;

    setState(() {
      _risingObjects.add(
        _RisingObject(
          imagePath: newImage,
          position: MediaQuery.of(context).size.height - 50,
          xPosition: xPosition,
        ),
      );
    });
  }

  void _checkCollisions() {
    List<_FallingObject> fallingToRemove = [];
    List<_RisingObject> risingToRemove = [];

    for (var falling in _fallingObjects) {
      for (var rising in _risingObjects) {
        if ((falling.xPosition - rising.xPosition).abs() < 50 &&
            (falling.position - rising.position).abs() < 50) {
          fallingToRemove.add(falling);
          risingToRemove.add(rising);
          break;
        }
      }
    }

    _fallingObjects.removeWhere((obj) => fallingToRemove.contains(obj));
    _risingObjects.removeWhere((obj) => risingToRemove.contains(obj));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (details) {
              if (!_isCountdownVisible) {
                _spawnNewRisingObject(details.localPosition);
              }
            },
            child: SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Lives : ",
                            style: GoogleFonts.lilitaOne(
                              textStyle: const TextStyle(
                                  color: Colors.white, fontSize: 35),
                            ),
                            children: [
                              TextSpan(
                                text: "$_lives",
                                style: GoogleFonts.lilitaOne(
                                  textStyle: const TextStyle(
                                      color: Colors.red, fontSize: 35),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isCountdownVisible)
                    Center(
                      child: Text(
                        _countdown > 0 ? '$_countdown' : 'Go!',
                        style: GoogleFonts.lilitaOne(
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 80),
                        ),
                      ),
                    ),
                  ..._fallingObjects.map((falling) => Positioned(
                        left: falling.xPosition,
                        top: falling.position,
                        child: Image.asset(
                          falling.imagePath,
                          width: 80,
                          height: 80,
                        ),
                      )),
                  ..._risingObjects.map((rising) => Positioned(
                        left: rising.xPosition,
                        top: rising.position,
                        child: Image.asset(
                          rising.imagePath,
                          width: 80,
                          height: 80,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FallingObject {
  _FallingObject(
      {required this.imagePath,
      required this.position,
      required this.xPosition});

  final String imagePath;
  double position;
  double xPosition;
}

class _RisingObject {
  _RisingObject(
      {required this.imagePath,
      required this.position,
      required this.xPosition});

  final String imagePath;
  double position;
  double xPosition;
}
