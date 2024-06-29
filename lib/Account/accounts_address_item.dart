// @dart=2.9
import 'package:aqua/Account/AddressList/address_item.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AccountAddressItem extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onSelect;

  AccountAddressItem({Key key, this.isSelected, this.onSelect})
      : super(key: key);

  @override
  _AccountAddressItemState createState() => _AccountAddressItemState();
}

class _AccountAddressItemState extends State<AccountAddressItem> {
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
                  SelectedIndicator(isSelected: widget.isSelected),
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
                            'Radha Krishna',
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
                                'Plot No 251,',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Phase 4',
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
                                'Abdul Al-Salem St,',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Block 4',
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
                                'Kuwait',
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
                                'Ph:',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(
                                '+965 66780325',
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
                    print('Clicked on Settings');
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
