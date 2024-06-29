// @dart=2.9
import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/notifications/notifications_model.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  NotificationsModel _notifications = NotificationsModel();
  bool isProgress = true;
  Future<NotificationsModel> getNotifications() async {
    final notifictions = await apiBaseHelper.get(
      Constants.BASE_URL + Constants.NOTIFICATIONS,
    );
    setState(() {
      isProgress = false;
      _notifications = NotificationsModel.fromJson(notifictions);
    });
    return NotificationsModel.fromJson(notifictions);
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 1.0,
          titleSpacing: 30.0,
          backgroundColor: AppColors.WHITE_COLOR,
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            AppLocalizations.of(context).translate('notifications'),
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            child: isProgress
                ? (Center(child: AquaProgressIndicator()))
                : (_notifications.status == 200
                    ? Container(
                        margin: EdgeInsets.only(top: 15.0, left: 15, right: 15),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _notifications.data.length,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Card(
                                child: Container(
                                  margin: EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ImageIcon(
                                          AssetImage("assets/bell.png"),
                                          color: Theme.of(context).primaryColor,
                                          size: 25,
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 3),
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                _notifications
                                                    .data[index].title,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                _notifications
                                                    .data[index].message,
                                                style:
                                                    TextStyle(fontSize: 16.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              );
                            }))
                    : Container(
                        child: Text(AppLocalizations.of(context)
                            .translate('something_went_wrong'))))));
  }
}
