import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/domain/entities/local_user.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignIn usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignIn(repo);
  });

  const tUser = LocalUser.empty();

  const tEmail = 'Test email';
  const tPassword = 'Test password';

  test('should return the [LocalUser] from [AuthRepo]', () async {
    // Arrange
    when(
      () => repo.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) async => const Right(tUser),
    );

    // Act
    final result = await usecase(
      const SignInParams(
        email: tEmail,
        password: tPassword,
      ),
    );

    // Assert
    expect(result, equals(const Right<dynamic, LocalUser>(tUser)));

    verify(
      () => repo.signIn(
        email: tEmail,
        password: tPassword,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });

  final tFailure = ServerFailure(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );

  test(
      'should call the [AuthRepo.SignIn] '
      'and return the [ServerFailure]', () async {
    // Arrange
    when(
      () => repo.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) async => Left(tFailure),
    );

    // Act
    final result = await usecase(
      const SignInParams(
        email: tEmail,
        password: tPassword,
      ),
    );

    // Assert
    expect(result, equals(Left<Failure, dynamic>(tFailure)));

    verify(
      () => repo.signIn(
        email: tEmail,
        password: tPassword,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
