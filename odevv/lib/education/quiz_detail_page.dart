import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class QuizDetailPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> questions;

  const QuizDetailPage({
    Key? key,
    required this.title,
    required this.questions,
  }) : super(key: key);

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _incorrectAnswers = 0;
  List<ChartData> chartData = [];
  String? _selectedAnswer;

  void _answerQuestion(String selectedOption) {
    bool isCorrect = selectedOption == widget.questions[_currentQuestionIndex]['answer'];

    setState(() {
      _selectedAnswer = selectedOption;
      if (isCorrect) {
        _score++;
      } else {
        _incorrectAnswers++;
      }

      // Add data for chart
      chartData.add(ChartData('Q${_currentQuestionIndex + 1}', _score, _incorrectAnswers));
    });
  }

  void _moveToNextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;  // Reset selected answer for next question
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Quiz Tamamlandı!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Skorunuz: $_score / ${widget.questions.length}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.orange, backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Tamam', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = widget.questions[_currentQuestionIndex];
    double progress = (_currentQuestionIndex + 1) / widget.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.orange,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(Colors.orange),
            ),
            SizedBox(height: 16),

            // Question Text inside a card with gradient background
            Card(
              elevation: 10,
              color: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${_currentQuestionIndex + 1}. ${currentQuestion['question']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Option Buttons with A, B, C, D labels
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion['options'].length,
                itemBuilder: (ctx, index) {
                  String option = currentQuestion['options'][index];
                  bool isCorrect = option == currentQuestion['answer'];
                  bool isSelected = _selectedAnswer == option;

                  // Determine the color of the card based on the answer status
                  Color cardColor = Colors.white;
                  Color textColor = Colors.black;
                  if (isSelected) {
                    cardColor = isCorrect ? Colors.green : Colors.red;
                    textColor = Colors.white;
                  }

                  return Card(
                    elevation: 5,
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: InkWell(
                      onTap: () {
                        if (_selectedAnswer == null) {
                          _answerQuestion(option);  // Select the answer
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              String.fromCharCode(65 + index),  // Display A, B, C, D
                              style: TextStyle(fontSize: 18, color: textColor),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(fontSize: 16, color: textColor),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Graph with chart and improved layout
            SizedBox(height: 20),
            Container(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'Doğru ve Yanlış Cevaplar'),
                series: <ChartSeries>[
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.question,
                    yValueMapper: (ChartData data, _) => data.correctAnswers,
                    name: 'Doğru Cevaplar',
                    color: Colors.green,
                  ),
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.question,
                    yValueMapper: (ChartData data, _) => data.incorrectAnswers,
                    name: 'Yanlış Cevaplar',
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            // Button to move to next question
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswer == null ? null : _moveToNextQuestion,
              child: Text('Sonraki Soru'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                backgroundColor: Colors.orange,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.question, this.correctAnswers, this.incorrectAnswers);
  final String question;
  final int correctAnswers;
  final int incorrectAnswers;
}
