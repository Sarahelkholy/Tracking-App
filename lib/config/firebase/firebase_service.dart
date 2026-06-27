import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flower_driver/config/error_handling/result.dart';
import 'package:injectable/injectable.dart';

import '../data_base/data_base_service.dart';

@LazySingleton(as: DatabaseService)
class FirebaseService implements DatabaseService {
  final FirebaseFirestore _firestore;

  FirebaseService(this._firestore);

  // Get a reference to a collection
  @override
  CollectionReference<Map<String, dynamic>> getCollection(String path) {
    return _firestore.collection(path);
  }

  @override
  Future<Result<Map<String, dynamic>>> getCollectionWhere({
    required String path,
    required String field,
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    int limit = 1,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(path);

      if (isEqualTo != null) {
        query = query.where(field, isEqualTo: isEqualTo);
      }

      if (isNotEqualTo != null) {
        query = query.where(field, isNotEqualTo: isNotEqualTo);
      }

      final snapshot = await query.limit(limit).get();

      return Success<Map<String, dynamic>>(data: snapshot.docs.first.data());
    } catch (e) {
      return Failure<Map<String, dynamic>>(errorMessage: e.toString());
    }
  }

  // Get a reference to a document
  @override
  DocumentReference<Map<String, dynamic>> getDocument(String path) {
    return _firestore.doc(path);
  }

  // Add data to a collection
  @override
  Future<DocumentReference<Map<String, dynamic>>> addData(
    String collectionPath,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collectionPath).add(data);
  }

  // Set data for a document
  @override
  Future<void> setData(
    String path,
    Map<String, dynamic> data, {
    bool merge = true,
  }) {
    return _firestore.doc(path).set(data, SetOptions(merge: merge));
  }

  // Update data for a document
  @override
  Future<void> updateData(String path, Map<String, dynamic> data) {
    return _firestore.doc(path).update(data);
  }

  // Delete a document
  @override
  Future<void> deleteData(String path) {
    return _firestore.doc(path).delete();
  }

  // Get a stream of a collection
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(String path) {
    return _firestore.collection(path).snapshots();
  }

  // Get a stream of a document
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
    String path,
  ) {
    return _firestore.doc(path).snapshots();
  }

  // Get data once
  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentData(String path) {
    return _firestore.doc(path).get();
  }

  @override
  Stream<Map<String, dynamic>?> listenDocument(String path) {
    return _firestore.doc(path).snapshots().map((event) => event.data());
  }
}
