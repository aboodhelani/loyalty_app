import 'package:dartz/dartz.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../shared/domain/models/qr_token.dart';
import '../../../../../shared/domain/models/redemption.dart';
import '../../../../../shared/domain/models/stamp_card.dart';
import '../../../../../shared/domain/models/visit_entry.dart';

abstract class WalletRepo {
  Future<Either<Failure, List<StampCard>>> cards();

  Future<Either<Failure, StampCard>> card(String id);

  Future<Either<Failure, QrToken>> qrToken();

  Future<Either<Failure, Redemption>> createRedemption(String cardId);

  Future<Either<Failure, List<VisitEntry>>> visits();
}
