// @dart=2.9
import 'dart:io';

import 'package:aqua/Account/Countries/bloc/country_bloc.dart';
import 'package:aqua/Account/authentication_bloc/authentication_bloc.dart';
import 'package:aqua/Api_Manager/api_response_manager.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'bloc/signup_bloc.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  double globalMediaBottom = 0.0;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  Country selectedCountry;

  SignupBloc _signupBloc;
  CountryBloc _countryBloc;
  String localValidationError = "";
  bool isSignupButtonEnabled(SignupState state) {
    localValidationError = "";
    if (!isPopulated) {
      localValidationError =
          AppLocalizations.of(context).translate('pleaseEnterAllFields');
    } else if (!state.isPasswordValid) {
      localValidationError =
          AppLocalizations.of(context).translate('passwordValidation');
    } else if (!isPwdAndConfirmPwd) {
      localValidationError = AppLocalizations.of(context)
          .translate('passwordAndConfirmPasswordMismatch');
    } else if (!state.isEmailValid) {
      localValidationError =
          AppLocalizations.of(context).translate('pleaseEnterEmailId');
    } else if (!state.isPhoneValid) {
      localValidationError =
          AppLocalizations.of(context).translate('pleaseEnterPhoneNumber');
    }
    return isPopulated &&
        state.isFormValid &&
        !state.isSubmitting &&
        isPwdAndConfirmPwd;
  }

  bool get isPopulated =>
      mailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      firstNameController.text.isNotEmpty &&
      lastNameController.text.isNotEmpty &&
      mobileController.text.isNotEmpty &&
      confirmPwdController.text.isNotEmpty &&
      (selectedCountry != null);

  bool get isPwdAndConfirmPwd =>
      passwordController.text == confirmPwdController.text;

  @override
  void initState() {
    super.initState();
    _signupBloc = BlocProvider.of<SignupBloc>(context);
    mailController.addListener(_onEmailChanged);
    passwordController.addListener(_onPasswordChanged);
    _countryBloc = CountryBloc()..add(CountryFetch());
  }

  void _onEmailChanged() {
    _signupBloc.add(
      SignUpEmailChanged(email: mailController.text),
    );
  }

  void _onPasswordChanged() {
    print(passwordController.text);
    _signupBloc.add(
      SignUpPasswordChanged(password: passwordController.text),
    );
  }

  void _onSignUpButtonClicked() {
    _signupBloc.add(SignupWithCredentialsPressed(
      firstname: firstNameController.text.trim(),
      lastname: lastNameController.text.trim(),
      mobile: mobileController.text,
      countryId: selectedCountry.countryId,
      email: mailController.text.replaceAll(" ", ''),
      password: passwordController.text,
    ));
  }

  void _checkAccountCreation(SignupState state) {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Text((localValidationError != "" && localValidationError != null)
          ? localValidationError
          : '${state.infoMessage}'),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('ok'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    globalMediaBottom = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) async {
        if (state.isFailure) {
          print('Inside:${state.infoMessage}');
          Navigator.pop(context);
          Alert(
            context: context,
            title: AppLocalizations.of(context).translate('alert'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${state.infoMessage}'),
              ],
            ),
            buttons: [
              DialogButton(
                child: Text(
                  AppLocalizations.of(context).translate('ok'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
        if (state.isSubmitting) {
          print('INside submitting: ${state.infoMessage}');
          Alert(
            context: context,
            title: AppLocalizations.of(context).translate('alert'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${state.infoMessage}'),
                CircularProgressIndicator(),
              ],
            ),
            buttons: [
              DialogButton(
                child: Text(
                  AppLocalizations.of(context).translate('ok'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }

        if (state.isSuccess) {
          print('I am in success');
          Navigator.pop(context);
          Alert(
            context: context,
            title: AppLocalizations.of(context).translate('alert'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${state.infoMessage}',
                ),
              ],
            ),
            buttons: [
              DialogButton(
                child: Text(
                  AppLocalizations.of(context).translate('ok'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
                },
                width: 120,
              )
            ],
          ).show();
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlocBuilder<SignupBloc, SignupState>(
          bloc: _signupBloc,
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.SIGN_GRAYCOLOR,
              body: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //     _photoStack(),
                      Padding(padding: const EdgeInsets.only(top: 50)),
                      _buildTextField(
                        AppLocalizations.of(context)
                            .translate('enterFirstName'),
                        AppLocalizations.of(context)
                            .translate('enterFirstName'),
                        AppLocalizations.of(context).translate('firstName'),
                        FontAwesomeIcons.portrait,
                        firstNameController,
                      ),
                      _buildTextField(
                        AppLocalizations.of(context).translate('enterLastName'),
                        AppLocalizations.of(context).translate('enterLastName'),
                        AppLocalizations.of(context).translate('lastName'),
                        FontAwesomeIcons.portrait,
                        lastNameController,
                      ),
                      _buildTextField(
                        AppLocalizations.of(context).translate('enterEmailId'),
                        AppLocalizations.of(context).translate('enterEmailId'),
                        AppLocalizations.of(context).translate('emailId'),
                        Icons.email,
                        mailController,
                      ),
                      _buildPasswordTextField(
                        AppLocalizations.of(context).translate('password'),
                        AppLocalizations.of(context).translate('password'),
                        AppLocalizations.of(context).translate('password'),
                        FontAwesomeIcons.eyeSlash,
                        passwordController,
                      ),
                      _buildConfirmPasswordTextField(
                        AppLocalizations.of(context)
                            .translate('confirmPassword'),
                        AppLocalizations.of(context)
                            .translate('confirmPassword'),
                        AppLocalizations.of(context)
                            .translate('confirmPassword'),
                        FontAwesomeIcons.eyeSlash,
                        confirmPwdController,
                      ),
                      _countryDropdown(),
                      _buildTextField(
                        AppLocalizations.of(context).translate('enterMobile'),
                        AppLocalizations.of(context)
                            .translate('enterMobileWithoutCountryCode'),
                        AppLocalizations.of(context).translate('mobile'),
                        FontAwesomeIcons.phoneAlt,
                        mobileController,
                      ),
                      //   _buildCountryPickerDropdown(),
                      _signUpButton(state),
                      Padding(padding: const EdgeInsets.all(30)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _photoStack() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: () {},
        child: Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          // padding: const EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.transparent,
            border: Border.all(
              color: AppColors.WHITE_COLOR,
              width: 2,
            ),
          ),
          child: Text(
            'Add Photo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: AppColors.WHITE_COLOR,
            ),
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String validatorText, String hintText,
      String labelText, IconData icon, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
      alignment: Alignment.center,
      height: 60,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value == '') {
            return validatorText;
          }
          return null;
        },
        onChanged: (value) {
          _formKey.currentState.validate();
        },
        style: Theme.of(context).textTheme.headline4,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: AppColors.WHITE_COLOR,
            size: 15,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
        ),
      ),
    );
  }

  bool _obscureTextPassword = true;
  void _togglePassword() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  Widget _buildPasswordTextField(String validatorText, String hintText,
      String labelText, IconData icon, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
      alignment: Alignment.center,
      height: 60,
      child: TextFormField(
        obscureText: _obscureTextPassword,
        controller: controller,
        validator: (value) {
          if (value == null || value == '') {
            return validatorText;
          }
          return null;
        },
        onChanged: (value) {
          _formKey.currentState.validate();
        },
        style: Theme.of(context).textTheme.headline4,
        decoration: InputDecoration(
          prefixIcon: GestureDetector(
            onTap: _togglePassword,
            child: Icon(
              _obscureTextPassword
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              size: 15.0,
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
        ),
      ),
    );
  }

  bool _obscureTextConfirmPassword = true;
  void _toggleConfirmPassword() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }

  Widget _buildConfirmPasswordTextField(String validatorText, String hintText,
      String labelText, IconData icon, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
      alignment: Alignment.center,
      height: 60,
      child: TextFormField(
        obscureText: _obscureTextConfirmPassword,
        controller: controller,
        validator: (value) {
          if (value == null || value == '') {
            return validatorText;
          }
          return null;
        },
        onChanged: (value) {
          _formKey.currentState.validate();
        },
        style: Theme.of(context).textTheme.headline4,
        decoration: InputDecoration(
          prefixIcon: GestureDetector(
            onTap: _toggleConfirmPassword,
            child: Icon(
              _obscureTextConfirmPassword
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              size: 15.0,
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.WHITE_COLOR,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
        ),
      ),
    );
  }

  Widget _signUpButton(SignupState state) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: InkWell(
        //  customBorder: CircleBorder(),
        onTap: () {
          isSignupButtonEnabled(state)
              ? _onSignUpButtonClicked()
              : _checkAccountCreation(state);
        },
        child: Container(
          width: 200,
          height: 45,
          alignment: Alignment.center,
          // padding: const EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: AppColors.WHITE_COLOR,
            border: Border.all(
              color: AppColors.WHITE_COLOR,
              width: 2,
            ),
          ),
          child: Text(
            AppLocalizations.of(context).translate('signUp'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: AppColors.BLACK_COLOR,
            ),
            maxLines: 2,
          ),
        ),
      ),
    );
  }

  Widget _countryDropdown() {
    return BlocBuilder<CountryBloc, CountryState>(
      bloc: _countryBloc,
      builder: (context, state) {
        if (state is CountryInitial) {
          return _dropDownTextField(List<Country>());
        } else if (state is CountryError) {
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
                    _countryBloc..add(CountryFetch());
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
        } else if (state is CountryLoaded) {
          return _dropDownTextField(state.listCountries.results);
        }
        return Container();
      },
    );
  }

  Widget _dropDownTextField(List<Country> countryList) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 10, right: 10),
      alignment: Alignment.centerLeft,
      height: 60,
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          scrollPadding: Platform.isAndroid
              ? EdgeInsets.only(bottom: globalMediaBottom + 100)
              : EdgeInsets.only(bottom: globalMediaBottom + 100),
          controller: countryController,
          style: Theme.of(context).textTheme.headline4,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('country'),
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.WHITE_BACKGROUND,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.WHITE_COLOR,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.WHITE_COLOR,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.WHITE_COLOR,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        suggestionsCallback: (pattern) async {
          CountryService regionsService = CountryService(countryList);
          return regionsService.getSuggestions(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(
              suggestion.countryName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: AppColors.BLACK_COLOR,
              ),
            ),
          );
        },
        onSuggestionSelected: (Country suggestion) {
          countryController.text = suggestion.countryName;
          selectedCountry = suggestion;
        },
      ),
    );
  }
}

class CountryService {
  final List<Country> countries;
  CountryService(this.countries);

  List<Country> getSuggestions(String query) {
    List<Country> matches = List<Country>();
    matches.addAll(countries);

    matches.retainWhere(
        (s) => s.countryName.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
