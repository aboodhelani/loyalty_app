// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message(
      'Try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueLabel {
    return Intl.message(
      'Continue',
      name: 'continueLabel',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get signInTitle {
    return Intl.message(
      'Enter your phone number',
      name: 'signInTitle',
      desc: '',
      args: [],
    );
  }

  /// `We will text you a code to sign in. No password needed.`
  String get signInSubtitle {
    return Intl.message(
      'We will text you a code to sign in. No password needed.',
      name: 'signInSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneLabel {
    return Intl.message(
      'Phone number',
      name: 'phoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid UAE mobile number`
  String get phoneInvalid {
    return Intl.message(
      'Enter a valid UAE mobile number',
      name: 'phoneInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code`
  String get codeTitle {
    return Intl.message(
      'Enter the code',
      name: 'codeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Resend code`
  String get resendCode {
    return Intl.message(
      'Resend code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend in {seconds}s`
  String resendIn(int seconds) {
    return Intl.message(
      'Resend in ${seconds}s',
      name: 'resendIn',
      desc: '',
      args: [seconds],
    );
  }

  /// `Change number`
  String get changeNumber {
    return Intl.message(
      'Change number',
      name: 'changeNumber',
      desc: '',
      args: [],
    );
  }

  /// `Nice to meet you`
  String get profileTitle {
    return Intl.message(
      'Nice to meet you',
      name: 'profileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tell us your name so businesses know who you are.`
  String get profileSubtitle {
    return Intl.message(
      'Tell us your name so businesses know who you are.',
      name: 'profileSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get nameLabel {
    return Intl.message(
      'Full name',
      name: 'nameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your name`
  String get nameRequired {
    return Intl.message(
      'Please enter your name',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Birthday (optional)`
  String get birthdayLabel {
    return Intl.message(
      'Birthday (optional)',
      name: 'birthdayLabel',
      desc: '',
      args: [],
    );
  }

  /// `Some businesses send birthday treats`
  String get birthdayHint {
    return Intl.message(
      'Some businesses send birthday treats',
      name: 'birthdayHint',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get tabExplore {
    return Intl.message(
      'Explore',
      name: 'tabExplore',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get tabWallet {
    return Intl.message(
      'Wallet',
      name: 'tabWallet',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get tabScan {
    return Intl.message(
      'Scan',
      name: 'tabScan',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get tabProfile {
    return Intl.message(
      'Profile',
      name: 'tabProfile',
      desc: '',
      args: [],
    );
  }

  /// `Search businesses`
  String get searchBusinesses {
    return Intl.message(
      'Search businesses',
      name: 'searchBusinesses',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get allCategories {
    return Intl.message(
      'All',
      name: 'allCategories',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get mapView {
    return Intl.message(
      'Map',
      name: 'mapView',
      desc: '',
      args: [],
    );
  }

  /// `List`
  String get listView {
    return Intl.message(
      'List',
      name: 'listView',
      desc: '',
      args: [],
    );
  }

  /// `No businesses found`
  String get noBusinessesTitle {
    return Intl.message(
      'No businesses found',
      name: 'noBusinessesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Try another category or search term.`
  String get noBusinessesMessage {
    return Intl.message(
      'Try another category or search term.',
      name: 'noBusinessesMessage',
      desc: '',
      args: [],
    );
  }

  /// `Showing Dubai Marina. Turn on location to see what is near you.`
  String get demoLocationNotice {
    return Intl.message(
      'Showing Dubai Marina. Turn on location to see what is near you.',
      name: 'demoLocationNotice',
      desc: '',
      args: [],
    );
  }

  /// `Visit {count} times, get {reward}`
  String programVisit(int count, String reward) {
    return Intl.message(
      'Visit $count times, get $reward',
      name: 'programVisit',
      desc: '',
      args: [count, reward],
    );
  }

  /// `Pay {count} times, get {reward}`
  String programPayment(int count, String reward) {
    return Intl.message(
      'Pay $count times, get $reward',
      name: 'programPayment',
      desc: '',
      args: [count, reward],
    );
  }

  /// `Minimum spend {amount} per stamp`
  String minSpendPerStamp(String amount) {
    return Intl.message(
      'Minimum spend $amount per stamp',
      name: 'minSpendPerStamp',
      desc: '',
      args: [amount],
    );
  }

  /// `{stamps} of {total} stamps`
  String stampsProgress(int stamps, int total) {
    return Intl.message(
      '$stamps of $total stamps',
      name: 'stampsProgress',
      desc: '',
      args: [stamps, total],
    );
  }

  /// `No stamps yet`
  String get noCardYet {
    return Intl.message(
      'No stamps yet',
      name: 'noCardYet',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get viewBusiness {
    return Intl.message(
      'View',
      name: 'viewBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Ready to redeem`
  String get readyToRedeem {
    return Intl.message(
      'Ready to redeem',
      name: 'readyToRedeem',
      desc: '',
      args: [],
    );
  }

  /// `Loyalty program paused`
  String get programPaused {
    return Intl.message(
      'Loyalty program paused',
      name: 'programPaused',
      desc: '',
      args: [],
    );
  }

  /// `Directions`
  String get directions {
    return Intl.message(
      'Directions',
      name: 'directions',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Opening hours`
  String get openingHours {
    return Intl.message(
      'Opening hours',
      name: 'openingHours',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Loyalty program`
  String get loyaltyProgram {
    return Intl.message(
      'Loyalty program',
      name: 'loyaltyProgram',
      desc: '',
      args: [],
    );
  }

  /// `Your progress`
  String get yourProgress {
    return Intl.message(
      'Your progress',
      name: 'yourProgress',
      desc: '',
      args: [],
    );
  }

  /// `Stamps expire {days} days after you collect them.`
  String stampExpiryNote(int days) {
    return Intl.message(
      'Stamps expire $days days after you collect them.',
      name: 'stampExpiryNote',
      desc: '',
      args: [days],
    );
  }

  /// `Pay`
  String get payButton {
    return Intl.message(
      'Pay',
      name: 'payButton',
      desc: '',
      args: [],
    );
  }

  /// `Pay here and get your stamp automatically`
  String get payHere {
    return Intl.message(
      'Pay here and get your stamp automatically',
      name: 'payHere',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Pay {business}`
  String payTitle(String business) {
    return Intl.message(
      'Pay $business',
      name: 'payTitle',
      desc: '',
      args: [business],
    );
  }

  /// `Amount`
  String get amountLabel {
    return Intl.message(
      'Amount',
      name: 'amountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter an amount`
  String get enterAmount {
    return Intl.message(
      'Enter an amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Pay with Apple Pay`
  String get payWithApplePay {
    return Intl.message(
      'Pay with Apple Pay',
      name: 'payWithApplePay',
      desc: '',
      args: [],
    );
  }

  /// `Processing payment…`
  String get processingPayment {
    return Intl.message(
      'Processing payment…',
      name: 'processingPayment',
      desc: '',
      args: [],
    );
  }

  /// `Payment successful`
  String get paymentSuccessTitle {
    return Intl.message(
      'Payment successful',
      name: 'paymentSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Receipt`
  String get receipt {
    return Intl.message(
      'Receipt',
      name: 'receipt',
      desc: '',
      args: [],
    );
  }

  /// `Business`
  String get business {
    return Intl.message(
      'Business',
      name: 'business',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Reference`
  String get reference {
    return Intl.message(
      'Reference',
      name: 'reference',
      desc: '',
      args: [],
    );
  }

  /// `Stamp added: {stamps} of {total}`
  String stampAdded(int stamps, int total) {
    return Intl.message(
      'Stamp added: $stamps of $total',
      name: 'stampAdded',
      desc: '',
      args: [stamps, total],
    );
  }

  /// `Your card is full — your reward is ready!`
  String get cardNowReady {
    return Intl.message(
      'Your card is full — your reward is ready!',
      name: 'cardNowReady',
      desc: '',
      args: [],
    );
  }

  /// `You already collected a stamp here today. Come back tomorrow!`
  String get blockedAlreadyToday {
    return Intl.message(
      'You already collected a stamp here today. Come back tomorrow!',
      name: 'blockedAlreadyToday',
      desc: '',
      args: [],
    );
  }

  /// `This payment is below the minimum spend for a stamp.`
  String get blockedBelowMinSpend {
    return Intl.message(
      'This payment is below the minimum spend for a stamp.',
      name: 'blockedBelowMinSpend',
      desc: '',
      args: [],
    );
  }

  /// `This business has paused its loyalty program.`
  String get blockedProgramPaused {
    return Intl.message(
      'This business has paused its loyalty program.',
      name: 'blockedProgramPaused',
      desc: '',
      args: [],
    );
  }

  /// `View card`
  String get viewCard {
    return Intl.message(
      'View card',
      name: 'viewCard',
      desc: '',
      args: [],
    );
  }

  /// `Payment cancelled`
  String get paymentCancelled {
    return Intl.message(
      'Payment cancelled',
      name: 'paymentCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get walletTitle {
    return Intl.message(
      'Wallet',
      name: 'walletTitle',
      desc: '',
      args: [],
    );
  }

  /// `No stamp cards yet`
  String get walletEmptyTitle {
    return Intl.message(
      'No stamp cards yet',
      name: 'walletEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pay at a participating business or show your QR to staff to collect your first stamp.`
  String get walletEmptyMessage {
    return Intl.message(
      'Pay at a participating business or show your QR to staff to collect your first stamp.',
      name: 'walletEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Explore businesses`
  String get exploreBusinesses {
    return Intl.message(
      'Explore businesses',
      name: 'exploreBusinesses',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to see your cards`
  String get signInToSeeWallet {
    return Intl.message(
      'Sign in to see your cards',
      name: 'signInToSeeWallet',
      desc: '',
      args: [],
    );
  }

  /// `Your stamp cards live here once you collect your first stamp.`
  String get signInToSeeWalletMessage {
    return Intl.message(
      'Your stamp cards live here once you collect your first stamp.',
      name: 'signInToSeeWalletMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `{count} to go`
  String stampsToGo(int count) {
    return Intl.message(
      '$count to go',
      name: 'stampsToGo',
      desc: '',
      args: [count],
    );
  }

  /// `Next stamp expires {date}`
  String expiresOn(String date) {
    return Intl.message(
      'Next stamp expires $date',
      name: 'expiresOn',
      desc: '',
      args: [date],
    );
  }

  /// `Reward`
  String get reward {
    return Intl.message(
      'Reward',
      name: 'reward',
      desc: '',
      args: [],
    );
  }

  /// `Terms`
  String get terms {
    return Intl.message(
      'Terms',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Stamp history`
  String get stampHistory {
    return Intl.message(
      'Stamp history',
      name: 'stampHistory',
      desc: '',
      args: [],
    );
  }

  /// `No stamps on this card yet.`
  String get noStampsYet {
    return Intl.message(
      'No stamps on this card yet.',
      name: 'noStampsYet',
      desc: '',
      args: [],
    );
  }

  /// `In-app payment`
  String get stampSourcePayment {
    return Intl.message(
      'In-app payment',
      name: 'stampSourcePayment',
      desc: '',
      args: [],
    );
  }

  /// `Scanned by staff`
  String get stampSourceStaff {
    return Intl.message(
      'Scanned by staff',
      name: 'stampSourceStaff',
      desc: '',
      args: [],
    );
  }

  /// `Added by support`
  String get stampSourceAdmin {
    return Intl.message(
      'Added by support',
      name: 'stampSourceAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Card #{number}`
  String cycleLabel(int number) {
    return Intl.message(
      'Card #$number',
      name: 'cycleLabel',
      desc: '',
      args: [number],
    );
  }

  /// `Redeem`
  String get redeem {
    return Intl.message(
      'Redeem',
      name: 'redeem',
      desc: '',
      args: [],
    );
  }

  /// `Redeem your reward`
  String get redeemTitle {
    return Intl.message(
      'Redeem your reward',
      name: 'redeemTitle',
      desc: '',
      args: [],
    );
  }

  /// `Show this code to staff. They will scan it or type the code to confirm.`
  String get redeemInstructions {
    return Intl.message(
      'Show this code to staff. They will scan it or type the code to confirm.',
      name: 'redeemInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Reward redeemed!`
  String get redeemSuccessTitle {
    return Intl.message(
      'Reward redeemed!',
      name: 'redeemSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy {reward}. Your card starts again from zero.`
  String redeemSuccessMessage(String reward) {
    return Intl.message(
      'Enjoy $reward. Your card starts again from zero.',
      name: 'redeemSuccessMessage',
      desc: '',
      args: [reward],
    );
  }

  /// `Waiting for staff to confirm…`
  String get waitingForStaff {
    return Intl.message(
      'Waiting for staff to confirm…',
      name: 'waitingForStaff',
      desc: '',
      args: [],
    );
  }

  /// `My QR`
  String get myQrTitle {
    return Intl.message(
      'My QR',
      name: 'myQrTitle',
      desc: '',
      args: [],
    );
  }

  /// `Show this to staff to collect a stamp when you pay by cash or card.`
  String get myQrInstructions {
    return Intl.message(
      'Show this to staff to collect a stamp when you pay by cash or card.',
      name: 'myQrInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Refreshes in {seconds}s`
  String qrRefreshesIn(int seconds) {
    return Intl.message(
      'Refreshes in ${seconds}s',
      name: 'qrRefreshesIn',
      desc: '',
      args: [seconds],
    );
  }

  /// `Sign in to get your QR`
  String get signInForQr {
    return Intl.message(
      'Sign in to get your QR',
      name: 'signInForQr',
      desc: '',
      args: [],
    );
  }

  /// `Your personal QR lets staff add stamps for you.`
  String get signInForQrMessage {
    return Intl.message(
      'Your personal QR lets staff add stamps for you.',
      name: 'signInForQrMessage',
      desc: '',
      args: [],
    );
  }

  /// `Collect {count} stamps, get {reward}`
  String programCollect(int count, String reward) {
    return Intl.message(
      'Collect $count stamps, get $reward',
      name: 'programCollect',
      desc: '',
      args: [count, reward],
    );
  }

  /// `Guest`
  String get guestName {
    return Intl.message(
      'Guest',
      name: 'guestName',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to collect stamps and pay in the app.`
  String get guestSubtitle {
    return Intl.message(
      'Sign in to collect stamps and pay in the app.',
      name: 'guestSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Birthday`
  String get birthday {
    return Intl.message(
      'Birthday',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `Not set`
  String get notSet {
    return Intl.message(
      'Not set',
      name: 'notSet',
      desc: '',
      args: [],
    );
  }

  /// `Visit history`
  String get visitHistory {
    return Intl.message(
      'Visit history',
      name: 'visitHistory',
      desc: '',
      args: [],
    );
  }

  /// `Your visits will appear here.`
  String get visitHistoryEmpty {
    return Intl.message(
      'Your visits will appear here.',
      name: 'visitHistoryEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Stamps, ready rewards and redemptions`
  String get notificationsSubtitle {
    return Intl.message(
      'Stamps, ready rewards and redemptions',
      name: 'notificationsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Business mode`
  String get businessMode {
    return Intl.message(
      'Business mode',
      name: 'businessMode',
      desc: '',
      args: [],
    );
  }

  /// `Switch to owner mode`
  String get switchToOwner {
    return Intl.message(
      'Switch to owner mode',
      name: 'switchToOwner',
      desc: '',
      args: [],
    );
  }

  /// `Switch to staff mode`
  String get switchToStaff {
    return Intl.message(
      'Switch to staff mode',
      name: 'switchToStaff',
      desc: '',
      args: [],
    );
  }

  /// `Switch to customer mode`
  String get switchToCustomer {
    return Intl.message(
      'Switch to customer mode',
      name: 'switchToCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Log out of your account?`
  String get logOutConfirm {
    return Intl.message(
      'Log out of your account?',
      name: 'logOutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfile {
    return Intl.message(
      'Edit profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `All your loyalty cards in one place`
  String get onboardingTitle1 {
    return Intl.message(
      'All your loyalty cards in one place',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Cafés, salons, barbers, car washes and more — every stamp card lives in one wallet.`
  String get onboardingBody1 {
    return Intl.message(
      'Cafés, salons, barbers, car washes and more — every stamp card lives in one wallet.',
      name: 'onboardingBody1',
      desc: '',
      args: [],
    );
  }

  /// `Pay and get stamped automatically`
  String get onboardingTitle2 {
    return Intl.message(
      'Pay and get stamped automatically',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Pay with Apple Pay in the app and your stamp lands on your card instantly.`
  String get onboardingBody2 {
    return Intl.message(
      'Pay with Apple Pay in the app and your stamp lands on your card instantly.',
      name: 'onboardingBody2',
      desc: '',
      args: [],
    );
  }

  /// `Find rewards near you`
  String get onboardingTitle3 {
    return Intl.message(
      'Find rewards near you',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Allow location to see participating businesses around you on the map.`
  String get onboardingBody3 {
    return Intl.message(
      'Allow location to see participating businesses around you on the map.',
      name: 'onboardingBody3',
      desc: '',
      args: [],
    );
  }

  /// `Allow location`
  String get allowLocation {
    return Intl.message(
      'Allow location',
      name: 'allowLocation',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Get started`
  String get getStarted {
    return Intl.message(
      'Get started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTabTitle {
    return Intl.message(
      'Profile',
      name: 'profileTabTitle',
      desc: '',
      args: [],
    );
  }

  /// `Daily {hours}`
  String dailyHours(String hours) {
    return Intl.message(
      'Daily $hours',
      name: 'dailyHours',
      desc: '',
      args: [hours],
    );
  }

  /// `Today {hours}`
  String todayHours(String hours) {
    return Intl.message(
      'Today $hours',
      name: 'todayHours',
      desc: '',
      args: [hours],
    );
  }

  /// `Closed today`
  String get closedToday {
    return Intl.message(
      'Closed today',
      name: 'closedToday',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get modeCustomer {
    return Intl.message(
      'Customer',
      name: 'modeCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Owner`
  String get modeOwner {
    return Intl.message(
      'Owner',
      name: 'modeOwner',
      desc: '',
      args: [],
    );
  }

  /// `Staff`
  String get modeStaff {
    return Intl.message(
      'Staff',
      name: 'modeStaff',
      desc: '',
      args: [],
    );
  }

  /// `Switch business`
  String get switchBusiness {
    return Intl.message(
      'Switch business',
      name: 'switchBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get accountTab {
    return Intl.message(
      'Account',
      name: 'accountTab',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated`
  String get profileSaved {
    return Intl.message(
      'Profile updated',
      name: 'profileSaved',
      desc: '',
      args: [],
    );
  }

  /// `Stamp`
  String get staffStampTab {
    return Intl.message(
      'Stamp',
      name: 'staffStampTab',
      desc: '',
      args: [],
    );
  }

  /// `Redeem`
  String get staffRedeemTab {
    return Intl.message(
      'Redeem',
      name: 'staffRedeemTab',
      desc: '',
      args: [],
    );
  }

  /// `Payments`
  String get staffPaymentsTab {
    return Intl.message(
      'Payments',
      name: 'staffPaymentsTab',
      desc: '',
      args: [],
    );
  }

  /// `Scan customer QR`
  String get scanCustomerTitle {
    return Intl.message(
      'Scan customer QR',
      name: 'scanCustomerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Point the camera at the QR in the customer’s app.`
  String get scanCustomerHint {
    return Intl.message(
      'Point the camera at the QR in the customer’s app.',
      name: 'scanCustomerHint',
      desc: '',
      args: [],
    );
  }

  /// `Scan reward code`
  String get scanRedemptionTitle {
    return Intl.message(
      'Scan reward code',
      name: 'scanRedemptionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Scan the reward QR or type the 6-digit code.`
  String get scanRedemptionHint {
    return Intl.message(
      'Scan the reward QR or type the 6-digit code.',
      name: 'scanRedemptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter code`
  String get enterCode {
    return Intl.message(
      'Enter code',
      name: 'enterCode',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get codeLabel {
    return Intl.message(
      'Code',
      name: 'codeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Camera unavailable. You can type the code instead.`
  String get cameraUnavailable {
    return Intl.message(
      'Camera unavailable. You can type the code instead.',
      name: 'cameraUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Add stamp`
  String get addStamp {
    return Intl.message(
      'Add stamp',
      name: 'addStamp',
      desc: '',
      args: [],
    );
  }

  /// `Stamp added for {name}`
  String stampConfirmed(String name) {
    return Intl.message(
      'Stamp added for $name',
      name: 'stampConfirmed',
      desc: '',
      args: [name],
    );
  }

  /// `New card — first stamp`
  String get newCustomerCard {
    return Intl.message(
      'New card — first stamp',
      name: 'newCustomerCard',
      desc: '',
      args: [],
    );
  }

  /// `Scan next`
  String get scanNext {
    return Intl.message(
      'Scan next',
      name: 'scanNext',
      desc: '',
      args: [],
    );
  }

  /// `Reward to give`
  String get rewardToGive {
    return Intl.message(
      'Reward to give',
      name: 'rewardToGive',
      desc: '',
      args: [],
    );
  }

  /// `Confirm redeemed`
  String get confirmRedeemed {
    return Intl.message(
      'Confirm redeemed',
      name: 'confirmRedeemed',
      desc: '',
      args: [],
    );
  }

  /// `Reward redeemed. The card starts again from zero.`
  String get rewardConfirmed {
    return Intl.message(
      'Reward redeemed. The card starts again from zero.',
      name: 'rewardConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `{name} has a reward ready here`
  String customerHasReward(String name) {
    return Intl.message(
      '$name has a reward ready here',
      name: 'customerHasReward',
      desc: '',
      args: [name],
    );
  }

  /// `Live payments`
  String get livePaymentsTitle {
    return Intl.message(
      'Live payments',
      name: 'livePaymentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `No in-app payments yet today`
  String get livePaymentsEmpty {
    return Intl.message(
      'No in-app payments yet today',
      name: 'livePaymentsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Payments made in the app at this business appear here instantly.`
  String get livePaymentsEmptyMessage {
    return Intl.message(
      'Payments made in the app at this business appear here instantly.',
      name: 'livePaymentsEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Today: {count} payments · {total}`
  String todayTotal(int count, String total) {
    return Intl.message(
      'Today: $count payments · $total',
      name: 'todayTotal',
      desc: '',
      args: [count, total],
    );
  }

  /// `Working at {business}`
  String workingAt(String business) {
    return Intl.message(
      'Working at $business',
      name: 'workingAt',
      desc: '',
      args: [business],
    );
  }

  /// `Activity`
  String get ownerActivityTab {
    return Intl.message(
      'Activity',
      name: 'ownerActivityTab',
      desc: '',
      args: [],
    );
  }

  /// `Program`
  String get ownerProgramTab {
    return Intl.message(
      'Program',
      name: 'ownerProgramTab',
      desc: '',
      args: [],
    );
  }

  /// `Staff`
  String get ownerStaffTab {
    return Intl.message(
      'Staff',
      name: 'ownerStaffTab',
      desc: '',
      args: [],
    );
  }

  /// `Business`
  String get ownerBusinessTab {
    return Intl.message(
      'Business',
      name: 'ownerBusinessTab',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get rangeToday {
    return Intl.message(
      'Today',
      name: 'rangeToday',
      desc: '',
      args: [],
    );
  }

  /// `7 days`
  String get range7d {
    return Intl.message(
      '7 days',
      name: 'range7d',
      desc: '',
      args: [],
    );
  }

  /// `30 days`
  String get range30d {
    return Intl.message(
      '30 days',
      name: 'range30d',
      desc: '',
      args: [],
    );
  }

  /// `Payments`
  String get kpiPayments {
    return Intl.message(
      'Payments',
      name: 'kpiPayments',
      desc: '',
      args: [],
    );
  }

  /// `Revenue`
  String get kpiRevenue {
    return Intl.message(
      'Revenue',
      name: 'kpiRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Stamps issued`
  String get kpiStamps {
    return Intl.message(
      'Stamps issued',
      name: 'kpiStamps',
      desc: '',
      args: [],
    );
  }

  /// `Rewards redeemed`
  String get kpiRewards {
    return Intl.message(
      'Rewards redeemed',
      name: 'kpiRewards',
      desc: '',
      args: [],
    );
  }

  /// `New customers`
  String get kpiNewCustomers {
    return Intl.message(
      'New customers',
      name: 'kpiNewCustomers',
      desc: '',
      args: [],
    );
  }

  /// `Returning`
  String get kpiReturning {
    return Intl.message(
      'Returning',
      name: 'kpiReturning',
      desc: '',
      args: [],
    );
  }

  /// `Recent transactions`
  String get recentTransactions {
    return Intl.message(
      'Recent transactions',
      name: 'recentTransactions',
      desc: '',
      args: [],
    );
  }

  /// `No transactions in this period`
  String get noTransactions {
    return Intl.message(
      'No transactions in this period',
      name: 'noTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get statusPending {
    return Intl.message(
      'Pending',
      name: 'statusPending',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get statusSucceeded {
    return Intl.message(
      'Paid',
      name: 'statusSucceeded',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get statusFailed {
    return Intl.message(
      'Failed',
      name: 'statusFailed',
      desc: '',
      args: [],
    );
  }

  /// `Refunded`
  String get statusRefunded {
    return Intl.message(
      'Refunded',
      name: 'statusRefunded',
      desc: '',
      args: [],
    );
  }

  /// `Loyalty program`
  String get programBuilderTitle {
    return Intl.message(
      'Loyalty program',
      name: 'programBuilderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start from a template`
  String get templates {
    return Intl.message(
      'Start from a template',
      name: 'templates',
      desc: '',
      args: [],
    );
  }

  /// `Stamps needed`
  String get stampsNeeded {
    return Intl.message(
      'Stamps needed',
      name: 'stampsNeeded',
      desc: '',
      args: [],
    );
  }

  /// `What earns a stamp`
  String get earnRuleLabel {
    return Intl.message(
      'What earns a stamp',
      name: 'earnRuleLabel',
      desc: '',
      args: [],
    );
  }

  /// `Visit`
  String get earnVisit {
    return Intl.message(
      'Visit',
      name: 'earnVisit',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get earnPayment {
    return Intl.message(
      'Payment',
      name: 'earnPayment',
      desc: '',
      args: [],
    );
  }

  /// `Minimum spend per stamp (optional)`
  String get minSpendLabel {
    return Intl.message(
      'Minimum spend per stamp (optional)',
      name: 'minSpendLabel',
      desc: '',
      args: [],
    );
  }

  /// `Reward`
  String get rewardLabel {
    return Intl.message(
      'Reward',
      name: 'rewardLabel',
      desc: '',
      args: [],
    );
  }

  /// `e.g. a free haircut`
  String get rewardHint {
    return Intl.message(
      'e.g. a free haircut',
      name: 'rewardHint',
      desc: '',
      args: [],
    );
  }

  /// `Stamps expire after (days)`
  String get expiryLabel {
    return Intl.message(
      'Stamps expire after (days)',
      name: 'expiryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Preview — what customers see`
  String get previewTitle {
    return Intl.message(
      'Preview — what customers see',
      name: 'previewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Program active`
  String get programActive {
    return Intl.message(
      'Program active',
      name: 'programActive',
      desc: '',
      args: [],
    );
  }

  /// `Paused programs stop issuing stamps.`
  String get programActiveHint {
    return Intl.message(
      'Paused programs stop issuing stamps.',
      name: 'programActiveHint',
      desc: '',
      args: [],
    );
  }

  /// `Save program`
  String get saveProgram {
    return Intl.message(
      'Save program',
      name: 'saveProgram',
      desc: '',
      args: [],
    );
  }

  /// `Program saved`
  String get programSaved {
    return Intl.message(
      'Program saved',
      name: 'programSaved',
      desc: '',
      args: [],
    );
  }

  /// `Changing the target or reward creates a new version. Existing cards keep their original target until redeemed.`
  String get programVersionNote {
    return Intl.message(
      'Changing the target or reward creates a new version. Existing cards keep their original target until redeemed.',
      name: 'programVersionNote',
      desc: '',
      args: [],
    );
  }

  /// `Enter the reward`
  String get rewardRequired {
    return Intl.message(
      'Enter the reward',
      name: 'rewardRequired',
      desc: '',
      args: [],
    );
  }

  /// `Staff`
  String get staffTitle {
    return Intl.message(
      'Staff',
      name: 'staffTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add staff`
  String get addStaff {
    return Intl.message(
      'Add staff',
      name: 'addStaff',
      desc: '',
      args: [],
    );
  }

  /// `No staff yet`
  String get staffEmpty {
    return Intl.message(
      'No staff yet',
      name: 'staffEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Add staff by name and phone. They sign in with that number and get the scanner.`
  String get staffEmptyMessage {
    return Intl.message(
      'Add staff by name and phone. They sign in with that number and get the scanner.',
      name: 'staffEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get removeStaff {
    return Intl.message(
      'Remove',
      name: 'removeStaff',
      desc: '',
      args: [],
    );
  }

  /// `Remove {name} from your staff?`
  String removeStaffConfirm(String name) {
    return Intl.message(
      'Remove $name from your staff?',
      name: 'removeStaffConfirm',
      desc: '',
      args: [name],
    );
  }

  /// `Staff added`
  String get staffAdded {
    return Intl.message(
      'Staff added',
      name: 'staffAdded',
      desc: '',
      args: [],
    );
  }

  /// `Business profile`
  String get businessProfileTitle {
    return Intl.message(
      'Business profile',
      name: 'businessProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Business name`
  String get businessName {
    return Intl.message(
      'Business name',
      name: 'businessName',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Business profile saved`
  String get businessSaved {
    return Intl.message(
      'Business profile saved',
      name: 'businessSaved',
      desc: '',
      args: [],
    );
  }

  /// `No program yet — set one up to start issuing stamps.`
  String get noProgramYet {
    return Intl.message(
      'No program yet — set one up to start issuing stamps.',
      name: 'noProgramYet',
      desc: '',
      args: [],
    );
  }

  /// `{count} cards · {ready} ready to redeem`
  String walletSubtitle(int count, int ready) {
    return Intl.message(
      '$count cards · $ready ready to redeem',
      name: 'walletSubtitle',
      desc: '',
      args: [count, ready],
    );
  }

  /// `Your loyalty`
  String get yourLoyalty {
    return Intl.message(
      'Your loyalty',
      name: 'yourLoyalty',
      desc: '',
      args: [],
    );
  }

  /// `Scan to collect`
  String get scanToCollect {
    return Intl.message(
      'Scan to collect',
      name: 'scanToCollect',
      desc: '',
      args: [],
    );
  }

  /// `Show at the counter`
  String get showAtCounter {
    return Intl.message(
      'Show at the counter',
      name: 'showAtCounter',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Preferences`
  String get preferences {
    return Intl.message(
      'Preferences',
      name: 'preferences',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get activity {
    return Intl.message(
      'Activity',
      name: 'activity',
      desc: '',
      args: [],
    );
  }

  /// `Secure code · rotates automatically`
  String get secured {
    return Intl.message(
      'Secure code · rotates automatically',
      name: 'secured',
      desc: '',
      args: [],
    );
  }

  /// `How it works`
  String get howItWorks {
    return Intl.message(
      'How it works',
      name: 'howItWorks',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get reachOut {
    return Intl.message(
      'Contact',
      name: 'reachOut',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get manage {
    return Intl.message(
      'Manage',
      name: 'manage',
      desc: '',
      args: [],
    );
  }

  /// `Counter`
  String get counter {
    return Intl.message(
      'Counter',
      name: 'counter',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get authWelcome {
    return Intl.message(
      'Welcome',
      name: 'authWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Every stamp card,\none wallet.`
  String get authHeroTitle {
    return Intl.message(
      'Every stamp card,\none wallet.',
      name: 'authHeroTitle',
      desc: '',
      args: [],
    );
  }

  /// `Collect stamps at your favourite places and unlock rewards.`
  String get authHeroSubtitle {
    return Intl.message(
      'Collect stamps at your favourite places and unlock rewards.',
      name: 'authHeroSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Step {step} of {total}`
  String stepOf(int step, int total) {
    return Intl.message(
      'Step $step of $total',
      name: 'stepOf',
      desc: '',
      args: [step, total],
    );
  }

  /// `Your number is only used to sign you in. We never share it.`
  String get privacyNote {
    return Intl.message(
      'Your number is only used to sign you in. We never share it.',
      name: 'privacyNote',
      desc: '',
      args: [],
    );
  }

  /// `By continuing you agree to receive a one-time code by SMS.`
  String get smsNote {
    return Intl.message(
      'By continuing you agree to receive a one-time code by SMS.',
      name: 'smsNote',
      desc: '',
      args: [],
    );
  }

  /// `Didn't get a code?`
  String get didNotGetCode {
    return Intl.message(
      'Didn\'t get a code?',
      name: 'didNotGetCode',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get editNumber {
    return Intl.message(
      'Edit',
      name: 'editNumber',
      desc: '',
      args: [],
    );
  }

  /// `No password`
  String get perkNoPassword {
    return Intl.message(
      'No password',
      name: 'perkNoPassword',
      desc: '',
      args: [],
    );
  }

  /// `Free to join`
  String get perkFree {
    return Intl.message(
      'Free to join',
      name: 'perkFree',
      desc: '',
      args: [],
    );
  }

  /// `Instant rewards`
  String get perkRewards {
    return Intl.message(
      'Instant rewards',
      name: 'perkRewards',
      desc: '',
      args: [],
    );
  }

  /// `Add your birthday`
  String get birthdayPick {
    return Intl.message(
      'Add your birthday',
      name: 'birthdayPick',
      desc: '',
      args: [],
    );
  }

  /// `We texted a 6-digit code to this number.`
  String get codeSubtitleShort {
    return Intl.message(
      'We texted a 6-digit code to this number.',
      name: 'codeSubtitleShort',
      desc: '',
      args: [],
    );
  }

  /// `+1 stamp`
  String get onboardingStampChip {
    return Intl.message(
      '+1 stamp',
      name: 'onboardingStampChip',
      desc: '',
      args: [],
    );
  }

  /// `Near you`
  String get onboardingNearby {
    return Intl.message(
      'Near you',
      name: 'onboardingNearby',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
