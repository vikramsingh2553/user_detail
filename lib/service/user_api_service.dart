import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_detail/model/user_model.dart';

class UserApiService {
  final String baseUrl = 'https://reqres.in/api/users';

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl?page=2'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body)['data'] as List;
      return jsonData.map((json) => UserModel(
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      )).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<UserModel> addUser(UserModel user) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
      }),
    );
    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return UserModel(
        id: jsonData['id'],
        email: user.email,
        firstName: jsonData['first_name'],
        lastName: jsonData['last_name'],
      );
    } else {
      throw Exception('Failed to add user');
    }
  }

  Future<UserModel> updateUser(UserModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserModel(
        id: user.id,
        email: jsonData['email'],
        firstName: jsonData['first_name'],
        lastName: jsonData['last_name'],
      );
    } else {
      throw Exception('Failed to update user');
    }
  }
Future<DeleteUserResponse> deleteUser(int userId) async {
  final response = await http.delete(Uri.parse('$baseUrl/$userId'));
  if (response.statusCode == 204) {
    return DeleteUserResponse(message: 'User deleted successfully');
  } else {
    throw Exception('Failed to delete user');
  }
}
}


class DeleteUserResponse {
  String? message;

  DeleteUserResponse({this.message});

  factory DeleteUserResponse.fromJson(Map<String, dynamic> json) {
    return DeleteUserResponse(
      message: json['message'],
    );
  }
}
