// flutter_api_routes.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class ApiRoutes {
  static const String baseUrl = 'https://your-backend.com'; // Replace with your backend URL
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's Firebase token
  Future<String?> _getToken() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  // Get current user's Firebase UID
  String? _getFirebaseUid() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  // ==================== AUTH ROUTES ====================
  
  /// Create anonymous Firebase user
  Future<ApiResponse<String>> createAnonymousUser() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      
      if (user != null) {
        String idToken = await user.getIdToken();
        return ApiResponse.success(idToken);
      }
      return ApiResponse.error('Failed to create anonymous user');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Verify Firebase token with backend
  Future<ApiResponse<Map<String, dynamic>>> verifyToken(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(json.decode(response.body));
      }
      return ApiResponse.error('Token verification failed');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // ==================== USER ROUTES ====================

  /// Create user profile in database
  Future<ApiResponse<UserProfile>> createUser({
    required String name,
    required String surname,
    required String phoneNumber,
    required String idToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'surname': surname,
          'phoneNumber': phoneNumber,
          'idToken': idToken,
        }),
      );

      if (response.statusCode == 201) {
        return ApiResponse.success(UserProfile.fromJson(json.decode(response.body)));
      }
      return ApiResponse.error('Failed to create user: ${response.body}');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // ==================== DRIVER REQUEST ROUTES ====================

  /// Create driver request
  Future<ApiResponse<DriverRequest>> createDriverRequest({
    required String location,
    required bool fromOzu,
    required DateTime datetime,
    required int offset,
  }) async {
    try {
      String? token = await _getToken();
      String? firebaseUid = _getFirebaseUid();
      
      if (token == null) return ApiResponse.error('No authentication token');
      if (firebaseUid == null) return ApiResponse.error('No Firebase UID');

      final response = await http.post(
        Uri.parse('$baseUrl/driver-requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'firebaseUid': firebaseUid,
          'location': location,
          'fromOzu': fromOzu,
          'datetime': datetime.toIso8601String(),
          'offset': offset,
        }),
      );

      if (response.statusCode == 201) {
        return ApiResponse.success(DriverRequest.fromJson(json.decode(response.body)));
      }
      return ApiResponse.error('Failed to create driver request: ${response.body}');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get all driver requests
  Future<ApiResponse<List<DriverRequestWithUser>>> getDriverRequests() async {
    try {
      String? token = await _getToken();
      if (token == null) return ApiResponse.error('No authentication token');

      final response = await http.get(
        Uri.parse('$baseUrl/driver-requests'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<DriverRequestWithUser> requests = jsonList
            .map((json) => DriverRequestWithUser.fromJson(json))
            .toList();
        return ApiResponse.success(requests);
      }
      return ApiResponse.error('Failed to get driver requests: ${response.body}');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Delete driver request
  Future<ApiResponse<bool>> deleteDriverRequest(int requestId) async {
    try {
      String? token = await _getToken();
      if (token == null) return ApiResponse.error('No authentication token');

      final response = await http.delete(
        Uri.parse('$baseUrl/driver-requests/$requestId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        return ApiResponse.success(true);
      }
      return ApiResponse.error('Failed to delete driver request: ${response.body}');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // ==================== PASSENGER REQUEST ROUTES ====================

  /// Create passenger request
  Future<ApiResponse<PassengerRequest>> createPassengerRequest({
    required String location,
    required bool fromOzu,
    required DateTime datetime,
    required int offset,
    required bool taxi,
    required bool carpool,
  }) async {
    try {
      String? token = await _getToken();
      String? firebaseUid = _getFirebaseUid();
      
      if (token == null) return ApiResponse.error('No authentication token');
      if (firebaseUid == null) return ApiResponse.error('No Firebase UID');

      final response = await http.post(
        Uri.parse('$baseUrl/passenger-requests'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'firebaseUid': firebaseUid,
          'location': location,
          'fromOzu': fromOzu,
          'datetime': datetime.toIso8601String(),
          'offset': offset,
          'taxi': taxi,
          'carpool': carpool,
        }),
      );

      if (response.statusCode == 201) {
        return ApiResponse.success(PassengerRequest.fromJson(json.decode(response.body)));
      }
      return ApiResponse.error('Failed to create passenger request: ${response.body}');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get all passenger requests
  Future<ApiResponse<List<PassengerRequestWithUser>>> getPassengerRequests() async {
    try {
      String? token = await _getToken();
      if (token == null) return ApiResponse.error('No authentication token');

      final response = await http.get(
        Uri.parse('$baseUrl/passenger-requests'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<PassengerRequestWithUser> requests = jsonList
            .map((json) => PassengerRequestWithUser.fromJson(json))
            .toList();
        return ApiResponse.success(requests);
      }
      return ApiResponse.error('Failed to get passenger requests: ${response.body}');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get passenger request by Firebase UID
  Future<ApiResponse<PassengerRequestWithUser>> getPassengerRequestByFirebaseUid(String firebaseUid) async {
    try {
      String? token = await _getToken();
      if (token == null) return ApiResponse.error('No authentication token');

      final response = await http.get(
        Uri.parse('$baseUrl/passenger-requests/$firebaseUid'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(PassengerRequestWithUser.fromJson(json.decode(response.body)));
      }
      return ApiResponse.error('Failed to get passenger request: ${response.body}');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Get current user's passenger request
  Future<ApiResponse<PassengerRequestWithUser>> getCurrentUserPassengerRequest() async {
    String? firebaseUid = _getFirebaseUid();
    if (firebaseUid == null) return ApiResponse.error('No Firebase UID');
    
    return getPassengerRequestByFirebaseUid(firebaseUid);
  }

  /// Delete passenger request
  Future<ApiResponse<bool>> deletePassengerRequest(int requestId) async {
    try {
      String? token = await _getToken();
      if (token == null) return ApiResponse.error('No authentication token');

      final response = await http.delete(
        Uri.parse('$baseUrl/passenger-requests/$requestId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 204) {
        return ApiResponse.success(true);
      }
      return ApiResponse.error('Failed to delete passenger request: ${response.body}');
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // ==================== COMPLETE USER FLOW ====================

  /// Complete user creation flow (Firebase + Database)
  Future<ApiResponse<CompleteUser>> createCompleteUser({
    required String name,
    required String surname,
    required String phoneNumber,
  }) async {
    try {
      // Step 1: Create Firebase anonymous user
      final firebaseResult = await createAnonymousUser();
      if (!firebaseResult.success) {
        return ApiResponse.error('Failed to create Firebase user: ${firebaseResult.error}');
      }

      String idToken = firebaseResult.data!;

      // Step 2: Create user profile in database
      final userResult = await createUser(
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        idToken: idToken,
      );

      if (!userResult.success) {
        return ApiResponse.error('Failed to create user profile: ${userResult.error}');
      }

      return ApiResponse.success(CompleteUser(
        firebaseToken: idToken,
        userProfile: userResult.data!,
      ));
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}

// ==================== DATA MODELS ====================

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ApiResponse.success(this.data) : success = true, error = null;
  ApiResponse.error(this.error) : success = false, data = null;
}

class UserProfile {
  final int userId;
  final String firebaseUid;
  final String name;
  final String surname;
  final String phoneNumber;

  UserProfile({
    required this.userId,
    required this.firebaseUid,
    required this.name,
    required this.surname,
    required this.phoneNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'],
      firebaseUid: json['firebaseUid'],
      name: json['name'],
      surname: json['surname'],
      phoneNumber: json['phoneNumber'].toString(),
    );
  }
}

class DriverRequest {
  final int id;
  final String firebaseUid;
  final String location;
  final bool fromOzu;
  final DateTime datetime;
  final int offset;

  DriverRequest({
    required this.id,
    required this.firebaseUid,
    required this.location,
    required this.fromOzu,
    required this.datetime,
    required this.offset,
  });

  factory DriverRequest.fromJson(Map<String, dynamic> json) {
    return DriverRequest(
      id: json['id'],
      firebaseUid: json['firebaseUid'],
      location: json['location'],
      fromOzu: json['fromOzu'],
      datetime: DateTime.parse(json['datetime']),
      offset: json['offset'],
    );
  }
}

class DriverRequestWithUser {
  final int id;
  final String location;
  final bool fromOzu;
  final DateTime datetime;
  final int offset;
  final String name;
  final String surname;
  final String phoneNumber;

  DriverRequestWithUser({
    required this.id,
    required this.location,
    required this.fromOzu,
    required this.datetime,
    required this.offset,
    required this.name,
    required this.surname,
    required this.phoneNumber,
  });

  factory DriverRequestWithUser.fromJson(Map<String, dynamic> json) {
    return DriverRequestWithUser(
      id: json['id'],
      location: json['location'],
      fromOzu: json['fromOzu'],
      datetime: DateTime.parse(json['datetime']),
      offset: json['offset'],
      name: json['name'],
      surname: json['surname'],
      phoneNumber: json['phoneNumber'].toString(),
    );
  }
}

class PassengerRequest {
  final int id;
  final String firebaseUid;
  final String location;
  final bool fromOzu;
  final DateTime datetime;
  final int offset;
  final bool taxi;
  final bool carpool;

  PassengerRequest({
    required this.id,
    required this.firebaseUid,
    required this.location,
    required this.fromOzu,
    required this.datetime,
    required this.offset,
    required this.taxi,
    required this.carpool,
  });

  factory PassengerRequest.fromJson(Map<String, dynamic> json) {
    return PassengerRequest(
      id: json['id'],
      firebaseUid: json['firebaseUid'],
      location: json['location'],
      fromOzu: json['fromOzu'],
      datetime: DateTime.parse(json['datetime']),
      offset: json['offset'],
      taxi: json['taxi'],
      carpool: json['carpool'],
    );
  }
}

class PassengerRequestWithUser {
  final int id;
  final String location;
  final bool fromOzu;
  final DateTime datetime;
  final int offset;
  final bool taxi;
  final bool carpool;
  final String name;
  final String surname;
  final String phoneNumber;

  PassengerRequestWithUser({
    required this.id,
    required this.location,
    required this.fromOzu,
    required this.datetime,
    required this.offset,
    required this.taxi,
    required this.carpool,
    required this.name,
    required this.surname,
    required this.phoneNumber,
  });

  factory PassengerRequestWithUser.fromJson(Map<String, dynamic> json) {
    return PassengerRequestWithUser(
      id: json['id'],
      location: json['location'],
      fromOzu: json['fromOzu'],
      datetime: DateTime.parse(json['datetime']),
      offset: json['offset'],
      taxi: json['taxi'],
      carpool: json['carpool'],
      name: json['name'],
      surname: json['surname'],
      phoneNumber: json['phoneNumber'].toString(),
    );
  }
}

class CompleteUser {
  final String firebaseToken;
  final UserProfile userProfile;

  CompleteUser({
    required this.firebaseToken,
    required this.userProfile,
  });
}

// ==================== ENUMS ====================

enum Location {
  cekmekoy,
  sabiha,
  sile,
  kadikoy,
  emlak,
  karsi,
  other,
}

extension LocationExtension on Location {
  String get value {
    switch (this) {
      case Location.cekmekoy:
        return 'Cekmekoy';
      case Location.sabiha:
        return 'Sabiha';
      case Location.sile:
        return 'Sile';
      case Location.kadikoy:
        return 'Kadikoy';
      case Location.emlak:
        return 'Emlak';
      case Location.karsi:
        return 'Karsi';
      case Location.other:
        return 'Other';
    }
  }

  static Location fromString(String value) {
    switch (value) {
      case 'Cekmekoy':
        return Location.cekmekoy;
      case 'Sabiha':
        return Location.sabiha;
      case 'Sile':
        return Location.sile;
      case 'Kadikoy':
        return Location.kadikoy;
      case 'Emlak':
        return Location.emlak;
      case 'Karsi':
        return Location.karsi;
      case 'Other':
        return Location.other;
      default:
        return Location.other;
    }
  }
}

// ==================== USAGE EXAMPLES ====================

class ApiUsageExamples {
  final ApiRoutes api = ApiRoutes();

  /// Example: Create a complete user
  Future<void> createUserExample() async {
    final result = await api.createCompleteUser(
      name: 'John',
      surname: 'Doe',
      phoneNumber: '1234567890',
    );

    if (result.success) {
      print('User created successfully!');
      print('Firebase Token: ${result.data!.firebaseToken}');
      print('User ID: ${result.data!.userProfile.userId}');
    } else {
      print('Error: ${result.error}');
    }
  }

  /// Example: Create a driver request
  Future<void> createDriverRequestExample() async {
    final result = await api.createDriverRequest(
      location: Location.cekmekoy.value,
      fromOzu: true,
      datetime: DateTime.now().add(Duration(hours: 2)),
      offset: 15,
    );

    if (result.success) {
      print('Driver request created with ID: ${result.data!.id}');
    } else {
      print('Error: ${result.error}');
    }
  }

  /// Example: Get all driver requests
  Future<void> getDriverRequestsExample() async {
    final result = await api.getDriverRequests();

    if (result.success) {
      for (var request in result.data!) {
        print('Driver: ${request.name} ${request.surname}');
        print('Location: ${request.location}');
        print('Phone: ${request.phoneNumber}');
        print('---');
      }
    } else {
      print('Error: ${result.error}');
    }
  }

  /// Example: Create a passenger request
  Future<void> createPassengerRequestExample() async {
    final result = await api.createPassengerRequest(
      location: Location.sabiha.value,
      fromOzu: false,
      datetime: DateTime.now().add(Duration(hours: 3)),
      offset: 30,
      taxi: true,
      carpool: false,
    );

    if (result.success) {
      print('Passenger request created with ID: ${result.data!.id}');
    } else {
      print('Error: ${result.error}');
    }
  }
}