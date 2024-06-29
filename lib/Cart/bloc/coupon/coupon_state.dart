// @dart=2.9
part of 'coupon_bloc.dart';

abstract class CouponState extends Equatable {
  const CouponState();
}

class CouponInitial extends CouponState {
  @override
  List<Object> get props => [];
}

class CartCouponLoaded extends CouponState {
  final CouponResponse couponResponse;

  CartCouponLoaded(this.couponResponse);
  @override
  List<Object> get props => [couponResponse];
}

class CartCouponError extends CouponState {
  final String errorMessage;

  CartCouponError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class CartCouponLoading extends CouponState {
  final String loadMessage;

  CartCouponLoading(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}
