import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'generated/app_localizations.dart';
import 'config/app_constants.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/onboarding_provider.dart';
import 'providers/language_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load();
  
  ApiService.init();
  
  print('API URL: ${AppConstants.apiBaseUrl}');
  print('WS URL: ${AppConstants.wsBaseUrl}');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'AURA',
            theme: ThemeData(
              fontFamily: 'Inter',
              primaryColor: const Color(0xFF001F3F),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF001F3F),
              ),
              scaffoldBackgroundColor: const Color(0xFFFBF9F9),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            locale: languageProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}