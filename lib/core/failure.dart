// ignore_for_file: use_super_parameters

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure(String m) : super(m);
}

class ServerFailure extends Failure {
  const ServerFailure(String m) : super(m);
}

class CacheFailure extends Failure {
  const CacheFailure(String m) : super(m);
}
