// @dart=2.9
import 'dart:async';

import 'package:aqua/Account/ContentPages/bloc/content_page_repository.dart';
import 'package:aqua/Account/ContentPages/bloc/content_page_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'content_page_event.dart';
part 'content_page_state.dart';

class ContentPageBloc extends Bloc<ContentPageEvent, ContentPageState> {
  ContentPageRepository _contentPageRepository = ContentPageRepository();
  @override
  ContentPageState get initialState => ContentPageInitial('Loading...');

  @override
  Stream<ContentPageState> mapEventToState(
    ContentPageEvent event,
  ) async* {
    if (event is ContentPageFetch) {
      yield ContentPageInitial('Loading..');
      try {
        final contentPageData = await _contentPageRepository.getContentPageData(
          event.keywordString,
        );

        if (contentPageData.message == 'success') {
          print('Inside Content Page');
          yield ContentPageLoaded(contentPageData);
        } else {
          yield ContentPageError(contentPageData.message);
        }
      } catch (e) {
        yield ContentPageError(e.toString());
      }
    }
  }
}
