import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home/home_screen.dart';
import 'constants.dart';
import 'screens/onboarding_screen.dart';
import 'card_state.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      theme: Theme.of(context).copyWith(
        primaryColor: yellow,
        accentColor: grey,
      ),
//      initialRoute: Home.id,
      initialRoute: OnboardingScreen.id,
      routes: {
        Home.id: (context) => ChangeNotifierProvider(
            create: (context) => CardState()..resetNewVariables(), child: Home()),
        OnboardingScreen.id: (context) => ChangeNotifierProvider(
            create: (context) => CardState(), child: OnboardingScreen()),
      },
    );
  }
}
