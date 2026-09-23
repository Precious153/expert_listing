void main() {
  const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  String formatPostDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }
    try {
      String parsedValue = value;
      if (!parsedValue.endsWith('Z')) {
        parsedValue += 'Z';
      }
      final date = DateTime.parse(parsedValue).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      print("date: \$date");
      print("now: \$now");
      print("diff: \$diff");

      if (diff.inSeconds < 60) {
        return 'Just now';
      } else if (diff.inMinutes < 60) {
        return '\${diff.inMinutes}m';
      } else if (diff.inHours < 24) {
        return '\${diff.inHours}h';
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else if (date.year == now.year) {
        return '\${_months[date.month - 1]} \${date.day}';
      } else {
        return '\${_months[date.month - 1]} \${date.day}, \${date.year}';
      }
    } catch (e) {
      print("error: \$e");
      return 'ERROR';
    }
  }

  print(formatPostDate("2026-09-23T09:16:48.873374"));
}
