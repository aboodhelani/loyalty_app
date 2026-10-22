import 'package:socket_io_client/socket_io_client.dart' as io;

import '../helper/helper.dart';
import '../utils/app_events.dart';
import '../utils/constant/network_constant.dart';
import '../utils/log/app_logger.dart';

/// Socket.IO connection to the API (`io(url, { auth: { token } })`). The server
/// joins the user's own room and their business rooms, so one connection feeds
/// the customer wallet and the staff live-payments list (S3).
///
/// Events are treated as "something changed" signals; screens reload from REST,
/// which keeps the payload contract loose.
class RealtimeService {
  io.Socket? _socket;

  void connect() {
    final token = Helper.getToken();
    if (token == null) return;
    disconnect();
    final socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .enableReconnection()
          .build(),
    );
    // Access tokens rotate every 15 minutes; send the current one on reconnect.
    socket.onReconnectAttempt((_) => socket.auth = {'token': Helper.getToken()});
    socket.onConnect((_) => logger.info('realtime: connected'));
    socket.onConnectError((e) => logger.warning('realtime: connect error $e'));

    void wallet(dynamic _) => AppEvents.notifyWalletChanged();
    socket.on('stamp.added', wallet);
    socket.on('card.ready', wallet);
    socket.on('redemption.confirmed', wallet);
    socket.on('payment.updated', wallet);
    socket.on('payment.succeeded', (data) {
      AppEvents.notifyPaymentReceived(_businessId(data) ?? '');
      AppEvents.notifyWalletChanged();
    });
    socket.on('business.activity', (data) => AppEvents.notifyBusinessChanged(_businessId(data)));
    socket.on('notification', (data) {
      if (data is Map) {
        AppEvents.notify(AppNotice(data['title']?.toString() ?? '', data['body']?.toString() ?? ''));
      }
    });

    _socket = socket..connect();
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }

  static String? _businessId(dynamic data) {
    if (data is! Map) return null;
    final business = data['business'];
    return data['businessId']?.toString() ?? (business is Map ? business['id']?.toString() : null);
  }
}
