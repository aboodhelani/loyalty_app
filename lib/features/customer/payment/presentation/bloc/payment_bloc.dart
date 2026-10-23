import 'package:bloc/bloc.dart';

import '../../../../../core/utils/app_events.dart';
import '../../../../../shared/domain/models/business.dart';
import '../../../../../shared/domain/models/transaction.dart';
import '../../domain/usecases/payment_usecases.dart';

abstract class PaymentEvent {
  const PaymentEvent();
}

class PayPressedEvent extends PaymentEvent {
  final double amount;
  const PayPressedEvent(this.amount);
}

abstract class PaymentState {
  const PaymentState();
}

class PaymentIdle extends PaymentState {
  /// One-shot message for the page to surface.
  final String? error;
  const PaymentIdle({this.error});
}

/// Creating the intent and showing the wallet sheet.
class PaymentAuthorizing extends PaymentState {}

/// Paid; waiting for the backend to settle it and issue the stamp.
class PaymentProcessing extends PaymentState {}

class PaymentSucceeded extends PaymentState {
  final PaymentTransaction transaction;
  const PaymentSucceeded(this.transaction);
}

/// Pay screen (C6): create the payment, authorize it with Apple Pay or Google Pay, then wait
/// for the webhook-driven result (spec §9).
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final Business business;
  final CreatePaymentUseCase createPaymentUseCase;
  final AuthorizePaymentUseCase authorizePaymentUseCase;
  final AwaitPaymentResultUseCase awaitResultUseCase;

  PaymentBloc({
    required this.business,
    required this.createPaymentUseCase,
    required this.authorizePaymentUseCase,
    required this.awaitResultUseCase,
  }) : super(const PaymentIdle()) {
    on<PayPressedEvent>(_onPay);
  }

  Future<void> _onPay(PayPressedEvent event, Emitter<PaymentState> emitter) async {
    if (state is! PaymentIdle) return;
    emitter(PaymentAuthorizing());

    final created = await createPaymentUseCase(CreatePaymentParams(
      businessId: business.id,
      amount: event.amount,
      branchId: business.mainBranch?.id,
    ));
    final intent = created.fold((l) {
      emitter(PaymentIdle(error: l.errorMessage));
      return null;
    }, (r) => r);
    if (intent == null) return;

    final authorized = await authorizePaymentUseCase(AuthorizePaymentParams(intent, business.name));
    final ok = authorized.fold((l) {
      emitter(PaymentIdle(error: l.errorMessage));
      return null;
    }, (r) => r);
    if (ok == null) return;
    if (!ok) {
      emitter(const PaymentIdle());
      return;
    }

    emitter(PaymentProcessing());
    final result = await awaitResultUseCase(intent.transactionId);
    result.fold(
      (l) => emitter(PaymentIdle(error: l.errorMessage)),
      (tx) {
        if (tx.status == TransactionStatus.succeeded) {
          AppEvents.notifyWalletChanged();
          emitter(PaymentSucceeded(tx));
        } else {
          emitter(PaymentIdle(error: tx.failureReason ?? 'Payment failed'));
        }
      },
    );
  }
}
