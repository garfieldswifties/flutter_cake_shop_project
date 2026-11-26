// นำเข้า Carousel ข้อมูลร้าน และหน้ารายละเอียด
import 'package:carousel_slider/carousel_slider.dart';
import 'package:material_ui/material_ui.dart';

import '../models/cake_shop.dart';
import '../models/cake_shop_data.dart';
import 'cake_shop_detail_ui.dart';

class CakeShopListUI extends StatefulWidget {
  const CakeShopListUI({super.key});

  @override
  State<CakeShopListUI> createState() => _CakeShopListUIState();
}

class _CakeShopListUIState extends State<CakeShopListUI> {
  // ส่งร้านจากรายการผ่าน constructor ของหน้ารายละเอียด
  void openCakeShopDetail(CakeShop cakeShop) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CakeShopDetailUI(cakeShopShow: cakeShop),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF0000),
        title: const Text('สายด่วนกินเค้ก', style: TextStyle(fontSize: 26)),
        toolbarHeight: 66,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: LayoutBuilder(
              builder: (context, constraints) => Column(
                children: [
                  // แบนเนอร์เลื่อนอัตโนมัติและปัดเปลี่ยนภาพได้
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: CarouselSlider.builder(
                      itemCount: cakeShopBanners.length,
                      itemBuilder: (context, index, pageIndex) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            cakeShopBanners[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            semanticLabel: 'แบนเนอร์ร้านเค้ก ${index + 1}',
                          ),
                        ),
                      ),
                      options: CarouselOptions(
                        height: (constraints.maxWidth * .49)
                            .clamp(0.0, constraints.maxHeight * .52)
                            .toDouble(),
                        viewportFraction: .8,
                        autoPlay: !MediaQuery.disableAnimationsOf(context),
                        autoPlayInterval: const Duration(seconds: 3),
                      ),
                    ),
                  ),
                  // รายการร้านด้านล่างเลื่อนได้
                  Expanded(
                    child: ListView.separated(
                      itemCount: cakeShopData.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: Color(0xFFFED7DD)),
                      itemBuilder: (context, index) {
                        final cakeShop = cakeShopData[index];
                        final imageWidth = (constraints.maxWidth * .205)
                            .clamp(0.0, 88.0)
                            .toDouble();
                        return ListTile(
                          minTileHeight: 95,
                          minVerticalPadding: 23,
                          visualDensity: const VisualDensity(vertical: 1),
                          titleAlignment: ListTileTitleAlignment.center,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              cakeShop.image1,
                              width: imageWidth,
                              height: imageWidth * 2 / 3,
                              fit: BoxFit.cover,
                              excludeFromSemantics: true,
                            ),
                          ),
                          title: Text(
                            cakeShop.name,
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            cakeShop.phone.trim(),
                            style: const TextStyle(fontSize: 17),
                          ),
                          trailing: IconButton(
                            tooltip: 'รายละเอียด ${cakeShop.name}',
                            onPressed: () => openCakeShopDetail(cakeShop),
                            icon: const Icon(
                              Icons.info,
                              color: Color(0xFFD32F2F),
                              size: 28,
                            ),
                          ),
                          onTap: () => openCakeShopDetail(cakeShop),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
