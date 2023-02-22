// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_aggregate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectAggregate _$ObjectAggregateFromJson(Map<String, dynamic> json) =>
    ObjectAggregate(
      aggregate: Aggregate.fromJson(json['aggregate'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ObjectAggregateToJson(ObjectAggregate instance) =>
    <String, dynamic>{
      'aggregate': instance.aggregate.toJson(),
    };
