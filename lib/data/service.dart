import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:lift_admin/base/singleton/user_info.dart';

import 'package:lift_admin/data/model/profile.dart';

String url = const String.fromEnvironment("URL_ROOT");
Map<String, String> headers = {"Authorization": "Bearer ${UserInfo().token}"};

Future<User> fetchUsers() async {
  final response = await http.get(Uri.parse('$url/users'), headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<void> signIn(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$url/auth/sign-in'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      // Access the nested 'data' object
      final data = responseData['data'] as Map<String, dynamic>;

      // Safely assign values
      UserInfo().token = data['token'] as String?;
      UserInfo().id = data['id'] as String?;
      UserInfo().role = data['role'] as String?;
    } else {
      // Handle non-200 responses with more context
      final error = jsonDecode(response.body);
      throw Exception(
          'Failed to sign in: ${error['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    print('Error during sign-in: $e');
    throw Exception('An error occurred during sign-in');
  }
}
