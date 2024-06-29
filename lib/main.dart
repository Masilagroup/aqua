// @dart=2.9
import 'package:aqua/HomePage/bloc/homepage_repository.dart';
import 'package:aqua/HomePage/homepage.dart';
import 'package:aqua/Navbar/navbar.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'Account/SelectCurrency/bloc/currency_repository.dart';
import 'Splash/splash.dart';
import 'translation/AppLanguage.dart';
import 'translation/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  const MyApp({Key key, this.appLanguage}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        HomePageRepository _homePageRepository = HomePageRepository();
        _homePageRepository.checkDeviceToken().then((value) {
          Constants.deviceUUID = value;

          print(Constants.deviceUUID);
        });
        CurrencyRepository _currencyRepository = CurrencyRepository();
        _currencyRepository.retriveCurrency().then((value) {
          Constants.selectedCurrency = value.currencyId;
          print(Constants.selectedCurrency);
        });
        Constants.selectedLang = model.appLocal.languageCode;
        return MaterialApp(
          title: 'Aqua Fashion',
          debugShowCheckedModeBanner: false,
          locale: model.appLocal,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', 'AR'),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          theme: ThemeData(
              //  scaffoldBackgroundColor: AppColors.SCAFFOLD_COLOR,
              brightness: Brightness.light,
              primaryColor: AppColors.APP_PRIMARY,
              accentColor: AppColors.BLACK_COLOR,
              dividerColor: AppColors.LIGHT_GRAY_BGCOLOR,
              iconTheme: IconThemeData(
                  color: AppColors.BLACK_COLOR, opacity: 1.0, size: 25.0),
              textTheme: new TextTheme(
                button: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),
                overline: TextStyle(
                    color: AppColors.TEXT_GRAY_COLOR,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),
                caption: TextStyle(
                    color: AppColors.BLACK_COLOR,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),

                // headline1: TextStyle(
                //     color: AppColors.BLACK_COLOR,
                //     fontSize: 20.0,
                //     fontWeight: FontWeight.w600,
                //     fontFamily: model.appLocal.languageCode == 'en'
                //         ? 'Montserrat'
                //         : 'Almarai',
                //     fontStyle: FontStyle.normal),
                // subhead: TextStyle(
                //     color: AppColors.WHITE_COLOR,
                //     fontSize: 16.0,
                //     fontWeight: FontWeight.w500,
                //     fontFamily: model.appLocal.languageCode == 'en'
                //         ? 'Montserrat'
                //         : 'Almarai',
                //     fontStyle: FontStyle.normal),
                // title: TextStyle(
                //     color: AppColors.BLACK_COLOR,
                //     fontSize: 13.0,
                //     fontWeight: FontWeight.w500,
                //     fontFamily: model.appLocal.languageCode == 'en'
                //         ? 'Montserrat'
                //         : 'Almarai',
                //     fontStyle: FontStyle.normal),
                subtitle1: TextStyle(
                    color: AppColors.BLACK_COLOR,
                    fontSize: 11.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),
                bodyText1: TextStyle(
                    color: AppColors.BLACK_COLOR,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),
                bodyText2: TextStyle(
                    color: AppColors.BLACK_COLOR,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),
                headline1: TextStyle(
                    color: AppColors.BLACK_COLOR,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),
                headline2: TextStyle(
                    color: AppColors.BLACK_COLOR,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),
                headline3: TextStyle(
                    color: AppColors.BLACK_COLOR,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),
                headline4: TextStyle(
                    color: AppColors.WHITE_COLOR,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: model.appLocal.languageCode == 'en'
                        ? 'Montserrat'
                        : 'Almarai',
                    fontStyle: FontStyle.normal),
              ),
              dialogTheme: new DialogTheme(
                  contentTextStyle: Theme.of(context).textTheme.bodyText2)),
          home: Splash(),
          builder: (context, child) {
            final data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(textScaleFactor: 1),
              child: child,
            );
          },
        );
      }),
    );
  }
}
