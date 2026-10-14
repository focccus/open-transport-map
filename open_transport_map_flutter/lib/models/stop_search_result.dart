/// A stop area as the search presents it.
///
/// The search reads from the local cache, but falls back to the server while
/// the cache is empty, so both paths hand back this one shape.
class StopSearchResult {
  const StopSearchResult({
    required this.externalId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.municipality,
  });

  final String externalId;
  final String name;
  final double latitude;
  final double longitude;
  final String? municipality;
}
