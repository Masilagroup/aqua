// @dart=2.9
import 'package:aqua/Account/MyProfile/bloc/my_profile_bloc.dart';
import 'package:aqua/Account/MyProfile/my_profile.dart';
import 'package:aqua/Account/authentication_bloc/authentication_bloc.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressItem extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onSelect;
  final Map<String, dynamic> userData;

  AddressItem({Key key, this.isSelected, this.onSelect, this.userData})
      : super(key: key);

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.onSelect,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.WHITE_COLOR,
          border: Border(
            bottom: BorderSide(
              color: AppColors.LIGHT_GRAY_BGCOLOR,
              width: 0.2,
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SelectedIndicator(
                    isSelected: widget.isSelected,
                  ),
                  //   _selectedIndicator(widget.isSelected),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            widget.userData['data']['user_name'],
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                'House: ${widget.userData['data']['user_house']}, ',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Block:${widget.userData['data']['user_block']}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${widget.userData['data']['user_street']}, ',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${widget.userData['data']['user_area']} ',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${widget.userData['data']['user_country_name']} ',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                '',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Ph: ',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${widget.userData['data']['user_mobile']} ',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: CircleBorder(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                            create: (context) => MyProfileBloc(),
                            child: MyProfile(
                              userData: widget.userData,
                            )),
                        fullscreenDialog: true,
                      ),
                    ).then((value) {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoggedIn());
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.edit,
                      color: AppColors.BLACK_COLOR,
                      size: 20,
                    ),
                  ),
                  splashColor: AppColors.SPLASH_COLOR,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _selectedIndicator(bool isSelected) {
  //   return isSelected
  //       ? Container(
  //           width: 20,
  //           height: 20,
  //           alignment: Alignment.center,
  //           margin: const EdgeInsets.all(5),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(50),
  //             color: AppColors.WHITE_COLOR,
  //             border: Border.all(
  //               color: AppColors.BLACK_COLOR,
  //               width: 2,
  //             ),
  //           ),
  //           child: Container(
  //             width: 10,
  //             height: 10,
  //             alignment: Alignment.center,
  //             // margin: const EdgeInsets.all(5),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(50),
  //               color: AppColors.BLACK_COLOR,
  //             ),
  //           ),
  //         )
  //       : Container(
  //           width: 20,
  //           height: 20,
  //           alignment: Alignment.centerLeft,
  //           margin: const EdgeInsets.all(5),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(50),
  //             color: AppColors.WHITE_COLOR,
  //             border: Border.all(
  //               color: AppColors.BLACK_COLOR,
  //               width: 2,
  //             ),
  //           ),
  //         );
  // }
}

class SelectedIndicator extends StatelessWidget {
  final isSelected;
  const SelectedIndicator({Key key, @required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.WHITE_COLOR,
              border: Border.all(
                color: AppColors.BLACK_COLOR,
                width: 2,
              ),
            ),
            child: Container(
              width: 10,
              height: 10,
              alignment: Alignment.center,
              // margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.BLACK_COLOR,
              ),
            ),
          )
        : Container(
            width: 20,
            height: 20,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.WHITE_COLOR,
              border: Border.all(
                color: AppColors.BLACK_COLOR,
                width: 2,
              ),
            ),
          );
  }
}
