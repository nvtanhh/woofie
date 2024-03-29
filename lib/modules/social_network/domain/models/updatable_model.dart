import 'dart:math';

import 'package:dcache/dcache.dart';
import 'package:get/get.dart';

abstract class UpdatableModel<T> {
  final dynamic internalId;

  T get updateSubjectValue => _updateChangeSubject.value as T;
  Rxn<T> get rxUpdateSubject => _updateChangeSubject;
  final Rxn<T> _updateChangeSubject = Rxn<T>();

  UpdatableModel(this.internalId) {
    notifyUpdate();
  }
  void resetObject() {
    updateFromJson(_updateChangeSubject.toJson() as Map<String, dynamic>);
  }

  void notifyUpdate() {
    _updateChangeSubject.value = this as T;
    _updateChangeSubject.refresh();
  }

  void update(Map json) {
    updateFromJson(json);
    notifyUpdate();
  }

  void updateFromJson(Map json);

  void dipose() {
    _updateChangeSubject.close();
  }
}

abstract class UpdatableModelFactory<T extends UpdatableModel> {
  SimpleCache<dynamic, T>? cache;
  String? key;

  UpdatableModelFactory({this.cache, this.key}) {
    cache ??= SimpleCache(storage: UpdatableModelSimpleStorage(size: 50));
    key ??= 'id';
  }

  T fromJson(Map<String, dynamic> json) {
    dynamic itemId;
    if (json.containsKey(key)) itemId = json[key];

    late UpdatableModel? item;
    if (itemId != null) {
      item = getItemWithIdFromCache(itemId);

      if (item != null) {
        item.update(json);
        addToCache(item as T);
        return item;
      }
    }

    item = makeFromJson(json);
    item.notifyUpdate();
    addToCache(item as T);
    return item;
  }

  T makeFromJson(Map<String, dynamic> json);

  T? getItemWithIdFromCache(dynamic itemId) {
    return cache!.get(itemId);
  }

  void addToCache(T item) {
    cache!.set(item.internalId, item);
  }

  void clearCache() {
    cache!.clear();
  }
}

class UpdatableModelSimpleStorage<K, V extends UpdatableModel>
    implements Storage<K, V> {
  static int maxInt = pow(2, 30) - 1 as int; // (for 32 bit OS)

  late Map<K, CacheEntry<K, V>> _internalMap;
  late int _size;

  UpdatableModelSimpleStorage({required int size}) {
    _size = size > maxInt ? maxInt : size;
    _internalMap = {};
  }

  @override
  CacheEntry<K, V>? operator [](K key) {
    final ce = _internalMap[key];
    return ce;
  }

  @override
  void operator []=(K key, CacheEntry<K, V> value) {
    _internalMap[key] = value;
  }

  @override
  void clear() {
    _internalMap.clear();
  }

  @override
  CacheEntry<K, V> get(K key) {
    return this[key]!;
  }

  @override
  Storage set(K key, CacheEntry<K, V> value) {
    this[key] = value;
    return this;
  }

  @override
  void remove(K key) {
    final CacheEntry<K, UpdatableModel> item = get(key);
    // https://stackoverflow.com/questions/49879438/dart-do-i-have-to-cancel-stream-subscriptions-and-close-streamsinks
    // item.value.dispose();
    _internalMap.remove(key);
  }

  @override
  int get length => _internalMap.length;

  @override
  bool containsKey(K key) {
    return _internalMap.containsKey(key);
  }

  @override
  List<K> get keys => _internalMap.keys.toList(growable: true);

  @override
  List<CacheEntry<K, V>> get values =>
      _internalMap.values.toList(growable: true);

  @override
  int get capacity => _size;
}

typedef UpdateCallback = void Function(Map json);
