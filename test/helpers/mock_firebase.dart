// ignore_for_file: unused_field, override_on_non_overriding_member, always_specify_types, subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockDocumentSnapshotImpl
    implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  final bool exists = true;
  final Map<String, dynamic> _data = {'id': 'test_user', 'name': 'Test User'};

  @override
  Map<String, dynamic> data() => _data;

  @override
  dynamic get(Object field) => _data[field as String];

  @override
  dynamic operator [](Object field) => get(field);

  @override
  String get id => 'test_doc';

  @override
  SnapshotMetadata get metadata => MockSnapshotMetadata();

  @override
  DocumentReference<Map<String, dynamic>> get reference =>
      MockDocumentReferenceImpl();
}

class MockSnapshotMetadata implements SnapshotMetadata {
  @override
  bool get hasPendingWrites => false;

  @override
  bool get isFromCache => false;
}

class MockDocumentReferenceImpl
    implements DocumentReference<Map<String, dynamic>> {
  @override
  final String id = 'test_doc';
  final bool exists = true;
  final Map<String, dynamic> _data = <String, dynamic>{'id': 'test_doc'};

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([
    GetOptions? options,
  ]) async {
    return Future.value(MockDocumentSnapshotImpl());
  }

  @override
  Future<void> set(Map<String, dynamic> data, [SetOptions? options]) async {}

  @override
  Future<void> update(Map<Object, Object?> data) async {}

  @override
  Future<void> delete() async {}

  @override
  String get path => 'test_collection/test_doc';

  @override
  CollectionReference<Map<String, dynamic>> get parent =>
      MockCollectionReferenceImpl();

  @override
  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    return MockCollectionReferenceImpl();
  }

  @override
  FirebaseFirestore get firestore => MockFirebaseFirestore();

  @override
  DocumentReference<R> withConverter<R>({
    required FromFirestore<R> fromFirestore,
    required ToFirestore<R> toFirestore,
  }) {
    throw UnimplementedError();
  }

  // Alternative signature for compatibility with different Firestore versions
  Future<DocumentSnapshot<T>> withConverterOld<T>({
    required FromFirestore<T> fromFirestore,
    required ToFirestore<T> toFirestore,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots({
    bool includeMetadataChanges = false,
    ListenSource? source,
  }) {
    return Stream.fromFuture(get());
  }
}

class MockCollectionReferenceImpl
    implements CollectionReference<Map<String, dynamic>> {
  @override
  final String path = 'test_collection';

  @override
  Map<String, dynamic> get parameters => <String, dynamic>{};

  @override
  DocumentReference<Map<String, dynamic>> doc([String? path]) {
    return MockDocumentReferenceImpl();
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) async {
    return MockQuerySnapshot();
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>> add(
    Map<String, dynamic> data,
  ) async {
    return MockDocumentReferenceImpl();
  }

  @override
  String get id => 'test_collection';

  @override
  Query<Map<String, dynamic>> where(
    Object field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) {
    return this;
  }

  @override
  Query<Map<String, dynamic>> orderBy(Object field, {bool descending = false}) {
    return this;
  }

  @override
  Query<Map<String, dynamic>> limit(int limit) {
    return this;
  }

  @override
  DocumentReference<Map<String, dynamic>> get parent =>
      MockDocumentReferenceImpl();

  @override
  FirebaseFirestore get firestore => MockFirebaseFirestore();

  @override
  AggregateQuery count() {
    throw UnimplementedError();
  }

  // Based on error message, looks like your Firestore version has a different signature
  // Let's provide both versions to cover different Firestore versions

  // This is for newer versions of Firestore
  @override
  AggregateQuery aggregate(
    AggregateField aggregateField, [
    AggregateField? field2,
    AggregateField? field3,
    AggregateField? field4,
    AggregateField? field5,
    AggregateField? field6,
    AggregateField? field7,
    AggregateField? field8,
    AggregateField? field9,
    AggregateField? field10,
    AggregateField? field11,
    AggregateField? field12,
    AggregateField? field13,
    AggregateField? field14,
    AggregateField? field15,
    AggregateField? field16,
    AggregateField? field17,
    AggregateField? field18,
    AggregateField? field19,
    AggregateField? field20,
    AggregateField? field21,
    AggregateField? field22,
    AggregateField? field23,
    AggregateField? field24,
    AggregateField? field25,
    AggregateField? field26,
    AggregateField? field27,
    AggregateField? field28,
    AggregateField? field29,
    AggregateField? field30,
  ]) {
    throw UnimplementedError();
  }

  // This is for older versions of Firestore that have a different signature
  Future<AggregateQuerySnapshot> aggregateOld(AggregateQuery query) {
    throw UnimplementedError();
  }

  @override
  Query<Map<String, dynamic>> endAt(Iterable<Object?> values) {
    return this;
  }

  @override
  Query<Map<String, dynamic>> endBefore(Iterable<Object?> values) {
    return this;
  }

  @override
  Query<Map<String, dynamic>> endAtDocument(
    DocumentSnapshot<Object?> documentSnapshot,
  ) {
    return this;
  }

  @override
  Query<Map<String, dynamic>> endBeforeDocument(
    DocumentSnapshot<Object?> documentSnapshot,
  ) {
    return this;
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getDocuments([
    GetOptions? options,
  ]) {
    return get(options);
  }

  @override
  Query<Map<String, dynamic>> limitToLast(int limit) {
    return this;
  }

  @override
  Query<Map<String, dynamic>> startAfter(Iterable<Object?> values) {
    return this;
  }

  @override
  Query<Map<String, dynamic>> startAt(Iterable<Object?> values) {
    return this;
  }

  @override
  Query<Map<String, dynamic>> startAfterDocument(
    DocumentSnapshot<Object?> documentSnapshot,
  ) {
    return this;
  }

  @override
  Query<Map<String, dynamic>> startAtDocument(
    DocumentSnapshot<Object?> documentSnapshot,
  ) {
    return this;
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> snapshots({
    bool includeMetadataChanges = false,
    ListenSource? source,
  }) {
    return Stream.fromFuture(get());
  }

  @override
  CollectionReference<R> withConverter<R>({
    required FromFirestore<R> fromFirestore,
    required ToFirestore<R> toFirestore,
  }) {
    throw UnimplementedError();
  }
}

class MockQuerySnapshot implements QuerySnapshot<Map<String, dynamic>> {
  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => [
    MockQueryDocumentSnapshot(),
  ];

  @override
  List<DocumentChange<Map<String, dynamic>>> get docChanges => [];

  @override
  SnapshotMetadata get metadata => MockSnapshotMetadata();

  @override
  bool get empty => false;

  @override
  int get size => 1;
}

class MockQueryDocumentSnapshot
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  @override
  final bool exists = true;
  final Map<String, dynamic> _data = {'id': 'test_doc', 'data': 'test_data'};

  @override
  Map<String, dynamic> data() => _data;

  @override
  dynamic get(Object field) => _data[field as String];

  @override
  dynamic operator [](Object field) => get(field);

  @override
  String get id => 'test_doc';

  @override
  SnapshotMetadata get metadata => MockSnapshotMetadata();

  @override
  DocumentReference<Map<String, dynamic>> get reference =>
      MockDocumentReferenceImpl();
}
