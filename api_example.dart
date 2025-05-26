 import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://localhost:3000'; // Change if running on a device/emulator

// USER ENDPOINTS
Future<void> createUser() async {
  final response = await http.post(
    Uri.parse('$baseUrl/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'firebaseId': 'firebase-uid',
      'name': 'John',
      'surname': 'Doe',
      'phoneNumber': 1234567890,
    }),
  );
  print('Create User: \\n");
  print(response.body);
}

// PASSENGER REQUEST ENDPOINTS
Future<void> submitPassengerRequest() async {
  final response = await http.post(
    Uri.parse('$baseUrl/passenger-requests'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': 1,
      'location': 'Cekmekoy',
      'fromOzu': true,
      'datetime': DateTime.now().toIso8601String(),
      'offset': 0,
      'taxi': true,
      'carpool': false,
    }),
  );
  print('Submit Passenger Request: \\n");
  print(response.body);
}

Future<void> deletePassengerRequest(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/passenger-requests/$id'),
  );
  print('Delete Passenger Request: \\n");
  print(response.statusCode);
}

Future<void> getPassengerTaxiRequest(int userId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/passenger-requests/$userId'),
  );
  print('Get Passenger Taxi Request: \\n");
  print(response.body);
}

Future<void> getPassengerRequestList() async {
  final response = await http.get(
    Uri.parse('$baseUrl/passenger-requests'),
  );
  print('Get Passenger Request List: \\n");
  print(response.body);
}

// DRIVER REQUEST ENDPOINTS
Future<void> submitDriverRequest() async {
  final response = await http.post(
    Uri.parse('$baseUrl/driver-requests'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': 1,
      'location': 'Cekmekoy',
      'fromOzu': true,
      'datetime': DateTime.now().toIso8601String(),
      'offset': 0,
    }),
  );
  print('Submit Driver Request: \\n");
  print(response.body);
}

Future<void> deleteDriverRequest(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/driver-requests/$id'),
  );
  print('Delete Driver Request: \\n");
  print(response.statusCode);
}

Future<void> getDriverRequestList() async {
  final response = await http.get(
    Uri.parse('$baseUrl/driver-requests'),
  );
  print('Get Driver Request List: \\n");
  print(response.body);
}

// Example usage
void main() async {
  await createUser();
  await submitPassengerRequest();
  await getPassengerRequestList();
  await getPassengerTaxiRequest(1);
  await deletePassengerRequest(1);
  await submitDriverRequest();
  await getDriverRequestList();
  await deleteDriverRequest(1);
}
