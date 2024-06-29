// @dart=2.9
part of 'content_page_bloc.dart';

abstract class ContentPageEvent extends Equatable {
  const ContentPageEvent();
}

class ContentPageFetch extends ContentPageEvent {
  final String keywordString;

  const ContentPageFetch({
    @required this.keywordString,
  });

  @override
  List<Object> get props => [keywordString];
}
