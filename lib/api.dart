import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

Future<List<Map<String, dynamic>>> fetchPosts() async {
  final response =
  await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load posts');
  }
}

Future<bool> isConnected() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}
