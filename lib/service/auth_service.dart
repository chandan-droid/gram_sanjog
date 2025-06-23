import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gram_sanjog/controller/auth/auth_controller.dart';


class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  // Sign up with Email & Password
  Future<UserCredential> signUp(String email, String password) {
    return auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Create user document in Firestore
  Future<void> createUserInFirestore(SignupData user,String Uid) async {
    final userDoc = firestore.collection('user').doc(Uid);
    await userDoc.set({
      'id': Uid,
      'name': user.name,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'whatsappNumber': user.whatsappNumber,
      'country': user.country,
      'state': user.state,
      'district': user.district,
      'block': user.block,
      'gpWard': user.gpWard,
      'villageAddress': user.villageAddress,
      'createdAt': FieldValue.serverTimestamp(),
      // Add more fields if needed (name, location etc.)
    });
  }

  // Login with Email & Password
  Future<UserCredential> login(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Logout
  Future<void> logout() async {
    await auth.signOut();
  }

  // Stream to track auth state
  Stream<User?> get userChanges => auth.authStateChanges();

  // Get current user
  User? get currentUser => auth.currentUser;
}
