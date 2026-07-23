import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../../domain/models/tutor_search_models.dart';
import '../../domain/usecases/search_tutorados_use_case.dart';
import 'segmentation_provider.dart';

class SegmentationSearchProvider extends ChangeNotifier {
  SegmentationSearchProvider(this._sourceProvider, this._authProvider) {
    _sourceProvider.addListener(_onSourceChanged);
    _processSearch();
  }

  final SegmentationProvider _sourceProvider;
  final AuthProvider _authProvider;
  final _searchUseCase = SearchTutoradosUseCase();

  TutorSearchQuery _query = const TutorSearchQuery();
  TutorSearchResult _result = const TutorSearchResult(
    students: [],
    totalCount: 0,
  );
  Timer? _debounce;
  bool _isRemoteSearching = false;
  bool _usingLocalFallback = false;

  TutorSearchQuery get query => _query;
  List<SegmentationStudentEntity> get results => _result.students;
  int get totalResults => _result.totalCount;
  bool get isSearching => !_query.isEmpty;
  bool get isRemoteSearching => _isRemoteSearching;
  bool get usingLocalFallback => _usingLocalFallback;
  List<String> get generations {
    final values =
        _sourceProvider.allTutorStudents
            .map((student) => student.cohort.trim())
            .where((cohort) => cohort.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return values;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _sourceProvider.removeListener(_onSourceChanged);
    super.dispose();
  }

  void _onSourceChanged() {
    if (!_isRemoteSearching) {
      _processSearch();
      notifyListeners();
    }
  }

  void onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => submitQuery(text),
    );
  }

  Future<void> submitQuery(String text) async {
    _query = _query.copyWith(text: text.trim());

    if (_query.text.length > 2) {
      await _performRemoteSearch(_query.text);
    } else {
      _sourceProvider.clearSearch();
      _usingLocalFallback = false;
      _processSearch();
    }
    notifyListeners();
  }

  Future<void> _performRemoteSearch(String text) async {
    _isRemoteSearching = true;
    notifyListeners();

    final userId = _authProvider.user?.id;
    if (userId != null) {
      await _sourceProvider.search(text, userId);
      _usingLocalFallback = !_sourceProvider.hasRemoteSearch;
      _processSearch();
    } else {
      _usingLocalFallback = true;
      _processSearch();
    }

    _isRemoteSearching = false;
    notifyListeners();
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

  void toggleAlumni() {
    _query = _query.copyWith(alumniOnly: !_query.alumniOnly);
    _processSearch();
    notifyListeners();
  }

  void clearFilters() {
    _query = const TutorSearchQuery();
    _sourceProvider.clearSearch();
    _usingLocalFallback = false;
    _processSearch();
    notifyListeners();
  }

  void _processSearch() {
    final useRemoteSubset =
        _sourceProvider.hasRemoteSearch && _query.text.length > 2;
    final source = useRemoteSubset
        ? _sourceProvider.remoteSearchResults
        : _sourceProvider.allTutorStudents;
    final effectiveQuery = useRemoteSubset ? _query.copyWith(text: '') : _query;
    _result = _searchUseCase(source, effectiveQuery);
  }

  int getCountByProfile(String profile) {
    return _sourceProvider.allTutorStudents
        .where(
          (s) => s.profileLabel.toLowerCase().contains(profile.toLowerCase()),
        )
        .length;
  }

  int getCountByGeneration(String gen) {
    return _sourceProvider.allTutorStudents
        .where((s) => s.cohort == gen)
        .length;
  }

  int getLowAttendanceCount() {
    return _sourceProvider.allTutorStudents
        .where((s) => s.attendanceRate < 70)
        .length;
  }
}
