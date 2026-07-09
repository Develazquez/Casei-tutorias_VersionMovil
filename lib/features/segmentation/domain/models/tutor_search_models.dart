import '../entities/segmentation_student_entity.dart';

class TutorSearchQuery {
  final String text;
  final Set<String> profiles;
  final Set<String> generations;
  final bool lowAttendanceOnly;
  final bool alumniOnly;

  const TutorSearchQuery({
    this.text = '',
    this.profiles = const {},
    this.generations = const {},
    this.lowAttendanceOnly = false,
    this.alumniOnly = false,
  });

  bool get isEmpty =>
      text.isEmpty &&
      profiles.isEmpty &&
      generations.isEmpty &&
      !lowAttendanceOnly &&
      !alumniOnly;

  TutorSearchQuery copyWith({
    String? text,
    Set<String>? profiles,
    Set<String>? generations,
    bool? lowAttendanceOnly,
    bool? alumniOnly,
  }) {
    return TutorSearchQuery(
      text: text ?? this.text,
      profiles: profiles ?? this.profiles,
      generations: generations ?? this.generations,
      lowAttendanceOnly: lowAttendanceOnly ?? this.lowAttendanceOnly,
      alumniOnly: alumniOnly ?? this.alumniOnly,
    );
  }
}

enum SearchResultType { student, subject, offer }

class TutorSearchResult {
  final List<SegmentationStudentEntity> students;
  final int totalCount;

  const TutorSearchResult({required this.students, required this.totalCount});
}
