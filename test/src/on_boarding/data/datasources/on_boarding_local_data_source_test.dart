import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDataSource localDataSource;

  setUp(() {
    prefs = MockSharedPreferences();
    localDataSource = OnBoardingLocalDataSourceImpl(prefs);
  });

  group('cacheFirstTimer', () {
    test('should call [SharedPreferences] to cache the data', () async {
      // Arrange
      when(() => prefs.setBool(any(), any())).thenAnswer(
        (_) async => true,
      );

      // Act
      await localDataSource.cacheFirstTimer();

      // Assert
      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);

      verifyNoMoreInteractions(prefs);
    });

    test(
      'should throw a [CacheException] '
      'when there is an error while caching the data',
      () async {
        // Arrange
        when(() => prefs.setBool(any(), any())).thenThrow(Exception());

        // Act
        final methodCall = localDataSource.cacheFirstTimer;

        // Assert
        expect(() => methodCall(), throwsA(isA<CacheException>()));

        verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);

        verifyNoMoreInteractions(prefs);
      },
    );
  });

  group('checkIfUserIsFirstTimer', () {
    test(
      'should call [SharedPreferences] to check if user is first timer and'
      'return the right response from storage when data exists',
      () async {
        // Arrange
        when(() => prefs.getBool(any())).thenReturn(false);

        // Act
        final result = await localDataSource.checkIfUserIsFirstTimer();

        // Assert
        expect(result, false);

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);

        verifyNoMoreInteractions(prefs);
      },
    );

    test('should return true if there is no data in storage', () async {
      // Arrange
      when(() => prefs.getBool(any())).thenReturn(null);

      // Act
      final result = await localDataSource.checkIfUserIsFirstTimer();

      // Assert
      expect(result, true);

      verify(() => prefs.getBool(kFirstTimerKey)).called(1);

      verifyNoMoreInteractions(prefs);
    });

    test(
      'should throw a [CacheException] when '
      'there is an error retrieving the data',
      () async {
        // Arrange
        when(() => prefs.getBool(any())).thenThrow(Exception());

        // Act
        final methodCall = localDataSource.checkIfUserIsFirstTimer;

        // Assert
        expect(() => methodCall(), throwsA(isA<CacheException>()));

        verify(() => prefs.getBool(kFirstTimerKey)).called(1);

        verifyNoMoreInteractions(prefs);
      },
    );
  });
}
