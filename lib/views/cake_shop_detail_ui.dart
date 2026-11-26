// นำเข้า Material ไอคอน และเครื่องมือเปิดลิงก์
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/cake_shop.dart';
import '../widgets/cake_shop_map.dart';

class CakeShopDetailUI extends StatefulWidget {
  const CakeShopDetailUI({super.key, required this.cakeShopShow});

  final CakeShop cakeShopShow;

  @override
  State<CakeShopDetailUI> createState() => _CakeShopDetailUIState();
}

class _CakeShopDetailUIState extends State<CakeShopDetailUI> {
  // เปิดแอปภายนอกผ่าน URI ที่ผูกกับร้านที่เลือก
  Future<void> openLink(Uri uri) async {
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    } on PlatformException {
      // แจ้งผู้ใช้เมื่ออุปกรณ์ไม่มีแอปที่รองรับ
    }
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('อุปกรณ์นี้เปิดลิงก์ดังกล่าวไม่ได้')),
    );
  }

  // เก็บสัดส่วนรูปตามทรัพยากรรายวิชา
  Widget shopImage(String path, double width, String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        path,
        width: width,
        height: width * 2 / 3,
        fit: BoxFit.cover,
        semanticLabel: label,
      ),
    );
  }

  Widget shopInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  Widget linkTile(String url, Widget leading) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      minLeadingWidth: 24,
      minVerticalPadding: 8,
      leading: leading,
      title: Text(url, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.link),
      onTap: () => openLink(Uri.parse(url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cakeShop = widget.cakeShopShow;
    final phone = cakeShop.phone.trim();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF44336),
        leading: const BackButton(),
        title: Text(cakeShop.name),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageWidth = (constraints.maxWidth * .28)
                    .clamp(0.0, 120.0)
                    .toDouble();
                final sidePadding = constraints.maxWidth < 360 ? 18.0 : 28.0;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    sidePadding,
                    30,
                    sidePadding,
                    16,
                  ),
                  child: DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: 15, height: 1.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: shopImage(
                            cakeShop.image1,
                            imageWidth,
                            'รูปร้านภาพที่ 1',
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            shopImage(
                              cakeShop.image2,
                              imageWidth,
                              'รูปร้านภาพที่ 2',
                            ),
                            const SizedBox(width: 20),
                            shopImage(
                              cakeShop.image3,
                              imageWidth,
                              'รูปร้านภาพที่ 3',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        shopInfo('ชื่อร้าน 🏪', cakeShop.name),
                        shopInfo('เวลาเปิดปิด ⏰', cakeShop.openCloseTime),
                        shopInfo('รายละเอียดของร้าน 🍵', cakeShop.description),
                        shopInfo('ที่อยู่ของร้าน 🚩', cakeShop.address),
                        Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                            ),
                            onPressed: () =>
                                openLink(Uri(scheme: 'tel', path: phone)),
                            icon: const Icon(Icons.call, size: 17),
                            label: Text(phone),
                          ),
                        ),
                        linkTile(
                          cakeShop.website,
                          const Icon(Icons.language, color: Color(0xFFFFB300)),
                        ),
                        linkTile(
                          cakeShop.facebook,
                          const FaIcon(
                            FontAwesomeIcons.facebook,
                            size: 24,
                            color: Color(0xFF4285F4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        CakeShopMap(
                          latitude: double.parse(cakeShop.latitude),
                          longitude: double.parse(cakeShop.longitude),
                          onOpenLink: openLink,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
