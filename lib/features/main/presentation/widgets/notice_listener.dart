import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/utils/app_events.dart';
import '../../../../core/utils/app_snack_bar.dart';

/// Shows loyalty notifications (stamp added, card ready, reward redeemed) as
/// they arrive on the socket.
class NoticeListener extends StatefulWidget {
  final Widget child;

  const NoticeListener({super.key, required this.child});

  @override
  State<NoticeListener> createState() => _NoticeListenerState();
}

class _NoticeListenerState extends State<NoticeListener> {
  StreamSubscription<AppNotice>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = AppEvents.notices.listen((notice) {
      if (!mounted) return;
      AppSnackBar.showNotice(context, title: notice.title, body: notice.body);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
