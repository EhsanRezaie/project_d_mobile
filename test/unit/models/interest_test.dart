import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app/models/interest.dart';
import '../../helpers/fixtures.dart';

void main() {
  test('Interest.fromJson parses all fields', () {
    final i = interest();
    expect(i.id, 'i1');
    expect(i.name, 'Hiking');
    expect(i.category, 'Outdoor');
    expect(i.icon, isNull);
  });

  test('Interest defaults category and icon', () {
    final i = Interest.fromJson({'id': 'x', 'name': 'Y'});
    expect(i.category, '');
    expect(i.icon, isNull);
  });

  test('Interest.toJson round-trips', () {
    final original = interest();
    final round = Interest.fromJson(original.toJson());
    expect(round.id, original.id);
    expect(round.name, original.name);
    expect(round.category, original.category);
  });

  test('parses localized labels and exposes them', () {
    final i = Interest.fromJson({
      'id': 'i1',
      'name': 'football',
      'name_localized': 'فوتبال',
      'category': 'sports_fitness',
      'category_localized': 'ورزش و تناسب اندام',
      'icon': '🏈',
    });
    expect(i.label, 'فوتبال');
    expect(i.categoryLabel, 'ورزش و تناسب اندام');
    // Fallback to the stable key when no localization is present.
    final bare = Interest.fromJson({'id': 'x', 'name': 'yoga', 'category': 'sports_fitness'});
    expect(bare.label, 'yoga');
  });
}