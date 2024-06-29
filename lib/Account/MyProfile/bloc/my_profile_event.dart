// @dart=2.9
part of 'my_profile_bloc.dart';

abstract class MyProfileEvent extends Equatable {
  const MyProfileEvent();
}

class ProfileEmailChanged extends MyProfileEvent {
  final String email;

  const ProfileEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class ProfilePasswordChanged extends MyProfileEvent {
  final String password;

  const ProfilePasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class ProfileNameChanged extends MyProfileEvent {
  final String name;

  const ProfileNameChanged({@required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'NameChanged { Name: $name }';
}

class ProfileConfirmChanged extends MyProfileEvent {
  final String cPassword;

  const ProfileConfirmChanged({@required this.cPassword});

  @override
  List<Object> get props => [cPassword];

  @override
  String toString() => 'cPassword { confirm password: $cPassword }';
}

class ProfilePhoneChanged extends MyProfileEvent {
  final String phoneNum;

  const ProfilePhoneChanged({@required this.phoneNum});

  @override
  List<Object> get props => [phoneNum];

  @override
  String toString() => 'PhoneChanged { Name: $phoneNum }';
}

class ProfileCountryChanged extends MyProfileEvent {
  final int countryId;

  const ProfileCountryChanged({@required this.countryId});

  @override
  List<Object> get props => [countryId];

  @override
  String toString() => 'PhoneChanged { Name: $countryId }';
}

class ProfileAreaChanged extends MyProfileEvent {
  final String area;

  const ProfileAreaChanged({@required this.area});

  @override
  List<Object> get props => [area];

  @override
  String toString() => 'PhoneChanged { Name: $area }';
}

class ProfileStreetChanged extends MyProfileEvent {
  final int street;

  const ProfileStreetChanged({@required this.street});

  @override
  List<Object> get props => [street];

  @override
  String toString() => 'PhoneChanged { Name: $street }';
}

class ProfileBlockChanged extends MyProfileEvent {
  final int block;

  const ProfileBlockChanged({@required this.block});

  @override
  List<Object> get props => [block];

  @override
  String toString() => 'PhoneChanged { Name: $block }';
}

class ProfileHouseChanged extends MyProfileEvent {
  final int house;

  const ProfileHouseChanged({@required this.house});

  @override
  List<Object> get props => [house];

  @override
  String toString() => 'PhoneChanged { Name: $house }';
}

class ProfileDataRetrive extends MyProfileEvent {
  @override
  List<Object> get props => [];
}

class ProfileWithUpdatePressed extends MyProfileEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final int countryId;
  final String area;
  final String street;
  final String block;
  final String house;
  final String accessToken;
  final int userId;
  final String address;

  const ProfileWithUpdatePressed({
    @required this.area,
    @required this.street,
    @required this.block,
    @required this.house,
    @required this.firstName,
    @required this.lastName,
    @required this.mobile,
    @required this.countryId,
    @required this.email,
    @required this.accessToken,
    @required this.userId,
    @required this.address,
  });

  @override
  List<Object> get props => [
        email,
        area,
        street,
        block,
        house,
        firstName,
        lastName,
        mobile,
        countryId,
        accessToken,
        userId,
        address,
      ];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: }';
  }
}
