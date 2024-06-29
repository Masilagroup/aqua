// @dart=2.9
part of 'content_page_bloc.dart';

abstract class ContentPageState extends Equatable {
  const ContentPageState();
}

class ContentPageInitial extends ContentPageState {
  final String loadMessage;

  ContentPageInitial(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}

class ContentPageLoaded extends ContentPageState {
  final ContentPageResponse contentPageResponse;

  ContentPageLoaded(this.contentPageResponse);
  @override
  List<Object> get props => [contentPageResponse];
}

class ContentPageError extends ContentPageState {
  final String errorMessage;

  ContentPageError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
