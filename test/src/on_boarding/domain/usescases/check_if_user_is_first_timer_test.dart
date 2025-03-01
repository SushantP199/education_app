import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late OnBoardingRepo repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CheckIfUserIsFirstTimer(repo);
  });

  test(
    'should call the [OnBoardingRepo.CheckIfUserIsFirstTimer]'
    'and get a response from it',
    () async {
      // Arrange
      when(() => repo.checkIfUserIsFirstTimer()).thenAnswer(
        (_) async => const Right(true),
      );

      // Act
      final result = await usecase();

      // Assert
      expect(
        result,
        equals(
          const Right<dynamic, bool>(true),
        ),
      );

      verify(() => repo.checkIfUserIsFirstTimer()).called(1);

      verifyNoMoreInteractions(repo);
    },
  );
}
