import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../../domain/models/tutor_search_models.dart';
import '../../domain/usecases/search_tutorados_use_case.dart';
import 'segmentation_provider.dart';

class SegmentationSearchViewModel extends ChangeNotifier {
  SegmentationSearchViewModel(this._sourceProvider) {
    _sourceProvider.addListener(_onSourceChanged);
    _processSearch();
  }

  final SegmentationProvider _sourceProvider;
  final _searchUseCase = SearchTutoradosUseCase();
  
  TutorSearchQuery _query = const TutorSearchQuery();
  TutorSearchResult _result = const TutorSearchResult(students: [], totalCount: 0);
  Timer? _debounce;

  TutorSearchQuery get query => _query;
  List<SegmentationStudentEntity> get results => _result.students;
  int get totalResults => _result.totalCount;
  bool get isSearching => !_query.isEmpty;

  @override
  void dispose() {
    _debounce?.cancel();
    _sourceProvider.removeListener(_onSourceChanged);
    super.dispose();
  }

  void _onSourceChanged() {
    _processSearch();
    notifyListeners();
  }

  void onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _query = _query.copyWith(text: text.trim());
      _processSearch();
      notifyListeners();
    });
  }

  void toggleProfile(String profile) {
    final profiles = Set<String>.from(_query.profiles);
    if (profiles.contains(profile)) {
      profiles.remove(profile);
    } else {
      profiles.add(profile);
    }
    _query = _query.copyWith(profiles: profiles);
    _processSearch();
    notifyListeners();
  }

  void toggleGeneration(String generation) {
    final gens = Set<String>.from(_query.generations);
    if (gens.contains(generation)) {
      gens.remove(generation);
    } else {
      gens.add(generation);
    }
    _query = _query.copyWith(generations: gens);
    _processSearch();
    notifyListeners();
  }

  void toggleLowAttendance() {
    _query = _query.copyWith(lowAttendanceOnly: !_query.lowAttendanceOnly);
    _processSearch();
    notifyListeners();
  }

  void clearFilters() {
    _query = const TutorSearchQuery();
    _processSearch();
    notifyListeners();
  }

  void _processSearch() {
    _result = _searchUseCase(_sourceProvider.students, _query);
  }

  // Contadores para los chips de filtro
  int getCountByProfile(String profile) {
    return _sourceProvider.students.where((s) => 
      s.profileLabel.toLowerCase().contains(profile.toLowerCase())).length;
  }

  int getCountByGeneration(String gen) {
    return _sourceProvider.students.where((s) => s.cohort == gen).length;
  }

  int getLowAttendanceCount() {
    return _sourceProvider.students.where((s) => 
      s.attendanceRate < SearchTutoradosUseCase.lowAttendanceThreshold).length;
  }
}
