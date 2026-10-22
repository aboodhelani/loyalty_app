import 'package:dartz/dartz.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../core/utils/usecases/usecase.dart';
import '../../../../../shared/domain/models/qr_token.dart';
import '../../../../../shared/domain/models/redemption.dart';
import '../../../../../shared/domain/models/stamp_card.dart';
import '../../../../../shared/domain/models/visit_entry.dart';
import '../repositories/wallet_repo.dart';

class GetWalletCardsUseCase extends UseCase<List<StampCard>, NoParams> {
  final WalletRepo repository;

  GetWalletCardsUseCase(this.repository);

  @override
  Future<Either<Failure, List<StampCard>>> call(NoParams params) => repository.cards();
}

class GetStampCardUseCase extends UseCase<StampCard, String> {
  final WalletRepo repository;

  GetStampCardUseCase(this.repository);

  @override
  Future<Either<Failure, StampCard>> call(String cardId) => repository.card(cardId);
}

class GetQrTokenUseCase extends UseCase<QrToken, NoParams> {
  final WalletRepo repository;

  GetQrTokenUseCase(this.repository);

  @override
  Future<Either<Failure, QrToken>> call(NoParams params) => repository.qrToken();
}

class CreateRedemptionUseCase extends UseCase<Redemption, String> {
  final WalletRepo repository;

  CreateRedemptionUseCase(this.repository);

  @override
  Future<Either<Failure, Redemption>> call(String cardId) => repository.createRedemption(cardId);
}

class GetVisitHistoryUseCase extends UseCase<List<VisitEntry>, NoParams> {
  final WalletRepo repository;

  GetVisitHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<VisitEntry>>> call(NoParams params) => repository.visits();
}
