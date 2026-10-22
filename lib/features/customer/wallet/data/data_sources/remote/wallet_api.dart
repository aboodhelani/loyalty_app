import '../../../../../../core/network/api_client.dart';
import '../../../../../../core/utils/constant/network_constant.dart';
import '../../../../../../shared/domain/models/qr_token.dart';
import '../../../../../../shared/domain/models/redemption.dart';
import '../../../../../../shared/domain/models/stamp_card.dart';
import '../../../../../../shared/domain/models/visit_entry.dart';

class WalletApi {
  final ApiClient _client;

  WalletApi(this._client);

  /// Active cards; ready-to-redeem first, then closest to the reward.
  Future<List<StampCard>> cards() async {
    final list = await _client.getList(meWalletPath);
    return list.whereType<Map>().map((e) => StampCard.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  /// Includes the program, stamp history and any open redemption.
  Future<StampCard> card(String id) async {
    final json = await _client.get(meCardPath(id));
    return StampCard.fromJson(json);
  }

  Future<QrToken> qrToken() async {
    final json = await _client.get(meQrPath);
    return QrToken.fromJson(json);
  }

  /// One-time code/QR, valid 15 minutes.
  Future<Redemption> createRedemption(String cardId) async {
    final json = await _client.post(meCardRedeemPath(cardId));
    return Redemption.fromJson(json);
  }

  Future<List<VisitEntry>> visits() async {
    final list = await _client.getList(meVisitsPath);
    return list.whereType<Map>().map((e) => VisitEntry.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
