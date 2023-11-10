// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_file_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class StreamFile extends _StreamFile
    with RealmEntity, RealmObjectBase, RealmObject {
  StreamFile(
    ObjectId id,
    String ownerId,
    String text,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set(this, 'text', text);
  }

  StreamFile._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

  @override
  String get text => RealmObjectBase.get<String>(this, 'text') as String;
  @override
  set text(String value) => RealmObjectBase.set(this, 'text', value);

  @override
  Stream<RealmObjectChanges<StreamFile>> get changes =>
      RealmObjectBase.getChanges<StreamFile>(this);

  @override
  StreamFile freeze() => RealmObjectBase.freezeObject<StreamFile>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(StreamFile._);
    return const SchemaObject(
        ObjectType.realmObject, StreamFile, 'StreamFile', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
      SchemaProperty('text', RealmPropertyType.string),
    ]);
  }
}
