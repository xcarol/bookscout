import 'package:bookscout/utils/url_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:bookscout/l10n/app_localizations.dart';
import 'package:bookscout/services/settings/language_service.dart';
import 'package:bookscout/utils/app_constants.dart';
import 'package:bookscout/widgets/dialogs_and_forms/language_form.dart';
import 'package:bookscout/widgets/dialogs_and_forms/location_form.dart';
import 'package:bookscout/services/settings/location_service.dart';
import 'package:bookscout/screens/logs_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _headerTile(context),
          _languageTile(context),
          _locationTile(context),
          const Divider(),
          _aboutTile(context),
        ],
      ),
    );
  }

  Widget _headerTile(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return DrawerHeader(
      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: theme.colorScheme.primary,
            child: Icon(
              Icons.auto_stories,
              size: 32,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'BookScout',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          if (l10n != null)
            Text(
              l10n.appTagline,
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onPrimaryContainer.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _languageTile(BuildContext context) {
    final languageProvider = Provider.of<LanguageService>(context);

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(AppLocalizations.of(context)!.language),
      subtitle: Text(
        _getLanguageLabel(context, languageProvider.currentLanguage),
      ),
      onTap: () async {
        final String? selectedLanguage = await showDialog<String>(
          context: context,
          builder: (context) {
            return LanguageForm(
              currentLanguage: languageProvider.currentLanguage,
            );
          },
        );

        if (selectedLanguage != null &&
            selectedLanguage != languageProvider.currentLanguage) {
          languageProvider.setLanguage(selectedLanguage);
        }
      },
    );
  }

  Widget _locationTile(BuildContext context) {
    final locationService = context.watch<LocationService>();
    final l10n = AppLocalizations.of(context)!;

    String subtitle = l10n.setLocation;
    if (locationService.currentCountry != null) {
      subtitle = _getCountryLabel(locationService.currentCountry!);
      if (locationService.currentRegion != null) {
        subtitle += ' - ${locationService.currentRegion}';
      }
    }

    return ListTile(
      leading: const Icon(Icons.location_on),
      title: Text(l10n.locationLabel),
      subtitle: Text(subtitle),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => const LocationForm(),
        );
      },
    );
  }

  String _getCountryLabel(String countryCode) {
    return AppConstants.countryNames[countryCode] ?? countryCode;
  }

  String _getLanguageLabel(BuildContext context, String langCode) {
    final l10n = AppLocalizations.of(context)!;
    if (langCode.startsWith('ca')) return l10n.catalan;
    if (langCode.startsWith('es')) return l10n.spanish;
    if (langCode.startsWith('en')) return l10n.english;
    return langCode;
  }

  Widget _aboutTile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AboutListTile(
      icon: const Icon(Icons.info_outline),
      applicationName: 'BookScout',
      applicationVersion: dotenv.env[AppConstants.appVersion] ?? '1.0.0',
      applicationIcon: Icon(
        Icons.auto_stories,
        size: 40,
        color: Theme.of(context).colorScheme.primary,
      ),
      aboutBoxChildren: [
        Text(AppLocalizations.of(context)!.aboutDescription),
        const SizedBox(height: 8),
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(text: AppLocalizations.of(context)!.aboutGithub),
              TextSpan(
                text: 'github',
                style: const TextStyle(decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      launchUrl(Uri.parse(UrlConstants.githubRepoUrl)),
              ),
            ],
          ),
        ),
        SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context)!.privacyDisclaimerPrefix,
              ),
              TextSpan(
                text: AppLocalizations.of(context)!.privacyDisclaimer,
                style: const TextStyle(decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(
                    Uri.parse(
                      'https://xcarol.github.io/bookscout/privacy.html',
                    ),
                  ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          AppLocalizations.of(context)!.apiDisclaimer,
          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 16),
        if (kDebugMode || dotenv.env[AppConstants.enableLogs] == 'true')
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close About dialog
                  Navigator.pop(context); // Close Drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogsScreen()),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('App logs'),
              ),
            ],
          ),
      ],
      child: Text(l10n.about),
    );
  }
}
