import 'prescription_item.dart';

class ConsultationSession {
  const ConsultationSession({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.items,
  });

  final String id;
  final String doctorId;
  final String doctorName;
  final DateTime date;
  final List<PrescriptionItem> items;

  String get formattedDate {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
