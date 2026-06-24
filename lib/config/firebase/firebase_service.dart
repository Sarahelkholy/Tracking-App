import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../features/orders/domain/entities/enums/order_status_enum.dart';

@lazySingleton
class FirebaseService {
  final FirebaseFirestore _firestore;

  FirebaseService(this._firestore);

  // Get a reference to a collection
  CollectionReference<Map<String, dynamic>> getCollection(String path) {
    return _firestore.collection(path);
  }

  Future<Map<String, dynamic>> getCollectionWhere({
    required String path,
    required String field,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(path)
          .where(field, isNotEqualTo: OrderStatusEnum.delivered.name)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        print("firestore model is empty");
        return data;
      } else {
        print("firestore model is empty");
        return {};
      }
    } catch (e) {
      print("firebase exception ${e.toString()}");
      return {};
    }
  }

  // Get a reference to a document
  DocumentReference<Map<String, dynamic>> getDocument(String path) {
    return _firestore.doc(path);
  }

  // Add data to a collection
  Future<DocumentReference<Map<String, dynamic>>> addData(
    String collectionPath,
    Map<String, dynamic> data,
  ) {
    return _firestore.collection(collectionPath).add(data);
  }

  // Set data for a document
  Future<void> setData(
    String path,
    Map<String, dynamic> data, {
    bool merge = true,
  }) {
    return _firestore.doc(path).set(data, SetOptions(merge: merge));
  }

  // Update data for a document
  Future<void> updateData(String path, Map<String, dynamic> data) {
    return _firestore.doc(path).update(data);
  }

  // Delete a document
  Future<void> deleteData(String path) {
    return _firestore.doc(path).delete();
  }

  // Get a stream of a collection
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(String path) {
    return _firestore.collection(path).snapshots();
  }

  // Get a stream of a document
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
    String path,
  ) {
    return _firestore.doc(path).snapshots();
  }

  // Get data once
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentData(String path) {
    return _firestore.doc(path).get();
  }
}
