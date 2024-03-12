extension StringExtension on String {
  // "2024-03-11 21:26:34.764871" -> "2024/03/11 21:26"
  String toYMDHMString() {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+$');
    if (!regex.hasMatch(this)) {
      throw FormatException("対象の文字列はDateTimeを文字列に変換した形式である必要があります: ${this}");
    }
    final dateTimeParts = split(' ');
    final dateParts = dateTimeParts[0].split('-');
    final timeParts = dateTimeParts[1].split(':');
    return "${dateParts[0]}/${dateParts[1]}/${dateParts[2]} ${timeParts[0]}:${timeParts[1]}";
  }

  // "2023-04-15 00:00:00.000" -> "2023.04.15"
  String toYMDString() {
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}$');
    if (!regex.hasMatch(this)) {
      throw FormatException("対象の文字列はDateTimeを文字列に変換した形式である必要があります: ${this}");
    }
    final splitString = toString().split(' ');
    final ymd = splitString[0].split('-');
    return "${ymd[0]}.${ymd[1]}.${ymd[2]}";
  }
}
