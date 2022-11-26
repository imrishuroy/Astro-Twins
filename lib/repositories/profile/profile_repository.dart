import '/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/config/paths.dart';
import '/models/failure.dart';
import '/repositories/profile/base_profile_repo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileRepository extends BaseProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AppUser?> getUserProfile({
    required String? userId,
  }) async {
    print('user id $userId');
    try {
      if (userId == null) {
        return null;
      }
      final userSnap =
          await _firestore.collection(Paths.users).doc(userId).get();
      return AppUser.fromDocument(userSnap);
    } catch (error) {
      print('Error getting current profile user ${error.toString()}');
      throw const Failure(message: 'Error getting current user profile');
    }
  }

  Future<void> editProfileImage({required AppUser? user}) async {
    try {
      if (user == null) {
        return;
      }
      await _firestore
          .collection(Paths.users)
          .doc(user.userId)
          .update(user.toMap());
    } catch (error) {
      print('Error in editing profile image');
      throw const Failure(message: 'Error in edit profile image');
    }
  }

  Future<void> editProfile({required AppUser? user}) async {
    try {
      if (user == null) {
        return;
      }
      await _firestore
          .collection(Paths.users)
          .doc(user.userId)
          .update(user.toMap());
    } catch (error) {
      print('Error in edit profile ${error.toString()}');
      throw const Failure(message: 'Error in edit profile');
    }
  }

  Future<bool> checkNumberUsed({required String phNo}) async {
    try {
      print('Phone no - $phNo');
      final querySnaps = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phNo)
          .get();

      return querySnaps.docs.isNotEmpty;
    } catch (error) {
      print('Error in checking number used ${error.toString()}');
      throw const Failure(message: 'Error checking number used');
    }
  }

  Future<List<String>> getStateCities({required String state}) async {
    try {
      List<String> stateCities = [];
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      String url =
          'https://countriesnow.space/api/v0.1/countries/state/cities/q?country=India&state=$state';

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          final List cities = data['data'] ?? [];

          for (var element in cities) {
            if (element != null) {
              stateCities.add(element);
            }
          }
        }
      }
      return stateCities;
    } catch (error) {
      print('Error getting state cities ${error.toString()}');
      throw const Failure(message: 'Error getting cities');
    }
  }
}
