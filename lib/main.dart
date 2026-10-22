import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/helper/helper.dart';
import 'core/network/realtime_service.dart';
import 'core/router/router.dart';
import 'core/styles/app_theme.dart';
import 'core/translations/l10n.dart';
import 'core/utils/app_notifier.dart';
import 'core/utils/injections.dart';
import 'features/auth/data/data_sources/local/auth_shared_prefs.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'shared/presentation/session/session_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await initInjections();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppNotifier()),
        BlocProvider(
          create: (_) => SessionCubit(
            getMeUseCase: sl<GetMeUseCase>(),
            logoutUseCase: sl<LogoutUseCase>(),
            authPrefs: sl<AuthSharedPrefs>(),
            realtime: sl<RealtimeService>(),
          ),
        ),
      ],
      child: Consumer<AppNotifier>(
        builder: (context, value, child) {
          ScreenUtil.init(
            context,
            designSize: const Size(440, 956),
            minTextAdapt: true,
            splitScreenMode: true,
          );
          return MaterialApp(
            title: 'Loyalty',
            scaffoldMessengerKey: snackBarKey,
            onGenerateRoute: AppRouter.generateRoute,
            themeMode: ThemeMode.light,
            theme: buildAppTheme(value.brandColor),
            debugShowCheckedModeBanner: false,
            // English only for the MVP; layouts stay RTL-ready for later.
            locale: const Locale('en'),
            supportedLocales: const [Locale('en')],
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            navigatorKey: Helper.navigatorKey,
            home: const SplashPage(),
            // Dark status bar by default; brand-coloured screens (sign-in)
            // override it with their own AnnotatedRegion.
            builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: child!,
            ),
          );
        },
      ),
    );
  }
}
