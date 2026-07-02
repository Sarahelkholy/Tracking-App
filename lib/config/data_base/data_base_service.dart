import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseService {
  CollectionReference<Map<String, dynamic>> getCollection(String path);

  DocumentReference<Map<String, dynamic>> getDocument(String path);

  Future<Map<String, dynamic>> getCollectionWhere({
    required String path,
    required String field,
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    int limit = 1,
  });

  Future<DocumentReference<Map<String, dynamic>>> addData(
    String collectionPath,
    Map<String, dynamic> data,
  );

  Future<QuerySnapshot<Map<String, dynamic>>> getCollectionWhereMultiple({
    required String path,
    required Map<String, dynamic> queryParams,
    int limit = 1,
  });

  Future<void> setData(
    String path,
    Map<String, dynamic> data, {
    bool merge = true,
  });

  Future<void> updateData(String path, Map<String, dynamic> data);

  Future<void> deleteData(String path);

  Stream<QuerySnapshot<Map<String, dynamic>>> getCollectionStream(String path);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(String path);

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentData(String path);

  Stream<Map<String, dynamic>?> listenDocument(String path);
}
