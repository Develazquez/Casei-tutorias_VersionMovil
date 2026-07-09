import '../entities/segmentation_model_artifacts_entity.dart';
import '../repositories/segmentation_repository.dart';

class GetSegmentationModelArtifactsUseCase {
  const GetSegmentationModelArtifactsUseCase(this._repository);

  final SegmentationRepository _repository;

  Future<SegmentationModelArtifactsEntity> call() {
    return _repository.getModelArtifacts();
  }
}
