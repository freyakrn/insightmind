import 'package:flutter/material.dart';

class AnswerOption {
  final String label;
  final int score;

  const AnswerOption({
    required this.label,
    required this.score,
  });
}

class Question {
  final String id;
  final String text;
  final List<AnswerOption> options;

  const Question({
    required this.id,
    required this.text,
    required this.options,
  });
}

const defaultQuestions = <Question>[
  Question(
    id: 'q1',
    text: 'Dalam 2 minggu terakhir, seberapa sering Anda merasa sedih atau murung?',
    options: [
      AnswerOption(label: 'Tidak Pernah', score: 0),
      AnswerOption(label: 'Beberapa Hari', score: 1),
      AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ],
  ),
  Question(
    id: 'q2',
    text: 'Kesulitan menikmati hal-hal yang biasanya menyenangkan?',
    options: [
      AnswerOption(label: 'Tidak Pernah', score: 0),
      AnswerOption(label: 'Beberapa Hari', score: 1),
      AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ],
  ),
  Question(
    id: 'q3',
    text: 'Merasa sulit tidur, tidur tidak nyenyak, atau terlalu banyak tidur?',
    options: [
      AnswerOption(label: 'Tidak Pernah', score: 0),
      AnswerOption(label: 'Beberapa Hari', score: 1),
      AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ],
  ),
  Question(
    id: 'q4',
    text: 'Merasa kelelahan atau kekurangan energi hampir setiap hari?',
    options: [
      AnswerOption(label: 'Tidak Pernah', score: 0),
      AnswerOption(label: 'Beberapa Hari', score: 1),
      AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ],
  ),
  Question(
    id: 'q5',
    text: 'Kesulitan berkonsentrasi pada hal-hal seperti membaca atau menonton TV?',
    options: [
      AnswerOption(label: 'Tidak Pernah', score: 0),
      AnswerOption(label: 'Beberapa Hari', score: 1),
      AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ],
  ),
  Question(
    id: 'q6',
    text: 'Merasa tidak berharga atau merasa bersalah berlebihan terhadap diri sendiri?',
    options: [
      AnswerOption(label: 'Tidak Pernah', score: 0),
      AnswerOption(label: 'Beberapa Hari', score: 1),
      AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ],
  ),
  Question(
    id: 'q7',
    text: 'Merasa gelisah, tegang, atau sulit untuk tenang?',
    options: [
      AnswerOption(label: 'Tidak Pernah', score: 0),
      AnswerOption(label: 'Beberapa Hari', score: 1),
      AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ],
  ),
  Question(
    id: 'q8',
    text: 'Merasa takut seolah sesuatu yang buruk akan terjadi tanpa alasan jelas?',
    options: [
      AnswerOption(label: 'Tidak Pernah', score: 0),
      AnswerOption(label: 'Beberapa Hari', score: 1),
      AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ],
  ),
  Question(
    id: 'q9',
    text: 'Merasa sangat lelah atau kurang energi dalam aktivitas sehari-hari?',
    options: [
      AnswerOption(label: 'Tidak Pernah', score: 0),
      AnswerOption(label: 'Beberapa Hari', score: 1),
      AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ],
  ),
];

String generateSummary(int totalScore) {
  if (totalScore <= 4) {
    return 'Kondisi Anda tampak stabil dan tidak menunjukkan gejala yang signifikan. '
        'Tetap jaga pola tidur, makan sehat, dan kelola stres dengan baik.';
  } else if (totalScore <= 9) {
    return 'Anda menunjukkan tanda-tanda ringan stres atau kelelahan emosional. '
        'Cobalah melakukan aktivitas relaksasi seperti olahraga ringan atau berbicara dengan orang terdekat.';
  } else if (totalScore <= 14) {
    return 'Terdapat indikasi tingkat kecemasan atau depresi sedang. '
        'Pertimbangkan untuk berkonsultasi jika keluhan terus berlanjut.';
  } else {
    return 'Hasil menunjukkan tingkat stres atau depresi cukup tinggi. '
        'Sebaiknya Anda segera berkonsultasi dengan psikolog untuk penanganan lebih lanjut.';
  }
}
