import 'package:fpdart/fpdart.dart';
import 'package:seller_app/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
