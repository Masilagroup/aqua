// @dart=2.9
import 'package:aqua/HomePage/bloc/homepage_bloc.dart';
import 'package:aqua/Navbar/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  HomepageBloc _homePageBloc;

  @override
  void initState() {
    super.initState();
    _homePageBloc = BlocProvider.of<HomepageBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _homePageBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomepageBloc, HomepageState>(
        builder: (BuildContext context, HomepageState state) {
          if (state is HomepageInitial) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('${state.loadMessage}'),
                ],
              ),
            );
          }
          if (state is HomepageError) {
            return Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    _homePageBloc..add(Fetch());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                ),
                Text(
                  '${state.errorMessage}',
                ),
              ],
            );
          }
          if (state is HomepageLoaded) {
            print('I am in Success');
            Navigator.of(context).pushReplacement(
              new MaterialPageRoute(
                builder: (context) => BottomNavBar(),
              ),
            );
          }
          return Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  _homePageBloc..add(Fetch());
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
              ),
              Text(
                '',
              ),
            ],
          );
        },
      ),
    );
  }
}
