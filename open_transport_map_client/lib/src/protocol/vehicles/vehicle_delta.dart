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
import 'package:open_transport_map_client/src/protocol/protocol.dart'
    as _i3vnrsdz;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../vehicles/vehicle_position.dart' as _iz6cga7q;

abstract class VehicleDelta
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      updated: _i3vnrsdz.Protocol()
          .deserialize<List<_iz6cga7q.VehiclePosition>>(
            jsonSerialization['updated'],
          ),
      removed: _i3vnrsdz.Protocol().deserialize<List<String>>(
        jsonSerialization['removed'],
      ),
    );
  }

  List<_iz6cga7q.VehiclePosition> updated;

  List<String> removed;

  /// Returns a shallow copy of this [VehicleDelta]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
