// @dart=2.9
import 'package:aqua/Account/ContentPages/bloc/content_page_bloc.dart';
import 'package:aqua/Account/ContentPages/bloc/content_page_response.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class ContentPage extends StatefulWidget {
  final String pageName;
  ContentPage({
    Key key,
    this.pageName,
  }) : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  ContentPageBloc _contentPageBloc;
  @override
  void initState() {
    super.initState();
    _contentPageBloc = ContentPageBloc()
      ..add(
        ContentPageFetch(keywordString: widget.pageName),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentPageBloc, ContentPageState>(
        bloc: _contentPageBloc,
        builder: (context, state) {
          if (state is ContentPageInitial) {
            return Scaffold(
              body: Center(
                child: AquaProgressIndicator(),
              ),
            );
          }
          if (state is ContentPageError) {
            return Scaffold(
              body: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                      ),
                      onPressed: () {
                        _contentPageBloc
                          ..add(
                            ContentPageFetch(keywordString: widget.pageName),
                          );
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
              ),
            );
          }
          if (state is ContentPageLoaded) {
            return ContentLoadPage(
              contentPageResponse: state.contentPageResponse,
            );
          }
          return Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  _contentPageBloc
                    ..add(
                      ContentPageFetch(keywordString: widget.pageName),
                    );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
              ),
              Text(
                AppLocalizations.of(context).translate('reload'),
              ),
            ],
          );
        });
  }
}

class ContentLoadPage extends StatelessWidget {
  final ContentPageResponse contentPageResponse;
  const ContentLoadPage({Key key, this.contentPageResponse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double globalMediaWidth = MediaQuery.of(context).size.width;
    print(contentPageResponse.contentData.content);
    return Scaffold(
      backgroundColor: AppColors.WHITE_COLOR,
      appBar: new AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          contentPageResponse.contentData.title.toUpperCase(),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: contentPageResponse.contentData.image != '',
              child: AspectRatio(
                aspectRatio: globalMediaWidth / globalMediaWidth,
                child: Container(
                  decoration: new BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      alignment: FractionalOffset.bottomLeft,
                      image: NetworkImage(
                        '${contentPageResponse.contentData.image}',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20, left: 20, right: 20.0),
              child: Html(data: contentPageResponse.contentData.content),
            )
          ],
        ),
      ),
    );
  }
}
