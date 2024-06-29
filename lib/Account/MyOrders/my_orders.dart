// @dart=2.9
import 'package:aqua/Account/MyOrders/bloc/order_repository.dart';
import 'package:aqua/Account/MyOrders/bloc/orders_bloc.dart';
import 'package:aqua/Account/MyOrders/bloc/orders_response.dart';
import 'package:aqua/Account/MyOrders/ordered_item.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrders extends StatefulWidget {
  MyOrders({Key key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrdersBloc _ordersBloc;
  @override
  void initState() {
    super.initState();
    _ordersBloc = BlocProvider.of<OrdersBloc>(context)..add(OrdersListFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
          bloc: _ordersBloc,
          builder: (context, state) {
            if (state is OrdersInitial) {
              return Center(
                child: AquaProgressIndicator(),
              );
            }
            if (state is OrdersListLoading) {
              return Center(
                child: AquaProgressIndicator(),
              );
            }
            if (state is OrdersListError) {
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
                        _ordersBloc..add(OrdersListFetch());
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
            if (state is OrdersListLoaded) {
              OrdersListRepository ordersListRepository =
                  OrdersListRepository();
              var sortedList = ordersListRepository
                  .sortOrders(state.ordersListResponse.data);
              return DefaultTabController(
                length: 3,
                child: Scaffold(
                  backgroundColor: AppColors.WHITE_BACKGROUND,
                  appBar: AppBar(
                    centerTitle: true,
                    iconTheme: Theme.of(context).iconTheme,
                    backgroundColor: AppColors.WHITE_COLOR,
                    title: Text(
                      AppLocalizations.of(context).translate('myOrders'),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    bottom: TabBar(
                      labelColor: AppColors.BLACK_COLOR,
                      labelStyle: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                      indicatorColor: AppColors.BLACK_COLOR,
                      tabs: [
                        Tab(
                          text: AppLocalizations.of(context)
                              .translate('processing'),
                        ),
                        Tab(
                          text: AppLocalizations.of(context)
                              .translate('delivered'),
                        ),
                        Tab(
                          text:
                              AppLocalizations.of(context).translate('failed'),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      ProcessOrders(
                        processedOrders: sortedList[0],
                      ),
                      DeliveredOrders(
                        deliveredOrders: sortedList[1],
                      ),
                      CancelledOrders(
                        cancelledOrders: sortedList[2],
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                    ),
                    onPressed: () {
                      _ordersBloc..add(OrdersListFetch());
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('reload'),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ProcessOrders extends StatefulWidget {
  final List<OrderListData> processedOrders;
  const ProcessOrders({Key key, this.processedOrders}) : super(key: key);
  @override
  _ProcessOrdersState createState() => _ProcessOrdersState();
}

class _ProcessOrdersState extends State<ProcessOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      body: Container(
        margin: const EdgeInsets.all(5),
        child: ListView.builder(
          //   padding: const EdgeInsets.all(10.0),
          cacheExtent: 1000,
          itemCount: widget.processedOrders.length,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return OrderedItem(
              orderListData: widget.processedOrders[index],
              orderType: 0,
            );
          },
        ),
      ),
    );
  }
}

class DeliveredOrders extends StatefulWidget {
  final List<OrderListData> deliveredOrders;

  const DeliveredOrders({Key key, this.deliveredOrders}) : super(key: key);

  @override
  _DeliveredOrdersState createState() => _DeliveredOrdersState();
}

class _DeliveredOrdersState extends State<DeliveredOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      body: Container(
        margin: const EdgeInsets.all(5),
        child: ListView.builder(
          //   padding: const EdgeInsets.all(10.0),
          cacheExtent: 1000,
          itemCount: widget.deliveredOrders.length,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return OrderedItem(
              orderListData: widget.deliveredOrders[index],
              orderType: 1,
            );
          },
        ),
      ),
    );
  }
}

class CancelledOrders extends StatefulWidget {
  final List<OrderListData> cancelledOrders;

  const CancelledOrders({Key key, this.cancelledOrders}) : super(key: key);

  @override
  _CancelledOrdersState createState() => _CancelledOrdersState();
}

class _CancelledOrdersState extends State<CancelledOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      body: Container(
        margin: const EdgeInsets.all(5),
        child: ListView.builder(
          //   padding: const EdgeInsets.all(10.0),
          cacheExtent: 1000,
          itemCount: widget.cancelledOrders.length,
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return OrderedItem(
              orderListData: widget.cancelledOrders[index],
              orderType: 2,
            );
          },
        ),
      ),
    );
  }
}
