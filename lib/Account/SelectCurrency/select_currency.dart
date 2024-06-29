// @dart=2.9
import 'package:aqua/Account/SelectCurrency/bloc/currency_bloc.dart';
import 'package:aqua/Account/AddressList/address_item.dart';
import 'package:aqua/Navbar/navbar.dart';
import 'package:aqua/global.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedCurrency extends StatelessWidget {
  const SelectedCurrency({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CurrencyBloc currencyBloc = BlocProvider.of<CurrencyBloc>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: AppColors.WHITE_COLOR,
          title: Text(
            AppLocalizations.of(context).translate('currency'),
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: BlocProvider(
          create: (_) => CurrencyBloc()..add(CurrencyFetch()),
          child: BuildCurrencyList(),
        ));
  }
}

class BuildCurrencyList extends StatefulWidget {
  const BuildCurrencyList({Key key}) : super(key: key);

  @override
  _BuildCurrencyListState createState() => _BuildCurrencyListState();
}

class _BuildCurrencyListState extends State<BuildCurrencyList> {
  int selectedIndex;
  CurrencyBloc _currencyBloc;

  @override
  Widget build(BuildContext context) {
    _currencyBloc = BlocProvider.of<CurrencyBloc>(context);
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        if (state is CurrencyInitial) {
          return Center(child: AquaProgressIndicator());
        }
        if (state is CurrencyError) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    _currencyBloc.add(CurrencyFetch());
                  },
                ),
                Text(
                  '${state.errorMessage}',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          );
        }
        if (state is CurrencyLoaded) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              cacheExtent: 10000,
              itemCount: state.currencyList.currencyData.length,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                print(state.currencyList.currencyData[index].currencyCode);
                return InkWell(
                  onTap: () async {
                    print("***");

                    prefs.setInt("currencyCode",
                        state.currencyList.currencyData[index].currencyId);

                    print(state.currencyList.currencyData[index].currencyId);
                    _currencyBloc..add(CurrencySelected(index));

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavBar(),
                      ),
                    );

                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (context) => BottomNavBar(),
                    //   ),
                    // );das
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SelectedIndicator(
                            isSelected: (state.selectedIndex ?? -1) == index),
                        CircleAvatar(
                            child: Image(
                          image: AssetImage(
                              "assets/flags/${state.currencyList.currencyData[index].currencyCode}.png"),
                        )),
                        Padding(
                            padding: const EdgeInsets.only(
                          left: 5,
                        )),
                        Text(
                          '${state.currencyList.currencyData[index].currencyName} - ${state.currencyList.currencyData[index].currencyCode}',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
