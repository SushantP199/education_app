import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignUp usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });

  const tEmail = 'Test email';
  const tPassword = 'Test password';
  const tFullName = 'Test full name';

  test('should call the [AuthRepo.signUp]', () async {
    // Arrange
    when(
      () => repo.signUp(
        email: any(named: 'email'),
        fullName: any(named: 'fullName'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) async => const Right(null),
    );

    // Act
    final result = await usecase(
      const SignUpParams(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      ),
    );

    // Assert
    expect(result, equals(const Right<dynamic, void>(null)));

    verify(
      () => repo.signUp(
        email: tEmail,
        fullName: tFullName,
        password: tPassword,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
