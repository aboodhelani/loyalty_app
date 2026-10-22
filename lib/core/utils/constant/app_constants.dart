const String svgPath = "assets/svg_images/";
const String imagePath = "assets/images/";
const String defaultStr = "-";

/// Placeholder brand name until the client names the product.
const String appName = "Loyalty";

/// Payments are in AED for the MVP (spec §9).
const String defaultCurrency = "AED";

/// The customer QR rotates on this interval (spec §8.8).
const Duration qrRefreshInterval = Duration(seconds: 30);

/// Map centre used before location permission is granted — Dubai Marina,
/// where the demo businesses are seeded.
const double defaultLat = 25.0781;
const double defaultLng = 55.1403;
