import 'package:dartz/dartz.dart';

import '../../../../../core/network/error/guard.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../shared/domain/models/qr_token.dart';
import '../../../../../shared/domain/models/redemption.dart';
import '../../../../../shared/domain/models/stamp_card.dart';
import '../../../../../shared/domain/models/visit_entry.dart';
import '../../domain/repositories/wallet_repo.dart';
import '../data_sources/remote/wallet_api.dart';

class WalletRepoImpl extends WalletRepo {
  final WalletApi api;

  WalletRepoImpl(this.api);

  @override
  Future<Either<Failure, List<StampCard>>> cards() => guardRequest(() => api.cards());

  @override
  Future<Either<Failure, StampCard>> card(String id) => guardRequest(() => api.card(id));

  @override
  Future<Either<Failure, QrToken>> qrToken() => guardRequest(() => api.qrToken());

  @override
  Future<Either<Failure, Redemption>> createRedemption(String cardId) =>
      guardRequest(() => api.createRedemption(cardId));

  @override
  Future<Either<Failure, List<VisitEntry>>> visits() => guardRequest(() => api.visits());
}
