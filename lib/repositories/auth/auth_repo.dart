import '/config/paths.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'base_auth_repo.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection(Paths.users);

  AppUser? _appUser(User? user) {
    if (user == null) return null;
    print('user phone number -- ${user.phoneNumber}');
    return AppUser(
      userId: user.uid,
      email: user.email,
    );
  }

  @override
  Stream<AppUser?> get onAuthChanges =>
      _firebaseAuth.userChanges().map((user) => _appUser(user));

  @override
  Future<AppUser?> get currentUser async => _appUser(_firebaseAuth.currentUser);

  String? get userImage => _firebaseAuth.currentUser?.photoURL;

  String? get userId => _firebaseAuth.currentUser?.uid;

  @override
  Future<AppUser?> loginInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) async {
    try {
      if (email != null && password != null) {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        return _appUser(userCredential.user);
      }
      return null;
    } on FirebaseAuthException catch (error) {
      print('Error code -- ${error.code}');
      //
      if (error.code == 'user-not-found') {
        throw Failure(
            code: error.code,
            message:
                'There is no user record corresponding to this identifier.');
      } else if (error.code == 'wrong-password') {
        throw Failure(code: error.code, message: 'The password is invalid');
      }

      //There is no user record corresponding to this identifier
      print('Login Error 1  ${error.message}');
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print('Login Error 2  ${error.toString()}');
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  @override
  Future<AppUser?> signUpWithEmailAndPassword({
    required String? email,
    required String? password,
  }) async {
    try {
      if (email != null && password != null) {
        final userCredentail = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        await userCredentail.user?.sendEmailVerification();
        return _appUser(userCredentail.user);
      }

      return null;
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  Future<bool?> checkPhoneNoExists({
    required String? phoneNo,
  }) async {
    try {
      if (phoneNo == null) {
        return true;
      }

      // final _userSnaps =
      //     await usersRef.where('mobileNumber', isEqualTo: state.username).get();

      // print('User lenght ------ ${_userSnaps.docs.length}');

      // if (_userSnaps.docs.isNotEmpty) {
      //   emit(state.copyWith(
      //       status: SignupStatus.error,
      //       failure: const Failure(message: 'Username already exists')));
      //   return;
      // }

      final userSnaps = await usersRef.get();
      final users = userSnaps.docs.where((element) {
        final data = element.data() as Map?;
        if (data != null) {
          return data['mobileNumber'] == phoneNo;
        }
        return false;
      }).toList();

      print('Users -- $users');

      return users.isNotEmpty;
    } catch (error) {
      print('Error in checking phone number ${error.toString()}');
      return false;
    }
  }

  @override
  Future<void>? resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw const Failure(message: 'Something went wrong.Try again');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
