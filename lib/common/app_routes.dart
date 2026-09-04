import 'package:flutter/material.dart';

import '../core/error/error_page.dart';
import '../features/account/presentation/pages/coupon_list/page/coupon_list_page.dart';
import '../features/account/presentation/pages/fav_location/page/confirm_fav_location.dart';
import '../features/account/presentation/pages/help/help.dart';
import '../features/account/presentation/pages/outstation/page/outstation_page.dart';
import '../features/account/presentation/pages/settings/page/delete_account.dart';
import '../features/account/presentation/pages/outstation/widget/outstation_offered_page.dart';
import '../features/account/presentation/pages/paymentgateways.dart';
import '../features/account/presentation/pages/settings/page/home_layout.dart';
import '../features/account/presentation/pages/settings/page/terms_privacy_policy_view_page.dart';
import '../features/account/presentation/pages/support_ticket/page/support_ticket.dart';
import '../features/account/presentation/pages/support_ticket/page/view_ticket_page.dart';
import '../features/account/presentation/pages/wallet/widget/card_list_widget.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/otp_page.dart';
import '../features/auth/presentation/pages/signup_mobile_page.dart';
import '../features/bookingpage/presentation/page/booking/page/edit_location_page.dart';
import '../features/home/presentation/pages/on_going_rides.dart';
import '../features/userprofile/presentation/pages/driver_profile_pages.dart';
import 'app_arguments.dart';
import '../features/account/presentation/pages/admin_chat/page/admin_chat.dart';
import '../features/account/presentation/pages/settings/page/faq_page.dart';
import '../features/account/presentation/pages/settings/page/map_settings.dart';
import '../features/account/presentation/pages/sos/page/sos_page.dart';
import '../features/bookingpage/presentation/page/review/page/review_page.dart';
import '../features/account/presentation/pages/account_page.dart';
import '../features/account/presentation/pages/complaint/page/complaint_list.dart';
import '../features/account/presentation/pages/complaint/page/complaint_page.dart';
import '../features/account/presentation/pages/profile/page/profile_info_page.dart';
import '../features/account/presentation/pages/fav_location/page/fav_location.dart';
import '../features/account/presentation/pages/history/page/history_page.dart';
import '../features/account/presentation/pages/notification/page/notification_page.dart';
import '../features/account/presentation/pages/refferal/page/referral_page.dart';
import '../features/account/presentation/pages/settings/page/settings_page.dart';
import '../features/account/presentation/pages/history/page/trip_summary_history.dart';
import '../features/account/presentation/pages/profile/page/update_details.dart';
import '../features/account/presentation/pages/wallet/page/wallet_page.dart';
import '../features/auth/presentation/pages/auth_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/refferal_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/update_password_page.dart';
import '../features/home/presentation/pages/destination_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/auth/presentation/pages/verify_page.dart';
import '../features/bookingpage/presentation/page/booking/page/booking_page.dart';
import '../features/home/presentation/pages/confirm_location_page.dart';
import '../features/landing/presentation/page/landing_page.dart';
import '../features/language/presentation/page/choose_language_page.dart';
import '../features/loading/presentation/pages/loader_page.dart';
import '../features/bookingpage/presentation/page/invoice/page/invoice_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoutes(RouteSettings routeSettings) {
    late Route<dynamic> pageRoute;
    Object? arg = routeSettings.arguments;

    switch (routeSettings.name) {
      case LoaderPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const LoaderPage(),
        );
      case LandingPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const LandingPage(),
        );
        break;
      case ChooseLanguagePage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ChooseLanguagePage(
            arg: arg as ChooseLanguageArguments,
          ),
        );
        break;
      case AuthPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const AuthPage(),
        );
        break;
      case VerifyPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => VerifyPage(
            arg: arg as VerifyArguments,
          ),
        );
        break;
      case HelpPage.routeName:
        pageRoute = MaterialPageRoute(builder: (context) => const HelpPage());
        break;
      case RegisterPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => RegisterPage(
            arg: arg as RegisterPageArguments,
          ),
        );
        break;
      case RefferalPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const RefferalPage(),
        );
        break;
      case ForgotPasswordPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ForgotPasswordPage(
            arg: arg as ForgotPasswordPageArguments,
          ),
        );
        break;
      case UpdatePasswordPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => UpdatePasswordPage(
            arg: arg as UpdatePasswordPageArguments,
          ),
        );
        break;
      case HomePage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
        break;
      case DestinationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => DestinationPage(
            arg: arg as DestinationPageArguments,
          ),
        );
        break;
      case ConfirmLocationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ConfirmLocationPage(
            arg: arg as ConfirmLocationPageArguments,
          ),
        );
        break;
      case OnGoingRidesPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              OnGoingRidesPage(arg: arg as OnGoingRidesPageArguments),
        );
        break;
      case InvoicePage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => InvoicePage(
            arg: arg as InvoicePageArguments,
          ),
        );
        break;
      case ReviewPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ReviewPage(
            arg: arg as ReviewPageArguments,
          ),
        );
        break;
      case HistoryTripSummaryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              HistoryTripSummaryPage(arg: arg as TripHistoryPageArguments),
        );
        break;
      case BookingPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => BookingPage(
            arg: arg as BookingPageArguments,
          ),
        );
        break;
      case DeleteAccount.routeName:
        pageRoute =
            MaterialPageRoute(builder: (context) => const DeleteAccount());
        break;
      // animation sliding
      case AccountPage.routeName:
        pageRoute = PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              AccountPage(arg: arg as AccountPageArguments),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(-1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final curvedAnimation =
                CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
        break;
      case ProfileInfoPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              ProfileInfoPage(arg: arg as ProfileInfoPageArguments),
        );
        break;
      case NotificationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const NotificationPage(),
        );
      case HistoryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => HistoryPage(arg: arg as HistoryPageArguments),
        );
        break;
      case OutstationHistoryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              OutstationHistoryPage(arg: arg as OutstationHistoryPageArguments),
        );
        break;
      case OutStationOfferedPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => OutStationOfferedPage(
              args: arg as OutStationOfferedPageArguments),
        );
        break;
      case ReferralPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ReferralPage(
            args: arg as ReferralArguments,
          ),
        );
        break;
      case ComplaintListPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ComplaintListPage(
            args: arg as ComplaintListPageArguments,
          ),
        );
        break;
      case ComplaintPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ComplaintPage(
            arg: arg as ComplaintPageArguments,
          ),
        );
        break;
      case UpdateDetails.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => UpdateDetails(
            arg: arg as UpdateDetailsArguments,
          ),
        );
        break;
      case SettingsPage.routeName:
        pageRoute = MaterialPageRoute(
            builder: (context) => SettingsPage(
                  args: arg as SettingsPageArguments,
                ));
        break;
      case FaqPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const FaqPage(),
        );
        break;
      case MapSettingsPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const MapSettingsPage(),
        );
        break;
      case FavoriteLocationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              FavoriteLocationPage(arg: arg as FavouriteLocationPageArguments),
        );
        break;
      case WalletHistoryPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) =>
              WalletHistoryPage(arg: arg as WalletPageArguments),
        );
        break;

      case SosPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => SosPage(arg: arg as SOSPageArguments),
        );
        break;

      case AdminChat.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => AdminChat(arg: arg as AdminChatPageArguments),
        );
        break;
      case ConfirmFavLocation.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ConfirmFavLocation(
            arg: arg as ConfirmFavouriteLocationPageArguments,
          ),
        );
        break;
      case PaymentGatwaysPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => PaymentGatwaysPage(
            arg: arg as PaymentGateWayPageArguments,
          ),
        );
        break;
      case CardListWidget.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => CardListWidget(
            arg: arg as PaymentMethodArguments,
          ),
        );
        break;
      case SupportTicketPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => SupportTicketPage(
            args: arg as SupportTicketPageArguments,
          ),
        );
        break;
      case ViewTicketPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => ViewTicketPage(
            args: arg as ViewTicketPageArguments,
          ),
        );
        break;
      case EditLocationPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => EditLocationPage(
            arg: arg as EditLocationPageArguments,
          ),
        );
        break;
      case TermsPrivacyPolicyViewPage.routeName:
        pageRoute = MaterialPageRoute(
            builder: (context) => TermsPrivacyPolicyViewPage(
                  args: arg as TermsAndPrivacyPolicyArguments,
                ));
        break;
      case LoginPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      case OtpPage.routeName:
        pageRoute = MaterialPageRoute(
            builder: (context) => OtpPage(
                  arg: arg as OtpPageArguments,
                ));
        break;
      case SignupMobilePage.routeName:
        pageRoute = MaterialPageRoute(
            builder: (context) => SignupMobilePage(
                  arg: arg as SignupMobilePageArguments,
                ));
        break;
      case CouponsListPage.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => CouponsListPage(
            args: arg as CouponListPageArguments,
          ),
        );
        break;
      case HomeLayout.routeName:
        pageRoute = MaterialPageRoute(
          builder: (context) => const HomeLayout(),
        );
        break;
      case DriverProfilePage.routeName:
        pageRoute = MaterialPageRoute(
            builder: (context) => const DriverProfilePage(),
            settings: routeSettings);
      default:
        pageRoute = MaterialPageRoute(
          builder: (context) => const ErrorPage(),
        );
    }
    return pageRoute;
  }

  static Route<dynamic> onUnknownRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (context) => const ErrorPage());
  }
}
