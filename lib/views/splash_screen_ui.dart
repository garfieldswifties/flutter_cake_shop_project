// นำเข้า Material และหน้ารายการร้าน
import 'package:material_ui/material_ui.dart';

import 'cake_shop_list_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  void initState() {
    super.initState();
    openCakeShopList();
  }

  // เปลี่ยนหน้าเมื่อครบเวลาโดยแทนที่หน้าเปิดแอป
  Future<void> openCakeShopList() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (context) => const CakeShopListUI()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg_welcome.png', fit: BoxFit.cover),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  constraints.maxHeight * .14,
                  16,
                  16,
                ),
                child: Column(
                  children: [
                    const Text(
                      'สายด่วนกินเค้ก',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFEE1414),
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'CAKE CALL FAST',
                      style: TextStyle(
                        color: Color(0xFFEC5051),
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox.square(
                      dimension: 46,
                      child: CircularProgressIndicator(
                        color: Color(0xFF37454D),
                        semanticsLabel: 'กำลังเปิดรายการร้านเค้ก',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
