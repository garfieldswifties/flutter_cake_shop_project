// นำเข้า FlutterMap และชนิดข้อมูลพิกัด
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

class CakeShopMap extends StatelessWidget {
  const CakeShopMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onOpenLink,
  });

  final double latitude;
  final double longitude;
  final Future<void> Function(Uri) onOpenLink;

  @override
  Widget build(BuildContext context) {
    final shopLocation = LatLng(latitude, longitude);

    return AspectRatio(
      aspectRatio: .93,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: shopLocation,
          initialZoom: 15.5,
          backgroundColor: const Color(0xFFEDEAE5),
          // ให้ปัดแนวตั้งเพื่อเลื่อนหน้ารายละเอียด และแตะสองครั้งเพื่อซูม
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.doubleTapZoom,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName:
                'com.garfieldswifties.flutter_cake_shop_project',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: shopLocation,
                width: 48,
                height: 48,
                alignment: Alignment.topCenter,
                child: IconButton(
                  tooltip: 'เปิดตำแหน่งร้านใน Google Maps',
                  onPressed: () => onOpenLink(
                    Uri.https('www.google.com', '/maps/search/', {
                      'api': '1',
                      'query': '$latitude,$longitude',
                    }),
                  ),
                  icon: const Icon(
                    Icons.location_on,
                    color: Color(0xFFE53935),
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () => onOpenLink(
                  Uri.https('www.openstreetmap.org', '/copyright'),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  child: Text(
                    '© OpenStreetMap contributors',
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
