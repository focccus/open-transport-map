import 'transit_provider_adapter.dart';

class TransitAdapterRegistry {
  static final Map<String, TransitProviderAdapter> _adapters = {};

  static void register(TransitProviderAdapter adapter) {
    _adapters[adapter.agencyExternalId] = adapter;
  }

  static TransitProviderAdapter get(String agencyExternalId) {
    final adapter = _adapters[agencyExternalId];
    if (adapter == null) {
      throw ArgumentError(
        'No adapter registered for agency: $agencyExternalId',
      );
    }
    return adapter;
  }

  static bool has(String agencyExternalId) =>
      _adapters.containsKey(agencyExternalId);

  static List<String> get registeredAgencies => _adapters.keys.toList();
}
