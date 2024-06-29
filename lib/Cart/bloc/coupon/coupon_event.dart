// @dart=2.9
part of 'coupon_bloc.dart';

abstract class CouponEvent extends Equatable {
  const CouponEvent();
}

class CouponCheck extends CouponEvent {
  final String couponCode;

  CouponCheck(this.couponCode);
  @override
  List<Object> get props => [couponCode];
}
