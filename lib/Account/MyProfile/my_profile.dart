// @dart=2.9
import 'dart:io';

import 'package:aqua/Account/Countries/bloc/country_bloc.dart';
import 'package:aqua/Account/MyProfile/bloc/my_profile_bloc.dart';
import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/Api_Manager/api_response_manager.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:aqua/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyProfile extends StatefulWidget {
  final Map<String, dynamic> userData;
  MyProfile({Key key, this.userData}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController mailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  Country selectedCountry;
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  double globalMediaBottom = 0.0;
  CountryBloc _countryBloc;
  MyProfileBloc _myProfileBloc;
  UserRepository userRepository = UserRepository();
  String accessToken;
  int userId;

  bool isCountryLoaded = false;

  @override
  void initState() {
    super.initState();
    _countryBloc = CountryBloc()..add(CountryFetch());
    mailController.addListener(_onEmailChanged);
    _myProfileBloc = BlocProvider.of<MyProfileBloc>(context);

    print('Iam in retrive');
    firstNameController.text = widget.userData['data']['user_first_name'];
    lastNameController.text = widget.userData['data']['user_last_name'];
    mailController.text = widget.userData['data']['user_email'];
    mobileController.text = widget.userData['data']['user_mobile'];
    countryController.text = widget.userData['data']['user_country_name'];
    areaController.text = widget.userData['data']['user_area'];
    houseController.text = widget.userData['data']['user_house'];
    blockController.text = widget.userData['data']['user_block'];
    streetController.text = widget.userData['data']['user_street'];
    accessToken = widget.userData['data']['user_api_access_token'];
    userId = widget.userData['data']['user_id'];
    print(accessToken);
  }

  void _onEmailChanged() {
    _myProfileBloc.add(
      ProfileEmailChanged(email: mailController.text),
    );
  }

  bool isProfileButtonEnabled(MyProfileState state) {
    return isPopulated;
  }

  bool get isPopulated =>
      firstNameController.text.isNotEmpty &&
      lastNameController.text.isNotEmpty &&
      mailController.text.isNotEmpty &&
      mobileController.text.isNotEmpty &&
      areaController.text.isNotEmpty &&
      streetController.text.isNotEmpty &&
      blockController.text.isNotEmpty &&
      houseController.text.isNotEmpty &&
      countryController.text.isNotEmpty &&
      Validators.isValidEmail(mailController.text) &&
      //   Validators.isvalidMobile(mobileController.text) &&
      (selectedCountry != null);

  void _onProfileUpdateClicked() {
    _myProfileBloc.add(ProfileWithUpdatePressed(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      mobile: mobileController.text,
      countryId: selectedCountry.countryId,
      email: mailController.text.trim(),
      area: areaController.text,
      block: blockController.text,
      house: houseController.text,
      street: streetController.text,
      accessToken: accessToken,
      userId: userId,
      address: " ",
    ));
  }

  void _checkAccountUpdate(MyProfileState state) {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).translate('pleaseEnterAllFields'),
          ),
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

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    globalMediaBottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: AppColors.SIGN_GRAYCOLOR,
      appBar: new AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          AppLocalizations.of(context).translate('myProfile'),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: BlocListener<MyProfileBloc, MyProfileState>(
        listener: (context, state) {
          if (state is MyProfileError) {
            print('Inside:${state.errorMessage}');
            Navigator.pop(context);
            Alert(
              context: context,
              title: AppLocalizations.of(context).translate('alert'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${state.errorMessage}'),
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

          if (state is MyProfileLoading) {
            //  print('INside submitting: ${state.infoMessage}');

            Alert(
              context: context,
              title: AppLocalizations.of(context).translate('alert'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: AquaProgressIndicator(),
                  ),
                  Text(
                      '${AppLocalizations.of(context).translate('updating')}...'),
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
          if (state is MyProfileLoaded) {
            print('I am in success');
            Navigator.pop(context);
            Alert(
              context: context,
              title: AppLocalizations.of(context).translate('alert'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${state.userData['info']}'),
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
                    // BlocProvider.of<AuthenticationBloc>(context)
                    //     .add(LoggedIn());
                    Navigator.pop(context);
                  },
                  width: 120,
                )
              ],
            ).show();
          }
        },
        child: BlocBuilder<MyProfileBloc, MyProfileState>(
          bloc: _myProfileBloc,
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //  _photoStack(),
                    Padding(padding: const EdgeInsets.only(top: 10)),
                    _buildTextField(
                      AppLocalizations.of(context).translate('enterFirstName'),
                      AppLocalizations.of(context).translate('enterFirstName'),
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
                      AppLocalizations.of(context).translate('enterEmail'),
                      AppLocalizations.of(context).translate('enterEmail'),
                      AppLocalizations.of(context).translate('email'),
                      Icons.mail,
                      mailController,
                    ),
                    _buildTextField(
                      AppLocalizations.of(context).translate('enterMobile'),
                      AppLocalizations.of(context)
                          .translate('enterMobileWithoutCountryCode'),
                      AppLocalizations.of(context).translate('mobile'),
                      FontAwesomeIcons.phoneAlt,
                      mobileController,
                    ),
                    _countryDropdown(),

                    _buildTextField(
                      AppLocalizations.of(context).translate('enterArea'),
                      AppLocalizations.of(context).translate('enterArea'),
                      AppLocalizations.of(context).translate('area'),
                      FontAwesomeIcons.city,
                      areaController,
                    ),
                    _buildTextField(
                      AppLocalizations.of(context).translate('enterStreet'),
                      AppLocalizations.of(context).translate('enterStreet'),
                      AppLocalizations.of(context).translate('street'),
                      FontAwesomeIcons.streetView,
                      streetController,
                    ),
                    _buildTextField(
                      AppLocalizations.of(context).translate('enterBlock'),
                      AppLocalizations.of(context).translate('enterBlock'),
                      AppLocalizations.of(context).translate('block'),
                      Icons.streetview,
                      blockController,
                    ),
                    _buildTextField(
                      AppLocalizations.of(context).translate('enterHouse'),
                      AppLocalizations.of(context).translate('enterHouse'),
                      AppLocalizations.of(context).translate('house'),
                      FontAwesomeIcons.houzz,
                      houseController,
                    ),

                    //   Padding(padding: const EdgeInsets.all(10)),
                    _profileUpdateButton(state),
                    Padding(padding: const EdgeInsets.all(20)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _profileUpdateButton(MyProfileState state) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: InkWell(
        onTap: () => isProfileButtonEnabled(state)
            ? _onProfileUpdateClicked()
            : _checkAccountUpdate(state),
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
            AppLocalizations.of(context).translate('update'),
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
          if (!isCountryLoaded) {
            selectedCountry = userRepository.searchCountryFromList(
                state.listCountries.results,
                widget.userData['data']['user_country_id'])[1];
            isCountryLoaded = true;
          }
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
              : EdgeInsets.only(bottom: globalMediaBottom),
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
          setState(() {
            countryController.text = suggestion.countryName;
            selectedCountry = suggestion;
          });
        },
      ),
    );
  }

  Widget _photoStack() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
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
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.WHITE_BACKGROUND,
          ),
        ),
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
