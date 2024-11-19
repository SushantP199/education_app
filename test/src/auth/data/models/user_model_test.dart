import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/domain/entities/local_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();

  test('should be a subclass of [LocalUser] entity', () {
    expect(tLocalUserModel, isA<LocalUser>());
  });

  final tMap = jsonDecode(fixture('user.json')) as DataMap;

  group('fromMap', () {
    test('should return a valid [LocalUserModel] from the map', () {
      // Act
      final result = LocalUserModel.fromMap(tMap);

      // Assert
      expect(result, isA<LocalUserModel>());
      expect(result, equals(tLocalUserModel));
    });

    test('should throw an [Error] when the map is invalid', () {
      // Arrange
      final map = DataMap.from(tMap)..remove('uid');

      // Act
      const call = LocalUserModel.fromMap;

      // Assert
      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('should return a valid [DataMap] from the model', () {
      // Act
      final result = tLocalUserModel.toMap();

      // Assert
      expect(result, equals(tMap));
    });
  });

  group('copyWith', () {
    test('should return a valid [LocalUserModel] with updated values', () {
      // Act
      final result = tLocalUserModel.copyWith(uid: '2');

      // Assert
      expect(result.uid, '2');
    });
  });
}
