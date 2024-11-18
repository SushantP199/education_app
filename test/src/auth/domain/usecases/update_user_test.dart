import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late UpdateUser usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = UpdateUser(repo);
    registerFallbackValue(UpdateUserAction.displayName);
  });

  const tAction = UpdateUserAction.displayName;
  const tUserData = 'Test display name';

  test('should call the [AuthRepo.updateUser]', () async {
    // Arrange
    when(
      () => repo.updateUser(
        action: any(named: 'action'),
        userData: any<dynamic>(named: 'userData'),
      ),
    ).thenAnswer(
      (_) async => const Right(null),
    );

    // Act
    final result = await usecase(
      const UpdateUserParams(
        action: tAction,
        userData: tUserData,
      ),
    );

    // Assert
    expect(result, equals(const Right<dynamic, void>(null)));

    verify(
      () => repo.updateUser(
        action: tAction,
        userData: tUserData,
      ),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
