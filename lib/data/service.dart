import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:lift_admin/data/dto/delivery_dto.dart';
import 'package:lift_admin/data/dto/hub_dto.dart';
import 'package:lift_admin/data/dto/order_dto.dart';
import 'package:lift_admin/data/dto/staff_dto.dart';
import 'package:lift_admin/data/model/profile.dart';
import 'package:lift_admin/data/model/user.dart';
import 'package:localstorage/localstorage.dart';

String url = const String.fromEnvironment("URL_ROOT");
// Map<String, String> headers = {
//   "Authorization": "Bearer ${localStorage.getItem('token')}"
// };
final headers = {'Content-Type': 'application/json'};

Future<UserSession> fetchUsers() async {
  final response = await http.get(Uri.parse('$url/users'), headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return UserSession.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<UserSession> signIn(String username, String password) async {
  // if (url == "http://localhost:27018") {
  //   localStorage.setItem('token', 'token');
  //   localStorage.setItem('role', 'administrator');
  //   localStorage.setItem('id', "6758eae77278a8fec58ff732");
  //   localStorage.setItem('userName', username);
  //   return UserSession(
  //     id: "6758eae77278a8fec58ff732",
  //     userName: username,
  //     role: 'administrator',
  //     token: 'token',
  //   );
  // }
  try {
    final response = await http.post(
      Uri.parse('https://waseminarcnpm2.azurewebsites.net/auth/sign-in'),
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
      final res = UserSession(
        id: data['id'] as String,
        userName: username,
        role: data['role'] as String,
        token: data['token'] as String,
      );
      localStorage.setItem('token', res.token!);
      localStorage.setItem('role', res.role);
      localStorage.setItem('id', res.id);
      localStorage.setItem('userName', username);

      if (res.role == 'coordinator') {
        try {
          final response = await http.get(
            Uri.parse(
                'https://waseminarcnpm2.azurewebsites.net/protected/coordinator/byCoordinatorUserId?coordinatorUserId=${res.id}'),
          );
          if (response.statusCode == 200) {
            final responseData =
                jsonDecode(response.body) as Map<String, dynamic>;

            // Access the nested 'data' object
            final data = responseData['data'] as Map<String, dynamic>;
            localStorage.setItem(
              'hubId',
              data['coordinator_HubId'] as String,
            );
          }
        } catch (e) {}
      }

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

Future<List<String>> fetchAddressSuggestions(String input) async {
  final response = await http.get(Uri.parse('$url/address?address=$input'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => item['display_name'] as String).toList();
  } else {
    // Handle error
    return [];
  }
}

Future<void> queryHubDetail({
  required String hubId,
}) async {
  /* Lấy 8 dòng dữ liệu Hub được thêm gần đây */
  try {
    final response = await http.get(
      Uri.parse('$url/hub?id=$hubId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      localStorage.setItem('hubAddress', data['address'] as String);
      localStorage.setItem('hubName', data['name'] as String);
    } else {
      throw Exception('Failed to load recent hubs');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during queryHub');
  }
}

Future<List<HubDto>> queryHub({
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
      return data
          .map((e) => HubDto.fromJson(e as Map<String, dynamic>))
          .toList();
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
          data.map((e) => HubDto.fromJson(e as Map<String, dynamic>)).toList();
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

Future<int> updateHub(HubDto editHub) async {
  String id = editHub.hubId!;
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

Future<List<HubDto>> searchHubWithNumberRowIgnore({
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
      return data
          .map((e) => HubDto.fromJson(e as Map<String, dynamic>))
          .toList();
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

//
//
// USER
//
//

Future<List<User>> queryUser({
  required int numberRowIgnore,
}) async {
  try {
    final response = await http.get(
      Uri.parse('$url/user/row?numberRowIgnore=$numberRowIgnore'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load recent users');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during queryUser');
  }
}

Future<List<User>> queryAllUser() async {
  try {
    final response = await http.get(
      Uri.parse('$url/users'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load recent users');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during queryUser');
  }
}

Future<List<User>> searchAllUser(String str) async {
  try {
    final response = await http.get(
      Uri.parse('$url/users/search?search=$str'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load recent users');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during queryUser');
  }
}

Future<int> queryCountUser() async {
  try {
    final response = await http.get(
      Uri.parse('$url/users/count'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['count'] as int;
    } else {
      throw Exception('Failed to load recent users');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during queryUserHub');
  }
}

Future<int> queryCountUserSearch(String str) async {
  try {
    final response = await http.get(
      Uri.parse('$url/users/search?search=$str'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final list =
          data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
      return list.length;
    } else {
      throw Exception('Failed to load recent users');
    }
  } catch (e) {
    print('Error during queryCountUserSearch: $e');
    throw Exception('An error occurred during queryCountUserSearch');
  }
}

Future<int> deleteUser(String userId) async {
  try {
    final response = await http.delete(
      Uri.parse('$url/user?id=$userId'),
      headers: headers,
    );

    return response.statusCode;
  } catch (e) {
    throw Exception('An error occurred during deleteUser');
  }
}

Future<int> updateUser(User editUser) async {
  String id = editUser.id!;
  String userName = editUser.name;
  String role = editUser.role;

  try {
    final response = await http.put(
      Uri.parse('$url/user?id=$id'),
      headers: headers,
      body: jsonEncode({
        'username': userName,
        'role': role,
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

Future<List<User>> searchUserWithNumberRowIgnore({
  required String str,
  required int numberRowIgnore,
}) async {
  try {
    final response = await http.get(
      Uri.parse(
          '$url/user/search?search=$str&numberRowIgnore=$numberRowIgnore'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      // Handle non-200 responses with more context
      final error = jsonDecode(response.body);
      throw Exception(
          'Failed to update: ${error['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    throw Exception('An error occurred during searchUserWithNumberRowIgnore');
  }
}

//
// ORDER
//

Future<int> deleteOrder(String orderId) async {
  try {
    final response = await http.delete(
      Uri.parse('$url/order?id=$orderId'),
      headers: headers,
    );

    return response.statusCode;
  } catch (e) {
    throw Exception('An error occurred during deleteOrder');
  }
}

Future<List<OrderDto>> queryOrder({
  required int numberRowIgnore,
}) async {
  /* Lấy 8 dòng dữ liệu Hub được thêm gần đây */
  try {
    final response = await http.get(
      Uri.parse('$url/order/row?numberRowIgnore=$numberRowIgnore'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => OrderDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recent hubs');
    }
  } catch (e) {
    print('Error during queryOrder: $e');
    throw Exception('An error occurred during queryOrder');
  }
}

Future<List<OrderDto>> searchOrderWithNumberRowIgnore({
  required String str,
  required int numberRowIgnore,
}) async {
  try {
    final response = await http.get(
      Uri.parse(
          '$url/order/search?search=$str&numberRowIgnore=$numberRowIgnore'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => OrderDto.fromJson(json)).toList();
    } else {
      // Handle non-200 responses with more context
      final error = jsonDecode(response.body);
      throw Exception(
          'Failed to update: ${error['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    throw Exception('An error occurred during searchOrderWithNumberRowIgnore');
  }
}

Future<int> queryCountOrder() async {
  try {
    final response = await http.get(
      Uri.parse('$url/orders/count'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['count'] as int;
    } else {
      throw Exception('Failed to load recent orders');
    }
  } catch (e) {
    print('Error during queryCountOrder: $e');
    throw Exception('An error occurred during queryCountOrder');
  }
}

Future<List<OrderDto>> queryOrderWithHubId({
  required String hubId,
}) async {
  /* Lấy 8 dòng dữ liệu Hub được thêm gần đây */
  try {
    final response = await http.get(
      Uri.parse('$url/orders/hub?hubId=$hubId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => OrderDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recent hubs');
    }
  } catch (e) {
    print('Error during queryOrder: $e');
    throw Exception('An error occurred during queryOrder');
  }
}

Future<int> queryCountOrderSearch(String str) async {
  try {
    final response = await http.get(
      Uri.parse('$url/order/search?search=$str'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      final list = data.map((json) => OrderDto.fromJson(json)).toList();
      return list.length;
    } else {
      throw Exception('Failed to load recent orders');
    }
  } catch (e) {
    print('Error during queryCountOrderSearch: $e');
    throw Exception('An error occurred during queryCountOrderSearch');
  }
}

Future<List<OrderDto>> searchAllOrderByHubId(String str, String hubId) async {
  try {
    final response = await http.get(
      Uri.parse('$url/order/search/hub?hubId=$hubId&search=$str'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => OrderDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load searchAllOrderByHubId');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during searchAllOrderByHubId');
  }
}

// # WITH STATUS

Future<List<OrderDto>> queryOrderWithStatus({
  required int numberRowIgnore,
  required String status,
}) async {
  /* Lấy 8 dòng dữ liệu Hub được thêm gần đây */
  try {
    final response = await http.get(
      Uri.parse(
          '$url/order/row/status?status=$status&numberRowIgnore=$numberRowIgnore'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => OrderDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recent hubs');
    }
  } catch (e) {
    print('Error during queryOrder: $e');
    throw Exception('An error occurred during queryOrder');
  }
}

Future<List<OrderDto>> queryOrderWithStatusByHubId({
  required String status,
  required String hubId,
}) async {
  /* Lấy 8 dòng dữ liệu Hub được thêm gần đây */
  try {
    final response = await http.get(
      Uri.parse('$url/orders/status/hub?status=$status&hubId=$hubId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => OrderDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recent hubs');
    }
  } catch (e) {
    print('Error during queryOrder: $e');
    throw Exception('An error occurred during queryOrder');
  }
}

Future<List<OrderDto>> searchOrderWithNumberRowIgnoreWithStatus({
  required String status,
  required String str,
  required int numberRowIgnore,
}) async {
  try {
    final response = await http.get(
      Uri.parse(
          '$url/order/search/status?status=$status&search=$str&numberRowIgnore=$numberRowIgnore'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => OrderDto.fromJson(json)).toList();
    } else {
      // Handle non-200 responses with more context
      final error = jsonDecode(response.body);
      throw Exception(
          'Failed to update: ${error['message'] ?? 'Unknown error'}');
    }
  } catch (e) {
    throw Exception('An error occurred during searchOrderWithNumberRowIgnore');
  }
}

Future<int> queryCountOrderWithStatus({required String status}) async {
  try {
    final response = await http.get(
      Uri.parse('$url/orders/count/status?status=$status'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['count'] as int;
    } else {
      throw Exception('Failed to load recent orders');
    }
  } catch (e) {
    print('Error during queryCountOrder: $e');
    throw Exception('An error occurred during queryCountOrder');
  }
}

Future<int> queryCountOrderSearchWithStatus(String str, String status) async {
  try {
    final response = await http.get(
      Uri.parse('$url/order/search/count/status?status=$status&search=$str'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['count'] as int;
    } else {
      throw Exception('Failed to load recent orders');
    }
  } catch (e) {
    print('Error during queryCountOrderSearch: $e');
    throw Exception('An error occurred during queryCountOrderSearch');
  }
}

//
// DELIVERY
//

Future<List<DeliveryDto>> queryDeliverWithStatusByHubId({
  required String status,
  required String hubId,
}) async {
  /* Lấy 8 dòng dữ liệu Hub được thêm gần đây */
  try {
    final response = await http.get(
      Uri.parse('$url/deliveries/status/hub?status=$status&hubId=$hubId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => DeliveryDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recent hubs');
    }
  } catch (e) {
    print('Error during queryOrder: $e');
    throw Exception('An error occurred during queryOrder');
  }
}

//
// ASSIGN
//

Future<int> assignOrderByHubId({required String hubId}) async {
  try {
    final response = await http.post(
      Uri.parse('https://waseminarcnpm2.azurewebsites.net/protected/assign'),
      headers: headers,
      body: jsonEncode({
        'hubId': hubId,
      }),
    );
    return response.statusCode;
    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body) as Map<String, dynamic>;
    //   return data.map((json) => Delivery.fromJson(json)).toList();
    // } else {
    //   throw Exception('Failed to load recent users');
    // }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during queryUserHub');
  }
}

//
// STAFF
//

Future<List<StaffDto>> searchAllStaffByHubId(String str, String hubId) async {
  try {
    final response = await http.get(
      Uri.parse('$url/staffs/search/hub?hubId=$hubId&search=$str'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => StaffDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load searchAllOrderByHubId');
    }
  } catch (e) {
    print('Error during queryHub: $e');
    throw Exception('An error occurred during searchAllOrderByHubId');
  }
}

Future<List<StaffDto>> queryStaffWithHubId({
  required String hubId,
}) async {
  /* Lấy 8 dòng dữ liệu Hub được thêm gần đây */
  try {
    final response = await http.get(
      Uri.parse('$url/staffs/hub?hubId=$hubId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((json) => StaffDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load queryStaffWithHubId');
    }
  } catch (e) {
    print('Error during queryOrder: $e');
    throw Exception('An error occurred during queryStaffWithHubId');
  }
}
