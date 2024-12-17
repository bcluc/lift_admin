import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:lift_admin/data/model/hub.dart';

import 'package:lift_admin/data/model/profile.dart';
import 'package:localstorage/localstorage.dart';

String url = const String.fromEnvironment("URL_ROOT");
// Map<String, String> headers = {
//   "Authorization": "Bearer ${localStorage.getItem('token')}"
// };
final headers = {'Content-Type': 'application/json'};

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

Future<User> signIn(String username, String password) async {
  if (url == "http://localhost:27018") {
    localStorage.setItem('token', 'token');
    localStorage.setItem('role', 'administrator');
    localStorage.setItem('id', "6758eae77278a8fec58ff732");
    localStorage.setItem('userName', username);
    return User(
      id: "6758eae77278a8fec58ff732",
      userName: username,
      role: 'administrator',
      token: 'token',
    );
  }
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
      final res = User(
        id: data['id'] as String,
        userName: username,
        role: data['role'] as String,
        token: data['token'] as String,
      );
      localStorage.setItem('token', res.token!);
      localStorage.setItem('role', res.role);
      localStorage.setItem('id', res.id);
      localStorage.setItem('userName', username);

      return res;
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

// HUB

Future<List<Hub>> queryHub({
  required int numberRowIgnore,
}) async {
  /* Lấy 8 dòng dữ liệu Hub được thêm gần đây */
  try {
    final response = await http.get(
      Uri.parse('$url/hub/row?numberRowIgnore=$numberRowIgnore'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Hub.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load recent hubs');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during queryHub');
  }
}

Future<int> queryCountHub() async {
  try {
    final response = await http.get(
      Uri.parse('$url/hubs/count'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['count'] as int;
    } else {
      throw Exception('Failed to load recent hubs');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during queryCountHub');
  }
}

Future<int> queryCountHubSearch(String str) async {
  try {
    final response = await http.get(
      Uri.parse('$url/hubs/search?search=$str'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final list =
          data.map((e) => Hub.fromJson(e as Map<String, dynamic>)).toList();
      return list.length;
    } else {
      throw Exception('Failed to load recent hubs');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during queryCountHubSearch');
  }
}

Future<String> insertHub(String hubName, String address) async {
  try {
    final response = await http.post(
      Uri.parse('$url/hub'),
      headers: headers,
      body: jsonEncode({
        'name': hubName,
        'address': address,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      // Access the nested 'data' object
      final data = responseData['insertedId'] as String;
      return data;
    } else {
      // Handle non-200 responses with more context
      final error = jsonDecode(response.body);
      throw Exception(
          'Failed to insert: ${error['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    throw Exception('An error occurred during insert');
  }
}

Future<int> deleteHub(String hubId) async {
  try {
    final response = await http.delete(
      Uri.parse('$url/hub?id=$hubId'),
      headers: headers,
    );

    return response.statusCode;
  } catch (e) {
    throw Exception('An error occurred during insert');
  }
}

Future<int> updateHub(Hub editHub) async {
  String id = editHub.id!;
  String hubName = editHub.name;
  String address = editHub.address;
  print(id);
  print(hubName);
  try {
    final response = await http.put(
      Uri.parse('$url/hub?id=$id'),
      headers: headers,
      body: jsonEncode({
        'name': hubName,
        'address': address,
      }),
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      // Access the nested 'data' object
      final data = responseData['matched_count'] as int;
      return data;
    } else {
      // Handle non-200 responses with more context
      final error = jsonDecode(response.body);
      throw Exception(
          'Failed to update: ${error['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    throw Exception('An error occurred during update');
  }
}

Future<List<Hub>> searchHubWithNumberRowIgnore({
  required String str,
  required int numberRowIgnore,
}) async {
  try {
    final response = await http.get(
      Uri.parse('$url/hub/search?search=$str&numberRowIgnore=$numberRowIgnore'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Hub.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      // Handle non-200 responses with more context
      final error = jsonDecode(response.body);
      throw Exception(
          'Failed to update: ${error['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    throw Exception('An error occurred during searchHubWithNumberRowIgnore');
  }
}
