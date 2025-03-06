import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(HangmanGameApp());
}

class HangmanGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hangman Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HangmanGame(),
    );
  }
}

class HangmanGame extends StatefulWidget {
  @override
  _HangmanGameState createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  final List<String> words = ["FLUTTER", "DART", "MOBILE", "ANDROID", "WIDGET"];
  late String wordToGuess;
  late List<String> guessedLetters;
  late Set<String> wrongGuessesSet;
  final int maxWrongGuesses = 6;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      wordToGuess = words[Random().nextInt(words.length)];
      guessedLetters = [];
      wrongGuessesSet = {};
    });
  }

  void guessLetter(String letter) {
    if (guessedLetters.contains(letter)) return;

    setState(() {
      guessedLetters.add(letter);
      if (!wordToGuess.contains(letter)) {
        wrongGuessesSet.add(letter);
      }
    });
  }

  String getDisplayedWord() {
    return wordToGuess.split('').map((letter) {
      return guessedLetters.contains(letter) ? letter : '_';
    }).join(' ');
  }

  bool isGameWon() {
    return wordToGuess.split('').every((letter) => guessedLetters.contains(letter));
  }

  bool isGameOver() {
    return wrongGuessesSet.length >= maxWrongGuesses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hangman Game"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Wrong Guesses: ${wrongGuessesSet.length} / $maxWrongGuesses",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
            SizedBox(height: 20),
            Text(
              getDisplayedWord(),
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 6, color: Colors.black),
            ),
            SizedBox(height: 30),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('').map((letter) {
                bool isGuessed = guessedLetters.contains(letter);
                bool isWrong = wrongGuessesSet.contains(letter);
                return ElevatedButton(
                  onPressed: (isGameOver() || isGameWon() || isGuessed) ? null : () => guessLetter(letter),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isWrong ? Colors.red : (isGuessed ? Colors.green : Colors.blue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                  child: Text(
                    letter,
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            if (isGameWon())
              Text("🎉 You Won! 🎉", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green)),
            if (isGameOver())
              Text("☹ You Lost! The word was: $wordToGuess", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.red)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: Text("Play Again", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
