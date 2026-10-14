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
import 'package:serverpod/serverpod.dart' as _is;

abstract class RecentStopSearch
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RecentStopSearch._({
    this.id,
    required this.query,
    required this.searchedAt,
  });

  factory RecentStopSearch({
    int? id,
    required String query,
    required DateTime searchedAt,
  }) = _RecentStopSearchImpl;

  factory RecentStopSearch.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecentStopSearch(
      id: jsonSerialization['id'] as int?,
      query: jsonSerialization['query'] as String,
      searchedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['searchedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String query;

  DateTime searchedAt;

  /// Returns a shallow copy of this [RecentStopSearch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RecentStopSearch copyWith({
    int? id,
    String? query,
    DateTime? searchedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecentStopSearch',
      if (id != null) 'id': id,
      'query': query,
      'searchedAt': searchedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecentStopSearch',
      if (id != null) 'id': id,
      'query': query,
      'searchedAt': searchedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecentStopSearchImpl extends RecentStopSearch {
  _RecentStopSearchImpl({
    int? id,
    required String query,
    required DateTime searchedAt,
  }) : super._(
         id: id,
         query: query,
         searchedAt: searchedAt,
       );

  /// Returns a shallow copy of this [RecentStopSearch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RecentStopSearch copyWith({
    Object? id = _Undefined,
    String? query,
    DateTime? searchedAt,
  }) {
    return RecentStopSearch(
      id: id is int? ? id : this.id,
      query: query ?? this.query,
      searchedAt: searchedAt ?? this.searchedAt,
    );
  }
}
