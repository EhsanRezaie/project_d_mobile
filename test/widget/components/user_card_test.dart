import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/models/discover_profile.dart';
import 'package:dating_app/providers/settings_provider.dart';
import 'package:dating_app/widgets/user_card.dart';
import '../../helpers/test_helpers.dart';
import '../../helpers/fixtures.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  String iso(int daysAgo) =>
      DateTime.now().toUtc().subtract(Duration(days: daysAgo)).toIso8601String();

  Future<void> pumpCard(WidgetTester tester, {String? createdAt}) async {
    await tester.pumpWidget(
      buildTestable(
        UserCard(
          profile: DiscoverProfile.fromJson(
            jsonDiscoverProfile(mainPhotoUrl: null, photos: [], createdAt: createdAt),
          ),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
      ),
    );
    await tester.pump();
  }

  testWidgets('shows the New Here badge for a profile under one week old',
      (tester) async {
    await pumpCard(tester, createdAt: iso(3));

    expect(find.text('New Here'), findsOneWidget);
  });

  testWidgets('hides the badge when the profile is older than a week',
      (tester) async {
    await pumpCard(tester, createdAt: iso(10));

    expect(find.text('New Here'), findsNothing);
  });

  testWidgets('hides the badge when created_at is missing', (tester) async {
    await pumpCard(tester, createdAt: null);

    expect(find.text('New Here'), findsNothing);
  });
}
