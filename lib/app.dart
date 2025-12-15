import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/pending_approval_screen.dart';
import 'screens/home/main_screen.dart';

/// Main App Widget
class FamilleTreeApp extends StatelessWidget {
  const FamilleTreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arbre Familial',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(false),
      // Localization support for Arabic and French
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'), // French
        Locale('ar', 'SA'), // Arabic
      ],
      locale: const Locale('fr', 'FR'), // Default locale
      home: const AuthWrapper(),
    );
  }
}

/// Widget that handles authentication state and routing
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading spinner while checking auth state
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement...'),
                ],
              ),
            ),
          );
        }

        // Not logged in - show login screen
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        // Logged in but not approved - show pending screen
        if (!authProvider.isApproved) {
          return const PendingApprovalScreen();
        }

        // Logged in and approved - show main app
        return const MainScreen();
      },
    );
  }
}
