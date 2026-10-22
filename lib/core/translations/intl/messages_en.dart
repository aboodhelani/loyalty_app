// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "${name} has a reward ready here";

  static String m1(number) => "Card #${number}";

  static String m2(hours) => "Daily ${hours}";

  static String m3(date) => "Next stamp expires ${date}";

  static String m4(amount) => "Minimum spend ${amount} per stamp";

  static String m5(business) => "Pay ${business}";

  static String m6(count, reward) => "Collect ${count} stamps, get ${reward}";

  static String m7(count, reward) => "Pay ${count} times, get ${reward}";

  static String m8(count, reward) => "Visit ${count} times, get ${reward}";

  static String m9(seconds) => "Refreshes in ${seconds}s";

  static String m10(reward) =>
      "Enjoy ${reward}. Your card starts again from zero.";

  static String m11(name) => "Remove ${name} from your staff?";

  static String m12(seconds) => "Resend in ${seconds}s";

  static String m13(stamps, total) => "Stamp added: ${stamps} of ${total}";

  static String m14(name) => "Stamp added for ${name}";

  static String m15(days) =>
      "Stamps expire ${days} days after you collect them.";

  static String m16(stamps, total) => "${stamps} of ${total} stamps";

  static String m17(count) => "${count} to go";

  static String m18(step, total) => "Step ${step} of ${total}";

  static String m19(hours) => "Today ${hours}";

  static String m20(count, total) => "Today: ${count} payments · ${total}";

  static String m21(count, ready) =>
      "${count} cards · ${ready} ready to redeem";

  static String m22(business) => "Working at ${business}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("About"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accountTab": MessageLookupByLibrary.simpleMessage("Account"),
        "activity": MessageLookupByLibrary.simpleMessage("Activity"),
        "addStaff": MessageLookupByLibrary.simpleMessage("Add staff"),
        "addStamp": MessageLookupByLibrary.simpleMessage("Add stamp"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "allCategories": MessageLookupByLibrary.simpleMessage("All"),
        "allowLocation": MessageLookupByLibrary.simpleMessage("Allow location"),
        "amountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
        "authHeroSubtitle": MessageLookupByLibrary.simpleMessage(
            "Collect stamps at your favourite places and unlock rewards."),
        "authHeroTitle": MessageLookupByLibrary.simpleMessage(
            "Every stamp card,\none wallet."),
        "authWelcome": MessageLookupByLibrary.simpleMessage("Welcome"),
        "birthday": MessageLookupByLibrary.simpleMessage("Birthday"),
        "birthdayHint": MessageLookupByLibrary.simpleMessage(
            "Some businesses send birthday treats"),
        "birthdayLabel":
            MessageLookupByLibrary.simpleMessage("Birthday (optional)"),
        "birthdayPick":
            MessageLookupByLibrary.simpleMessage("Add your birthday"),
        "blockedAlreadyToday": MessageLookupByLibrary.simpleMessage(
            "You already collected a stamp here today. Come back tomorrow!"),
        "blockedBelowMinSpend": MessageLookupByLibrary.simpleMessage(
            "This payment is below the minimum spend for a stamp."),
        "blockedProgramPaused": MessageLookupByLibrary.simpleMessage(
            "This business has paused its loyalty program."),
        "business": MessageLookupByLibrary.simpleMessage("Business"),
        "businessMode": MessageLookupByLibrary.simpleMessage("Business mode"),
        "businessName": MessageLookupByLibrary.simpleMessage("Business name"),
        "businessProfileTitle":
            MessageLookupByLibrary.simpleMessage("Business profile"),
        "businessSaved":
            MessageLookupByLibrary.simpleMessage("Business profile saved"),
        "call": MessageLookupByLibrary.simpleMessage("Call"),
        "cameraUnavailable": MessageLookupByLibrary.simpleMessage(
            "Camera unavailable. You can type the code instead."),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cardNowReady": MessageLookupByLibrary.simpleMessage(
            "Your card is full — your reward is ready!"),
        "category": MessageLookupByLibrary.simpleMessage("Category"),
        "changeNumber": MessageLookupByLibrary.simpleMessage("Change number"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "closedToday": MessageLookupByLibrary.simpleMessage("Closed today"),
        "codeLabel": MessageLookupByLibrary.simpleMessage("Code"),
        "codeSubtitleShort": MessageLookupByLibrary.simpleMessage(
            "We texted a 6-digit code to this number."),
        "codeTitle": MessageLookupByLibrary.simpleMessage("Enter the code"),
        "confirmRedeemed":
            MessageLookupByLibrary.simpleMessage("Confirm redeemed"),
        "continueLabel": MessageLookupByLibrary.simpleMessage("Continue"),
        "counter": MessageLookupByLibrary.simpleMessage("Counter"),
        "customerHasReward": m0,
        "cycleLabel": m1,
        "dailyHours": m2,
        "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "demoLocationNotice": MessageLookupByLibrary.simpleMessage(
            "Showing Dubai Marina. Turn on location to see what is near you."),
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "didNotGetCode":
            MessageLookupByLibrary.simpleMessage("Didn\'t get a code?"),
        "directions": MessageLookupByLibrary.simpleMessage("Directions"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "earnPayment": MessageLookupByLibrary.simpleMessage("Payment"),
        "earnRuleLabel":
            MessageLookupByLibrary.simpleMessage("What earns a stamp"),
        "earnVisit": MessageLookupByLibrary.simpleMessage("Visit"),
        "editNumber": MessageLookupByLibrary.simpleMessage("Edit"),
        "editProfile": MessageLookupByLibrary.simpleMessage("Edit profile"),
        "enterAmount": MessageLookupByLibrary.simpleMessage("Enter an amount"),
        "enterCode": MessageLookupByLibrary.simpleMessage("Enter code"),
        "expiresOn": m3,
        "expiryLabel":
            MessageLookupByLibrary.simpleMessage("Stamps expire after (days)"),
        "exploreBusinesses":
            MessageLookupByLibrary.simpleMessage("Explore businesses"),
        "getStarted": MessageLookupByLibrary.simpleMessage("Get started"),
        "guestName": MessageLookupByLibrary.simpleMessage("Guest"),
        "guestSubtitle": MessageLookupByLibrary.simpleMessage(
            "Sign in to collect stamps and pay in the app."),
        "howItWorks": MessageLookupByLibrary.simpleMessage("How it works"),
        "info": MessageLookupByLibrary.simpleMessage("Info"),
        "kpiNewCustomers":
            MessageLookupByLibrary.simpleMessage("New customers"),
        "kpiPayments": MessageLookupByLibrary.simpleMessage("Payments"),
        "kpiReturning": MessageLookupByLibrary.simpleMessage("Returning"),
        "kpiRevenue": MessageLookupByLibrary.simpleMessage("Revenue"),
        "kpiRewards": MessageLookupByLibrary.simpleMessage("Rewards redeemed"),
        "kpiStamps": MessageLookupByLibrary.simpleMessage("Stamps issued"),
        "listView": MessageLookupByLibrary.simpleMessage("List"),
        "livePaymentsEmpty": MessageLookupByLibrary.simpleMessage(
            "No in-app payments yet today"),
        "livePaymentsEmptyMessage": MessageLookupByLibrary.simpleMessage(
            "Payments made in the app at this business appear here instantly."),
        "livePaymentsTitle":
            MessageLookupByLibrary.simpleMessage("Live payments"),
        "logOut": MessageLookupByLibrary.simpleMessage("Log out"),
        "logOutConfirm":
            MessageLookupByLibrary.simpleMessage("Log out of your account?"),
        "loyaltyProgram":
            MessageLookupByLibrary.simpleMessage("Loyalty program"),
        "manage": MessageLookupByLibrary.simpleMessage("Manage"),
        "mapView": MessageLookupByLibrary.simpleMessage("Map"),
        "minSpendLabel": MessageLookupByLibrary.simpleMessage(
            "Minimum spend per stamp (optional)"),
        "minSpendPerStamp": m4,
        "modeCustomer": MessageLookupByLibrary.simpleMessage("Customer"),
        "modeOwner": MessageLookupByLibrary.simpleMessage("Owner"),
        "modeStaff": MessageLookupByLibrary.simpleMessage("Staff"),
        "myQrInstructions": MessageLookupByLibrary.simpleMessage(
            "Show this to staff to collect a stamp when you pay by cash or card."),
        "myQrTitle": MessageLookupByLibrary.simpleMessage("My QR"),
        "nameLabel": MessageLookupByLibrary.simpleMessage("Full name"),
        "nameRequired":
            MessageLookupByLibrary.simpleMessage("Please enter your name"),
        "newCustomerCard":
            MessageLookupByLibrary.simpleMessage("New card — first stamp"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "noBusinessesMessage": MessageLookupByLibrary.simpleMessage(
            "Try another category or search term."),
        "noBusinessesTitle":
            MessageLookupByLibrary.simpleMessage("No businesses found"),
        "noCardYet": MessageLookupByLibrary.simpleMessage("No stamps yet"),
        "noProgramYet": MessageLookupByLibrary.simpleMessage(
            "No program yet — set one up to start issuing stamps."),
        "noStampsYet":
            MessageLookupByLibrary.simpleMessage("No stamps on this card yet."),
        "noTransactions": MessageLookupByLibrary.simpleMessage(
            "No transactions in this period"),
        "notSet": MessageLookupByLibrary.simpleMessage("Not set"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "notificationsSubtitle": MessageLookupByLibrary.simpleMessage(
            "Stamps, ready rewards and redemptions"),
        "onboardingBody1": MessageLookupByLibrary.simpleMessage(
            "Cafés, salons, barbers, car washes and more — every stamp card lives in one wallet."),
        "onboardingBody2": MessageLookupByLibrary.simpleMessage(
            "Pay with Apple Pay in the app and your stamp lands on your card instantly."),
        "onboardingBody3": MessageLookupByLibrary.simpleMessage(
            "Allow location to see participating businesses around you on the map."),
        "onboardingNearby": MessageLookupByLibrary.simpleMessage("Near you"),
        "onboardingStampChip": MessageLookupByLibrary.simpleMessage("+1 stamp"),
        "onboardingTitle1": MessageLookupByLibrary.simpleMessage(
            "All your loyalty cards in one place"),
        "onboardingTitle2": MessageLookupByLibrary.simpleMessage(
            "Pay and get stamped automatically"),
        "onboardingTitle3":
            MessageLookupByLibrary.simpleMessage("Find rewards near you"),
        "openingHours": MessageLookupByLibrary.simpleMessage("Opening hours"),
        "ownerActivityTab": MessageLookupByLibrary.simpleMessage("Activity"),
        "ownerBusinessTab": MessageLookupByLibrary.simpleMessage("Business"),
        "ownerProgramTab": MessageLookupByLibrary.simpleMessage("Program"),
        "ownerStaffTab": MessageLookupByLibrary.simpleMessage("Staff"),
        "payButton": MessageLookupByLibrary.simpleMessage("Pay"),
        "payHere": MessageLookupByLibrary.simpleMessage(
            "Pay here and get your stamp automatically"),
        "payTitle": m5,
        "payWithApplePay":
            MessageLookupByLibrary.simpleMessage("Pay with Apple Pay"),
        "paymentCancelled":
            MessageLookupByLibrary.simpleMessage("Payment cancelled"),
        "paymentSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Payment successful"),
        "perkFree": MessageLookupByLibrary.simpleMessage("Free to join"),
        "perkNoPassword": MessageLookupByLibrary.simpleMessage("No password"),
        "perkRewards": MessageLookupByLibrary.simpleMessage("Instant rewards"),
        "phone": MessageLookupByLibrary.simpleMessage("Phone"),
        "phoneInvalid": MessageLookupByLibrary.simpleMessage(
            "Enter a valid UAE mobile number"),
        "phoneLabel": MessageLookupByLibrary.simpleMessage("Phone number"),
        "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
        "previewTitle": MessageLookupByLibrary.simpleMessage(
            "Preview — what customers see"),
        "privacyNote": MessageLookupByLibrary.simpleMessage(
            "Your number is only used to sign you in. We never share it."),
        "processingPayment":
            MessageLookupByLibrary.simpleMessage("Processing payment…"),
        "profileSaved": MessageLookupByLibrary.simpleMessage("Profile updated"),
        "profileSubtitle": MessageLookupByLibrary.simpleMessage(
            "Tell us your name so businesses know who you are."),
        "profileTabTitle": MessageLookupByLibrary.simpleMessage("Profile"),
        "profileTitle":
            MessageLookupByLibrary.simpleMessage("Nice to meet you"),
        "programActive": MessageLookupByLibrary.simpleMessage("Program active"),
        "programActiveHint": MessageLookupByLibrary.simpleMessage(
            "Paused programs stop issuing stamps."),
        "programBuilderTitle":
            MessageLookupByLibrary.simpleMessage("Loyalty program"),
        "programCollect": m6,
        "programPaused":
            MessageLookupByLibrary.simpleMessage("Loyalty program paused"),
        "programPayment": m7,
        "programSaved": MessageLookupByLibrary.simpleMessage("Program saved"),
        "programVersionNote": MessageLookupByLibrary.simpleMessage(
            "Changing the target or reward creates a new version. Existing cards keep their original target until redeemed."),
        "programVisit": m8,
        "qrRefreshesIn": m9,
        "range30d": MessageLookupByLibrary.simpleMessage("30 days"),
        "range7d": MessageLookupByLibrary.simpleMessage("7 days"),
        "rangeToday": MessageLookupByLibrary.simpleMessage("Today"),
        "reachOut": MessageLookupByLibrary.simpleMessage("Contact"),
        "readyToRedeem":
            MessageLookupByLibrary.simpleMessage("Ready to redeem"),
        "receipt": MessageLookupByLibrary.simpleMessage("Receipt"),
        "recentTransactions":
            MessageLookupByLibrary.simpleMessage("Recent transactions"),
        "redeem": MessageLookupByLibrary.simpleMessage("Redeem"),
        "redeemInstructions": MessageLookupByLibrary.simpleMessage(
            "Show this code to staff. They will scan it or type the code to confirm."),
        "redeemSuccessMessage": m10,
        "redeemSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Reward redeemed!"),
        "redeemTitle":
            MessageLookupByLibrary.simpleMessage("Redeem your reward"),
        "reference": MessageLookupByLibrary.simpleMessage("Reference"),
        "removeStaff": MessageLookupByLibrary.simpleMessage("Remove"),
        "removeStaffConfirm": m11,
        "resendCode": MessageLookupByLibrary.simpleMessage("Resend code"),
        "resendIn": m12,
        "reward": MessageLookupByLibrary.simpleMessage("Reward"),
        "rewardConfirmed": MessageLookupByLibrary.simpleMessage(
            "Reward redeemed. The card starts again from zero."),
        "rewardHint":
            MessageLookupByLibrary.simpleMessage("e.g. a free haircut"),
        "rewardLabel": MessageLookupByLibrary.simpleMessage("Reward"),
        "rewardRequired":
            MessageLookupByLibrary.simpleMessage("Enter the reward"),
        "rewardToGive": MessageLookupByLibrary.simpleMessage("Reward to give"),
        "save": MessageLookupByLibrary.simpleMessage("Save"),
        "saveProgram": MessageLookupByLibrary.simpleMessage("Save program"),
        "scanCustomerHint": MessageLookupByLibrary.simpleMessage(
            "Point the camera at the QR in the customer’s app."),
        "scanCustomerTitle":
            MessageLookupByLibrary.simpleMessage("Scan customer QR"),
        "scanNext": MessageLookupByLibrary.simpleMessage("Scan next"),
        "scanRedemptionHint": MessageLookupByLibrary.simpleMessage(
            "Scan the reward QR or type the 6-digit code."),
        "scanRedemptionTitle":
            MessageLookupByLibrary.simpleMessage("Scan reward code"),
        "scanToCollect":
            MessageLookupByLibrary.simpleMessage("Scan to collect"),
        "searchBusinesses":
            MessageLookupByLibrary.simpleMessage("Search businesses"),
        "secured": MessageLookupByLibrary.simpleMessage(
            "Secure code · rotates automatically"),
        "showAtCounter":
            MessageLookupByLibrary.simpleMessage("Show at the counter"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "signInForQr":
            MessageLookupByLibrary.simpleMessage("Sign in to get your QR"),
        "signInForQrMessage": MessageLookupByLibrary.simpleMessage(
            "Your personal QR lets staff add stamps for you."),
        "signInSubtitle": MessageLookupByLibrary.simpleMessage(
            "We will text you a code to sign in. No password needed."),
        "signInTitle":
            MessageLookupByLibrary.simpleMessage("Enter your phone number"),
        "signInToSeeWallet":
            MessageLookupByLibrary.simpleMessage("Sign in to see your cards"),
        "signInToSeeWalletMessage": MessageLookupByLibrary.simpleMessage(
            "Your stamp cards live here once you collect your first stamp."),
        "skip": MessageLookupByLibrary.simpleMessage("Skip"),
        "smsNote": MessageLookupByLibrary.simpleMessage(
            "By continuing you agree to receive a one-time code by SMS."),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "staffAdded": MessageLookupByLibrary.simpleMessage("Staff added"),
        "staffEmpty": MessageLookupByLibrary.simpleMessage("No staff yet"),
        "staffEmptyMessage": MessageLookupByLibrary.simpleMessage(
            "Add staff by name and phone. They sign in with that number and get the scanner."),
        "staffPaymentsTab": MessageLookupByLibrary.simpleMessage("Payments"),
        "staffRedeemTab": MessageLookupByLibrary.simpleMessage("Redeem"),
        "staffStampTab": MessageLookupByLibrary.simpleMessage("Stamp"),
        "staffTitle": MessageLookupByLibrary.simpleMessage("Staff"),
        "stampAdded": m13,
        "stampConfirmed": m14,
        "stampExpiryNote": m15,
        "stampHistory": MessageLookupByLibrary.simpleMessage("Stamp history"),
        "stampSourceAdmin":
            MessageLookupByLibrary.simpleMessage("Added by support"),
        "stampSourcePayment":
            MessageLookupByLibrary.simpleMessage("In-app payment"),
        "stampSourceStaff":
            MessageLookupByLibrary.simpleMessage("Scanned by staff"),
        "stampsNeeded": MessageLookupByLibrary.simpleMessage("Stamps needed"),
        "stampsProgress": m16,
        "stampsToGo": m17,
        "statusFailed": MessageLookupByLibrary.simpleMessage("Failed"),
        "statusPending": MessageLookupByLibrary.simpleMessage("Pending"),
        "statusRefunded": MessageLookupByLibrary.simpleMessage("Refunded"),
        "statusSucceeded": MessageLookupByLibrary.simpleMessage("Paid"),
        "stepOf": m18,
        "switchBusiness":
            MessageLookupByLibrary.simpleMessage("Switch business"),
        "switchToCustomer":
            MessageLookupByLibrary.simpleMessage("Switch to customer mode"),
        "switchToOwner":
            MessageLookupByLibrary.simpleMessage("Switch to owner mode"),
        "switchToStaff":
            MessageLookupByLibrary.simpleMessage("Switch to staff mode"),
        "tabExplore": MessageLookupByLibrary.simpleMessage("Explore"),
        "tabProfile": MessageLookupByLibrary.simpleMessage("Profile"),
        "tabScan": MessageLookupByLibrary.simpleMessage("Scan"),
        "tabWallet": MessageLookupByLibrary.simpleMessage("Wallet"),
        "templates":
            MessageLookupByLibrary.simpleMessage("Start from a template"),
        "terms": MessageLookupByLibrary.simpleMessage("Terms"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "todayHours": m19,
        "todayTotal": m20,
        "tryAgain": MessageLookupByLibrary.simpleMessage("Try again"),
        "viewBusiness": MessageLookupByLibrary.simpleMessage("View"),
        "viewCard": MessageLookupByLibrary.simpleMessage("View card"),
        "visitHistory": MessageLookupByLibrary.simpleMessage("Visit history"),
        "visitHistoryEmpty": MessageLookupByLibrary.simpleMessage(
            "Your visits will appear here."),
        "waitingForStaff": MessageLookupByLibrary.simpleMessage(
            "Waiting for staff to confirm…"),
        "walletEmptyMessage": MessageLookupByLibrary.simpleMessage(
            "Pay at a participating business or show your QR to staff to collect your first stamp."),
        "walletEmptyTitle":
            MessageLookupByLibrary.simpleMessage("No stamp cards yet"),
        "walletSubtitle": m21,
        "walletTitle": MessageLookupByLibrary.simpleMessage("Wallet"),
        "workingAt": m22,
        "yourLoyalty": MessageLookupByLibrary.simpleMessage("Your loyalty"),
        "yourProgress": MessageLookupByLibrary.simpleMessage("Your progress")
      };
}
