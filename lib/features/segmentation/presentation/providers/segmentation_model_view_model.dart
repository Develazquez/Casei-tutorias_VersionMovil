import 'package:flutter/foundation.dart';
import '../../../../core/utils/view_state.dart';
import '../models/segmentation_model_data.dart';
import '../models/segmentation_model_mock_data.dart';
import 'segmentation_provider.dart';

class SegmentationModelViewModel extends ChangeNotifier {
  SegmentationModelViewModel(this._sourceProvider) {
    _sourceProvider.addListener(_onSourceChanged);
    _processData();
  }

  final SegmentationProvider _sourceProvider;
  SegmentationModelData _data = SegmentationModelData.empty;

  SegmentationModelData get data => _data;
  bool get isLoading => _sourceProvider.state == ViewState.loading;

  @override
  void dispose() {
    _sourceProvider.removeListener(_onSourceChanged);
    super.dispose();
  }

  void _onSourceChanged() {
    _processData();
    notifyListeners();
  }

  void _processData() {
    _data = const SegmentationModelData(
      qualityMetrics: SegmentationModelMockData.qualityMetrics,
      experiments: SegmentationModelMockData.experiments,
      pcaPoints: SegmentationModelMockData.pcaPoints,
      artifacts: SegmentationModelMockData.artifacts,
    );
  }
}
