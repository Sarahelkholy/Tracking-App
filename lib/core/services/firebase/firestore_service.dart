import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreService {
  final db = FirebaseFirestore.instance;

}