// @dart=2.9
import 'package:aqua/Navbar/navbar.dart';
import 'package:aqua/translation/AppLanguage.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelecttion extends StatelessWidget {
  const LanguageSelecttion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double globalMediaWidth = MediaQuery.of(context).size.width;

    var appLanguage = Provider.of<AppLanguage>(context);

    return Container(
      // color: AppColors.APP_PRIMARY,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10.0),
      //   side: BorderSide(color: Colors.black87, width: 0.2),
      // ),
      // elevation: 1.0,
      decoration: BoxDecoration(color: AppColors.WHITE_COLOR),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 50.0),
            child: new Image(
              // width: globalMediaWidth / 2.0,
              // height: 50.0,
              fit: BoxFit.fill,
              image: new AssetImage(
                'assets/images/aqua-big_low.png',
              ),
            ),
          ),
          Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 15),
                height: 45,
                width: 180,
                child: ElevatedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("en"));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BottomNavBar(),
                      ),
                    );
                  },
                  // color: AppColors.WHITE_COLOR,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.WHITE_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.BLACK_COLOR,
                        ),
                      )),

                  child: new Text(
                    'English',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  // shape: new RoundedRectangleBorder(
                  //   //    borderRadius: BorderRadius.circular(20),
                  //   side: BorderSide(
                  //     color: AppColors.BLACK_COLOR,
                  //   ),
                  // ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(5)),
              Container(
                margin: const EdgeInsets.only(top: 10),
                height: 45,
                width: 180,
                child: ElevatedButton(
                  onPressed: () {
                    appLanguage.changeLanguage(Locale("ar"));
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BottomNavBar(),
                      ),
                    );
                  },
                  //   color: AppColors.WHITE_COLOR,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.WHITE_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: AppColors.BLACK_COLOR,
                        ),
                      )),
                  child: new Text(
                    'العربية',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  // shape: new RoundedRectangleBorder(
                  //   //      borderRadius: BorderRadius.circular(20),
                  //   side: BorderSide(
                  //     color: AppColors.BLACK_COLOR,
                  //   ),
                  // ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(60)),
              new Text(
                AppLocalizations.of(context).translate('poweredbyAquaFashion'),
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
