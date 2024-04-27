import 'package:brave/data/models/thought_model.dart';
import 'package:brave/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseServices {
  Future<void> addUserDataToFirestore(String documentId, Map<String, dynamic> data) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference collection = firestore.collection('user');
      DocumentReference document = collection.doc(documentId);
      DocumentSnapshot snapshot = await document.get();
      if (snapshot.exists) {
        print('Data already exist in Firestore');
      } else {
        await document.set(data);
        print('Data added to Firestore successfully!');
      }
    } catch (e) {
      print('Error interacting with Firestore: $e');
    }
  }
  Future<void> thoughtDailyQuery(String docID)async {
    final thoughts  = FirebaseFirestore.instance.collection('thoughts') ;
    try {
      QuerySnapshot querySnapshot = await thoughts.get();
      final today = DateTime.now();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs){
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        final model = ThoughtModel.fromJson(data);
        final diff = DateTime.now().difference(model.date);
        if(diff.inHours >= 24){
          await thoughts.doc(model.thoughtId.toString()).delete() ;
          print(diff) ;
        }
        print(diff) ;

      }
    }catch(E){

    }
  }
  Future<List<ThoughtModel>> getAllThoughts() async {
    final thoughts  = FirebaseFirestore.instance.collection('thoughts') ;
    try {
      List<ThoughtModel> list  = [];
      QuerySnapshot querySnapshot = await thoughts.get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        print("Document ID: ${documentSnapshot.id}, Data: $data");
        final model = ThoughtModel.fromJson(data);
        list.add(model) ;
      }
      return list ;
    } catch (e) {
      print('Error fetching documents: $e');
      return [] ;
    }
  }
  Future<UserModel?> getUserDetails()async{
    final _firebase = FirebaseAuth.instance;

    final uid = _firebase.currentUser!.uid;
    final _firestore = FirebaseFirestore.instance ;
    try {
      final document = await _firestore.collection('user').doc(uid).get();
      final json = document.data()!;
      print(json);
      final userModel = UserModel.fromJson(json);
      return userModel;
    }catch (E){

    }
  }
  Future<String> signUp(String email,String password)async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      return "success";
    }catch (e){
      return "error";
  }

}
  Future<String> addThoughtToFirestore(ThoughtModel model )async {
try{
  final _firestore = FirebaseFirestore.instance ;
  final _firebase = FirebaseAuth.instance ;
  final data = await _firestore.collection('user').doc(model.uid).get();
  final usermodel = UserModel.fromJson(data.data()!) ;
  final thoughts = usermodel.thoughts ;
  thoughts.add(model.thoughtId) ;
  final document  = _firestore.collection('thoughts');
  await document.doc(model.thoughtId).set(model.toJson()) ;
  await _firestore.collection('user').doc(model.uid).update({"thoughts": thoughts});
  return "Added SuccessFully" ;
}
catch (E){
  return E.toString() ;
}

  }
}

