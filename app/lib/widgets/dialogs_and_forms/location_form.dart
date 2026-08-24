import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/services/settings/location_service.dart';
import 'package:bookscout/services/api/bookscout_api_service.dart';
import 'package:bookscout/utils/app_constants.dart';

class LocationForm extends StatefulWidget {
  const LocationForm({super.key});

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _locations = [];

  String? _selectedCountry;
  String? _selectedRegion;

  @override
  void initState() {
    super.initState();
    final locationService = context.read<LocationService>();
    _selectedCountry = locationService.currentCountry;
    _selectedRegion = locationService.currentRegion;
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    final locations = await BookScoutApiService().getLocations();
    if (mounted) {
      setState(() {
        _locations = locations;
        _isLoading = false;

        // Ensure selected country actually exists in the backend list
        if (_selectedCountry != null) {
          final countryExists = _locations.any(
            (l) => l['countryCode'] == _selectedCountry,
          );
          if (!countryExists) {
            _selectedCountry = null;
            _selectedRegion = null;
          } else {
            // Ensure selected region exists in the selected country
            final countryData = _locations.firstWhere(
              (l) => l['countryCode'] == _selectedCountry,
            );
            final regions = List<String>.from(countryData['regions'] ?? []);
            if (_selectedRegion != null && !regions.contains(_selectedRegion)) {
              _selectedRegion = null;
            }
          }
        }
      });
    }
  }

  String _getCountryLabel(String countryCode) {
    return AppConstants.countryNames[countryCode] ?? countryCode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        l10n.setLocation,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.country, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCountry,
                  hint: Text(l10n.country),
                  isExpanded: true,
                  items: _locations.map((loc) {
                    final code = loc['countryCode'] as String;
                    return DropdownMenuItem<String>(
                      value: code,
                      child: Text(_getCountryLabel(code)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                      _selectedRegion =
                          null; // Reset region when country changes
                    });
                  },
                ),
                const SizedBox(height: 20),

                if (_selectedCountry != null) ...[
                  Text(l10n.region, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final countryData = _locations.firstWhere(
                        (l) => l['countryCode'] == _selectedCountry,
                        orElse: () => {'regions': []},
                      );
                      final regions = List<String>.from(
                        countryData['regions'] ?? [],
                      );

                      if (regions.isEmpty) {
                        return Text(
                          'No regions required for this country',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }

                      return DropdownButtonFormField<String>(
                        key: ValueKey('region_$_selectedCountry'),
                        initialValue: _selectedRegion,
                        hint: Text(l10n.region),
                        isExpanded: true,
                        items: regions.map((r) {
                          return DropdownMenuItem<String>(
                            value: r,
                            child: Text(r),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRegion = value;
                          });
                        },
                      );
                    },
                  ),
                ],
              ],
            ),
      actions: [
        TextButton(
          onPressed: () {
            // Clear location entirely
            context.read<LocationService>().setLocation(null, null);
            Navigator.of(context).pop();
          },
          child: Text(l10n.clearLocation),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _isLoading
              ? null
              : () {
                  context.read<LocationService>().setLocation(
                    _selectedCountry,
                    _selectedRegion,
                  );
                  Navigator.of(context).pop();
                },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
