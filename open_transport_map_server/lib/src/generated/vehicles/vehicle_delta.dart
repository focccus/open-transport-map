/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:open_transport_map_server/src/generated/protocol.dart'
    as _imkmox2w;
import 'package:serverpod/serverpod.dart' as _is;
import '../vehicles/vehicle_position.dart' as _iz6cga7q;

abstract class VehicleDelta
    implements _is.SerializableModel, _is.ProtocolSerialization {
  VehicleDelta._({
    required this.updated,
    required this.removed,
  });

  factory VehicleDelta({
    required List<_iz6cga7q.VehiclePosition> updated,
    required List<String> removed,
  }) = _VehicleDeltaImpl;

  factory VehicleDelta.fromJson(Map<String, dynamic> jsonSerialization) {
    return VehicleDelta(
      updated: _imkmox2w.Protocol()
          .deserialize<List<_iz6cga7q.VehiclePosition>>(
            jsonSerialization['updated'],
          ),
      removed: _imkmox2w.Protocol().deserialize<List<String>>(
        jsonSerialization['removed'],
      ),
    );
  }

  List<_iz6cga7q.VehiclePosition> updated;

  List<String> removed;

  /// Returns a shallow copy of this [VehicleDelta]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VehicleDelta copyWith({
    List<_iz6cga7q.VehiclePosition>? updated,
    List<String>? removed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VehicleDelta',
      'updated': updated.toJson(valueToJson: (v) => v.toJson()),
      'removed': removed.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VehicleDelta',
      'updated': updated.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'removed': removed.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _VehicleDeltaImpl extends VehicleDelta {
  _VehicleDeltaImpl({
    required List<_iz6cga7q.VehiclePosition> updated,
    required List<String> removed,
  }) : super._(
         updated: updated,
         removed: removed,
       );

  /// Returns a shallow copy of this [VehicleDelta]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VehicleDelta copyWith({
    List<_iz6cga7q.VehiclePosition>? updated,
    List<String>? removed,
  }) {
    return VehicleDelta(
      updated: updated ?? this.updated.map((e0) => e0.copyWith()).toList(),
      removed: removed ?? this.removed.map((e0) => e0).toList(),
    );
  }
}
