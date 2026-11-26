import 'dart:ui' as ui;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cake_shop_project/main.dart';
import 'package:flutter_cake_shop_project/models/cake_shop_data.dart';
import 'package:flutter_cake_shop_project/views/cake_shop_detail_ui.dart';
import 'package:flutter_cake_shop_project/views/cake_shop_list_ui.dart';
import 'package:flutter_cake_shop_project/views/splash_screen_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

// ค่าที่คัดจาก FIGMA_SPEC ส่วนข้อมูลบนบอร์ดและตรวจชื่อรูปกับ Resources
const referenceShops = [
  (
    name: 'Yellow Spoon Pastry',
    phone: '0854822842',
    address: 'โครงการเอกมัย คอมเพล็กซ์ (ระหว่างเอกมัย 19 และ 21)',
    hours: 'ทุกวัน 10.00-20.00 น.',
    descriptionStart: 'คาเฟ่ขนมหวานที่มีเบเกอรี่โฮมเมดสูตรน้ำตาลน้อย',
    website: 'https://www.yellowspoonpastry.com/',
    facebook: 'https://www.facebook.com/yspastry',
    lat: 13.736634,
    lon: 100.587512,
  ),
  (
    name: 'Vista Cafe by Verasu',
    phone: '022548100',
    address: 'อาคารวีรสุ ถนนวิทยุ',
    hours: 'ทุกวัน 09.00-19.00 น',
    descriptionStart: 'Vista Cafe by Verasu ร้านเบเกอรี่เพื่อคนรักสุขภาพ',
    website: 'http://www.vistacafe.co.th/',
    facebook: 'https://www.facebook.com/vistacafe',
    lat: 13.7403,
    lon: 100.547417,
  ),
  (
    name: 'Sweet Spell',
    phone: '0846666828',
    address: 'สี่แยกเหม่งจ๋าย ประชาอุทิศ19',
    hours: 'ทุกวัน 10.00-20.00 น. \n(หยุดทุกวันที่ 15 ของเดือน)',
    descriptionStart: 'ร้านเค้กเล็กๆ ที่ความอร่อยไม่เล็ก',
    website: 'http://www.sweetspell.com/dessert-menu/',
    facebook: 'https://www.facebook.com/sweetspellcafe',
    lat: 13.771741,
    lon: 100.586662,
  ),
  (
    name: 'Larna House',
    phone: '023215995',
    address: 'พัฒนาการ 61',
    hours: 'ทุกวัน 09.00-21.00 น.',
    descriptionStart: 'คิดถึงเค้กช็อกโกแลต ต้องนึกถึง Larna House',
    website: 'https://larnahouse.com/',
    facebook: 'https://www.facebook.com/%20larnahouse',
    lat: 13.730245,
    lon: 100.658385,
  ),
  (
    name: 'I bake & You take',
    phone: '0934499447',
    address: 'วิภาวดีรังสิต 60',
    hours: 'ทุกวัน 07.30-19.30 น.',
    descriptionStart: 'ร้านเค้กโฮมเมดสูตรดั้งเดิมต้นตำรับฝรั่งเศส',
    website: 'https://ibakeyoutake.com/',
    facebook: 'https://www.facebook.com/Ibakeyoutakebysine',
    lat: 13.864575,
    lon: 100.5823,
  ),
  (
    name: 'Coffee bean by dao',
    phone: '026109702',
    address: 'ชั้น G สยามพารากอน',
    hours: 'ทุกวัน 10.00-22.00 น.',
    descriptionStart: 'Coffee bean by dao ร้านเค้กแสนอร่อย',
    website: 'http://www.coffeebeans.co.th/',
    facebook: 'https://www.facebook.com/CoffeeBeansbyDao',
    lat: 13.7469267,
    lon: 100.5349883,
  ),
  (
    name: 'Bake Ministry',
    phone: '0891540474',
    address: 'สุขุมวิท 26',
    hours: '10.00-18.00 น. \n(หยุดวันอาทิตย์)',
    descriptionStart: 'ร้านเค้กสไตล์โฮมเมดที่เริ่มจาก Made to order',
    website: 'http://www.bakeministry.net/',
    facebook: 'https://www.facebook.com/bakeministry',
    lat: 13.7281129,
    lon: 100.5705757,
  ),
];

Finder assetImage(String path) => find.byWidgetPredicate(
  (widget) =>
      widget is Image &&
      widget.image is AssetImage &&
      (widget.image as AssetImage).assetName == 'assets/images/$path',
);

Finder get shopListScroll => find.descendant(
  of: find.byType(ListView),
  matching: find.byType(Scrollable),
);

void setViewport(WidgetTester tester, Size size, {bool reduceMotion = true}) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      FakeAccessibilityFeatures(disableAnimations: reduceMotion);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

