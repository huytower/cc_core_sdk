import 'package:cc_sdk/domain/failures/cc_failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:message/cc_locale_keys.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../domain/entities/auth/cc_user_entity.dart';
import '../../../domain/repositories/auth/cc_auth_repository.dart';

@LazySingleton(as: CcAuthRepository)
class FirebaseAuthRepositoryImpl implements CcAuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<Result<CcUserEntity, CcFailure>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      return switch (user) {
        User u => Success(_mapFirebaseUserToEntity(u)),
        _ => const Error(UnauthorizedFailure(CcLocaleKeys.auth_login_failed)),
      };
    } on FirebaseAuthException catch (e) {
      return Error(ServerFailure(e.message ?? CcLocaleKeys.app_error_server));
    } catch (e) {
      return const Error(UnknownFailure(CcLocaleKeys.app_error_general));
    }
  }

  @override
  Future<Result<CcUserEntity, CcFailure>> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      final user = userCredential.user;
      return switch (user) {
        User u => Success(_mapFirebaseUserToEntity(u)),
        _ => const Error(UnauthorizedFailure(CcLocaleKeys.auth_login_failed)),
      };
    } on FirebaseAuthException catch (e) {
      return Error(ServerFailure(e.message ?? CcLocaleKeys.app_error_server));
    } catch (e) {
      return const Error(UnknownFailure(CcLocaleKeys.app_error_general));
    }
  }

  @override
  Future<Result<Unit, CcFailure>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(unit);
    } catch (e) {
      return const Error(UnknownFailure(CcLocaleKeys.app_error_general));
    }
  }

  @override
  Future<Result<CcUserEntity?, CcFailure>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      return Success(user != null ? _mapFirebaseUserToEntity(user) : null);
    } catch (e) {
      return const Error(UnknownFailure(CcLocaleKeys.app_error_general));
    }
  }

  @override
  Stream<CcUserEntity?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? _mapFirebaseUserToEntity(user) : null;
    });
  }

  CcUserEntity _mapFirebaseUserToEntity(User user) {
    return CcUserEntity(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
