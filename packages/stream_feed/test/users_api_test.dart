import 'package:stream_feed_dart/src/core/api/users_api_impl.dart';
import 'package:stream_feed_dart/src/core/util/routes.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_feed_dart/src/core/http/http_client.dart';
import 'package:stream_feed_dart/src/core/http/token.dart';
import 'package:stream_feed_dart/src/core/models/user.dart';

import 'utils.dart';

class MockHttpClient extends Mock implements HttpClient {}

Future<void> main() async {
  group('Users API', () {
    final mockClient = MockHttpClient();
    final usersApi = UsersApiImpl(mockClient);
    test('Get', () async {
      const token = Token('dummyToken');
      const targetToken = Token('dummyToken2');
      const id = 'id';
      const withFollowCounts = true;
      when(mockClient.get(
        Routes.buildUsersUrl('$id/'),
        headers: {'Authorization': '$token'},
        queryParameters: {'with_follow_counts': withFollowCounts},
      )).thenAnswer((_) async =>
          Response(data: jsonFixture('user.json'), statusCode: 200));

      await usersApi.get(token, id);

      verify(mockClient.get(
        Routes.buildUsersUrl('$id/'),
        headers: {'Authorization': '$token'},
        queryParameters: {'with_follow_counts': withFollowCounts},
      )).called(1);
    });
    test('Add', () async {
      const token = Token('dummyToken');

      const id = 'john-doe';

      const data = {
        'name': 'John Doe',
        'occupation': 'Software Engineer',
        'gender': 'male',
      };
      final user = User(id: id, data: data);
      const getOrCreate = false;
      when(mockClient.post<Map>(
        Routes.buildUsersUrl(),
        headers: {'Authorization': '$token'},
        queryParameters: {'get_or_create': getOrCreate},
        data: user,
      )).thenAnswer((_) async =>
          Response(data: jsonFixture('user.json'), statusCode: 200));

      await usersApi.add(token, id, data);

      verify(mockClient.post<Map>(
        Routes.buildUsersUrl(),
        headers: {'Authorization': '$token'},
        queryParameters: {'get_or_create': getOrCreate},
        data: user,
      )).called(1);
    });
  });
}
