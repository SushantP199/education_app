import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:education_app/src/on_boarding/domain/repos/on_boarding_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSource extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingLocalDataSource localDataSource;
  late OnBoardingRepoImpl repoImpl;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSource();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  test('should be subclass of [OnBoardingRepo]', () {
    expect(repoImpl, isA<OnBoardingRepo>());
  });

  group('cacheFirstTimer', () {
    test('should complete successfully when call to local source is successful',
        () async {
      // Arrange
      when(() => localDataSource.cacheFirstTimer())
          .thenAnswer((_) => Future.value());

      // Act
      final result = await repoImpl.cacheFirstTimer();

      // Assert
      expect(result, const Right<dynamic, void>(null));

      verify(() => localDataSource.cacheFirstTimer()).called(1);

      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return [CacheFailure] when call to local source is unsuccessful',
        () async {
      // Arrange
      when(() => localDataSource.cacheFirstTimer()).thenThrow(
        const CacheException(message: 'Insufficient Storage'),
      );

      // Act
      final result = await repoImpl.cacheFirstTimer();

      // Assert
      expect(
        result,
        Left<Failure, dynamic>(
          CacheFailure(message: 'Insufficient Storage', statusCode: 500),
        ),
      );

      verify(() => localDataSource.cacheFirstTimer()).called(1);

      verifyNoMoreInteractions(localDataSource);
    });
  });

  group('checkIfUserIsFirstTimer', () {
    test('should return true when user is first timer', () async {
      // Arrange
      when(() => localDataSource.checkIfUserIsFirstTimer())
          .thenAnswer((_) => Future.value(true));

      // Act
      final result = await repoImpl.checkIfUserIsFirstTimer();

      // Assert
      expect(result, const Right<dynamic, bool>(true));

      verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);

      verifyNoMoreInteractions(localDataSource);
    });

    test(
        'should return [CacheFailure] when call to local source is unsuccessful',
        () async {
      // Arrange
      when(() => localDataSource.checkIfUserIsFirstTimer()).thenThrow(
        const CacheException(
          message: 'Insufficient permissions',
          statusCode: 403,
        ),
      );

      // Act
      final result = await repoImpl.checkIfUserIsFirstTimer();

      // Assert
      expect(
        result,
        Left<Failure, dynamic>(
          CacheFailure(message: 'Insufficient permissions', statusCode: 403),
        ),
      );
    });
  });
}