import '../../domain/repositories/auth_state_repository.dart';
import '../datasources/auth_supabase_data_source.dart';

class AuthStateRepositoryImpl implements AuthStateRepository {
  const AuthStateRepositoryImpl(this._dataSource);

  final AuthSupabaseDataSource _dataSource;

  @override
  Stream<bool> watchSignedIn() => _dataSource.watchSignedIn();
}