Future<void> openList(WidgetTester tester) async {
  await tester.pumpWidget(const FlutterCakeShopApp());
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

void main() {
  test('Shop model records are ordered as in the reference list', () {
    expect(
      cakeShopData.map((shop) => shop.name),
      referenceShops.map((shop) => shop.name),
    );
  });

  testWidgets('Splash starts the app and replaces its route after 3 seconds', (
    tester,
  ) async {
    setViewport(tester, const Size(440, 956));
    await tester.pumpWidget(const FlutterCakeShopApp());
    expect(find.byType(SplashScreenUI), findsOneWidget);
    expect(find.text('CAKE CALL FAST'), findsOneWidget);
    expect(assetImage('bg_welcome.png'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2999));
    expect(find.byType(CakeShopListUI), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreenUI), findsNothing);
    expect(find.byType(CakeShopListUI), findsOneWidget);
    expect(
      tester.widget<AppBar>(find.byType(AppBar)).backgroundColor,
      const Color(0xFFFF0000),
    );
    expect(
      Navigator.of(tester.element(find.byType(CakeShopListUI))).canPop(),
      isFalse,
    );
  });

  testWidgets('Carousel autoplays every 3 seconds and responds to swipe', (
    tester,
  ) async {
    setViewport(tester, const Size(440, 956), reduceMotion: false);
    await openList(tester);
    final slider = find.byType(CarouselSlider);
    final center = tester.getCenter(slider).dx;
    expect(tester.getCenter(assetImage('ck01.png')).dx, closeTo(center, 2));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(tester.getCenter(assetImage('ck02.png')).dx, closeTo(center, 2));
    await tester.drag(slider, const Offset(-270, 0));
    await tester.pumpAndSettle();
    expect(tester.getCenter(assetImage('ck03.png')).dx, closeTo(center, 2));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'All seven model records navigate, show matching data and go back',
    (tester) async {
      setViewport(tester, const Size(440, 956));
      await openList(tester);
      expect(
        tester.widget<ListView>(find.byType(ListView)).semanticChildCount,
        7,
      );

      for (final (index, expected) in referenceShops.indexed) {
        final name = find.text(expected.name);
        await tester.scrollUntilVisible(
          name.hitTestable(),
          120,
          scrollable: shopListScroll,
        );
        final row = find.ancestor(of: name, matching: find.byType(ListTile));
        expect(
          find.descendant(of: row, matching: find.text(expected.phone)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: row, matching: assetImage('s${index + 1}1.jpg')),
          findsOneWidget,
        );

        if (index.isEven) {
          await tester.tap(name);
        } else {
          await tester.tap(find.byTooltip('รายละเอียด ${expected.name}'));
        }
        await tester.pumpAndSettle();

        final details = tester.widget<CakeShopDetailUI>(
          find.byType(CakeShopDetailUI),
        );
        expect(details.cakeShopShow.name, expected.name);
        expect(
          tester.widget<AppBar>(find.byType(AppBar)).backgroundColor,
          const Color(0xFFF44336),
        );
        expect(find.text(expected.name), findsNWidgets(2));
        expect(find.text(expected.address), findsOneWidget);
        expect(find.text(expected.hours), findsOneWidget);
        expect(find.textContaining(expected.descriptionStart), findsOneWidget);
        expect(find.text(expected.phone), findsOneWidget);
        expect(find.text(expected.website), findsOneWidget);
        expect(find.text(expected.facebook), findsOneWidget);
        for (final number in [1, 2, 3]) {
          expect(assetImage('s${index + 1}$number.jpg'), findsOneWidget);
        }

        final point = tester
            .widget<MarkerLayer>(find.byType(MarkerLayer))
            .markers
            .single
            .point;
        expect(point.latitude, expected.lat);
        expect(point.longitude, expected.lon);
        expect(
          tester
              .widget<FlutterMap>(find.byType(FlutterMap))
              .options
              .initialCenter,
          point,
        );
        expect(tester.takeException(), isNull);

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(find.byType(CakeShopListUI), findsOneWidget);
        expect(find.byType(CakeShopDetailUI), findsNothing);
      }
    },
  );

  testWidgets('Small viewport scrolls to end and launches exact shop URIs', (
    tester,
  ) async {
    setViewport(tester, const Size(320, 568));
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    final messenger = tester.binding.defaultBinaryMessenger;
    final launched = <String>[];
    var supported = true;
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'launch');
      launched.add((call.arguments as Map)['url'] as String);
      return supported;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    await openList(tester);
    final lastShop = find.text('Bake Ministry');
    await tester.scrollUntilVisible(
      lastShop.hitTestable(),
      120,
      scrollable: shopListScroll,
    );
    await tester.tap(lastShop);
    await tester.pumpAndSettle();
    expect(find.byType(CakeShopDetailUI), findsOneWidget);

    final phone = find.text('0891540474');
    final website = find.text('http://www.bakeministry.net/');
    final facebook = find.text('https://www.facebook.com/bakeministry');
    final marker = find.byTooltip('เปิดตำแหน่งร้านใน Google Maps');
    for (final action in [phone, website, facebook, marker]) {
      await tester.ensureVisible(action);
      await tester.pumpAndSettle();
      await tester.tap(action);
      await tester.pumpAndSettle();
    }
    expect(launched, [
      'tel:0891540474',
      'http://www.bakeministry.net/',
      'https://www.facebook.com/bakeministry',
      'https://www.google.com/maps/search/?api=1&query=13.7281129%2C100.5705757',
    ]);
    expect(find.text('© OpenStreetMap contributors'), findsOneWidget);

    supported = false;
    await tester.ensureVisible(phone);
    await tester.tap(phone);
    await tester.pumpAndSettle();
    expect(find.text('อุปกรณ์นี้เปิดลิงก์ดังกล่าวไม่ได้'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('All 30 source images are bundled and decode successfully', (
    tester,
  ) async {
    final paths = [
      'bg_welcome.png',
      'icon.png',
      for (var shop = 1; shop <= 7; shop++) ...[
        'ck0$shop.png',
        for (var photo = 1; photo <= 3; photo++) 's$shop$photo.jpg',
      ],
    ];
    await tester.runAsync(() async {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      expect(
        manifest
            .listAssets()
            .where((path) => path.startsWith('assets/images/'))
            .length,
        30,
      );
      for (final path in paths) {
        final data = await rootBundle.load('assets/images/$path');
        final codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        final image = (await codec.getNextFrame()).image;
        expect(image.width, greaterThan(0), reason: path);
        expect(image.height, greaterThan(0), reason: path);
        image.dispose();
        codec.dispose();
      }
    });
  });
}
