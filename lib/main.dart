import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:toolboxes/screens/home.dart';
import 'package:toolboxes/screens/start.dart';
import 'package:toolboxes/utils/material_colors.dart';
import 'package:toolboxes/utils/palette.dart';
import 'package:toolboxes/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Setup language
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US', supportedLocales: ['en_US', 'sv']);

  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
            title: translate("app_name"),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              localizationDelegate
            ],
            supportedLocales: localizationDelegate.supportedLocales,
            locale: localizationDelegate.currentLocale,
            theme: ThemeData(
                primarySwatch: generateMaterialColor(Palette.primary)),
            home: const Main(),
            debugShowCheckedModeBanner: false));
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  bool authenticated() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Utils.appBar,
        body: authenticated()
            ? const Home()
            : const Start() // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
