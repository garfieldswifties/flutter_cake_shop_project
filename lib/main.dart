// นำเข้า Material และหน้าเปิดแอป
import 'package:material_ui/material_ui.dart';

import 'views/splash_screen_ui.dart';

void main() {
  runApp(const FlutterCakeShopApp());
}

class FlutterCakeShopApp extends StatelessWidget {
  const FlutterCakeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สายด่วนกินเค้ก',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kanit',
        scaffoldBackgroundColor: const Color(0xFFFEF7FF),
        appBarTheme: const AppBarThemeData(
          centerTitle: true,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      home: const SplashScreenUI(),
    );
  }
}
