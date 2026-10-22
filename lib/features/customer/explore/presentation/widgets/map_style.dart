/// Google Maps style in the brand's warm palette: cream land, soft roads, muted
/// POIs so the business pins stand out.
const String warmMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#f5f1e3"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#7a6a5c"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#f7f4e8"}]},
  {"featureType":"poi","stylers":[{"visibility":"off"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"visibility":"on"},{"color":"#e3e6c8"}]},
  {"featureType":"transit","stylers":[{"visibility":"off"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},
  {"featureType":"road","elementType":"labels.icon","stylers":[{"visibility":"off"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#ead9b9"}]},
  {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#d9c49c"}]},
  {"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#fbf8ef"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9dde0"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#6f8f94"}]},
  {"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#d4c8a8"}]}
]
''';
