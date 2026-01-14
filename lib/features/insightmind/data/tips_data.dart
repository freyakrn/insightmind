class DailyTip {
  final String title;
  final String description;

  DailyTip({required this.title, required this.description});
}

final List<DailyTip> dailyTips = [
  DailyTip(
    title: 'Tarik Napas Dalam',
    description:
        'Luangkan waktu 10 menit hari ini untuk menarik napas dalam. '
        'Teknik pernapasan ini dapat membantu menurunkan stres dan membuat pikiran lebih jernih.',
  ),
  DailyTip(
    title: 'Tiga Hal yang Disyukuri',
    description:
        'Tuliskan tiga hal yang kamu syukuri hari ini. Cara sederhana ini '
        'dapat meningkatkan rasa bahagia dan sikap positif.',
  ),
  DailyTip(
    title: 'Jalan Singkat',
    description:
        'Berjalan kaki selama 5–10 menit dapat membantu menenangkan pikiran '
        'dan meningkatkan fokus. Cobalah keluar sebentar hari ini.',
  ),
  DailyTip(
    title: 'Istirahat dari Layar',
    description:
        'Jangan lupa mengambil jeda dari layar setiap 30 menit. '
        'Istirahat sejenak dapat membantu menjaga kesehatan mental dan mata.',
  ),
  DailyTip(
    title: 'Tersenyum Sekejap',
    description:
        'Cobalah tersenyum pada diri sendiri di cermin. Walau sederhana, '
        'hal ini bisa mengubah suasana hati menjadi lebih baik.',
  ),
];
