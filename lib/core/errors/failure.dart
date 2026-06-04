import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

final class FirebaseNotConfiguredFailure extends Failure {
  const FirebaseNotConfiguredFailure()
      : super(
          'Firebase non configuré. Exécutez flutterfire configure (voir GUIDE_FR.md).',
        );
}
