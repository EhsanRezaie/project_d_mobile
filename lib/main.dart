import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'generated/app_localizations.dart';
import 'config/app_constants.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/onboarding_provider.dart';
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
      ],
      child: MaterialApp(
        title: 'Dating App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SplashScreen(),
      ),
    );
  }
}