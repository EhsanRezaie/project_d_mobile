// lib/services/interest_localizer.dart
import 'package:dating_app/models/interest.dart';

/// In-memory catalog of localized interest labels, populated whenever the app
/// fetches `/interests` (onboarding / edit pickers). Profile badges resolve a
/// stable interest name to the viewer's language through here, falling back to
/// the raw key (humanized) when the catalog hasn't been loaded yet.
class InterestLocalizer {
  InterestLocalizer._();

  static final InterestLocalizer instance = InterestLocalizer._();

  Map<String, String> _names = {};
  Map<String, String> _categories = {};
  String _language = '';

  String get language => _language;

  void load(List<Interest> interests, {String language = 'en'}) {
    _names = {};
    _categories = {};
    for (final i in interests) {
      if (i.nameLocalized != null && i.nameLocalized!.isNotEmpty) {
        _names[i.name] = i.nameLocalized!;
      }
      if (i.categoryLocalized != null && i.categoryLocalized!.isNotEmpty) {
        _categories[i.category] = i.categoryLocalized!;
      }
    }
    _language = language;
  }

  String name(String key) {
    final label = _names[key];
    if (label != null && label.isNotEmpty) return label;
    return _humanize(key);
  }

  String category(String key) {
    final label = _categories[key];
    if (label != null && label.isNotEmpty) return label;
    return _humanize(key);
  }

  void clear() {
    _names = {};
    _categories = {};
    _language = '';
  }

  String _humanize(String value) {
    if (value.isEmpty) return value;
    return value
        .split(RegExp(r'[_/\s]+'))
        .where((w) => w.isNotEmpty)
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}
