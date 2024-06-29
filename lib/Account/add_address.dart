// @dart=2.9
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddAddress extends StatefulWidget {
  AddAddress({Key key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  TextEditingController areaController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SIGN_GRAYCOLOR,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          'NEW ADDRESS',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 50)),
              _buildTextField(
                'Enter Area',
                'Enter Area',
                'Area',
                FontAwesomeIcons.portrait,
                areaController,
              ),
              _buildTextField(
                'Enter Street',
                'Enter Street',
                'Street',
                FontAwesomeIcons.chartArea,
                streetController,
              ),
              _buildTextField(
                'Enter Block',
                'Enter Block',
                'Block',
                FontAwesomeIcons.chartArea,
                blockController,
              ),
              _buildTextField(
                'Enter Floor No / House No / Flat No',
                'Enter Floor No / House No / Flat No',
                'Floor No / House No / Flat No',
                FontAwesomeIcons.home,
                houseController,
              ),
              _buildTextField(
                'Select Country',
                'Select Country',
                'Country',
                FontAwesomeIcons.chartArea,
                countryController,
              ),
              //   _buildCountryPickerDropdown(),
              _addAddressButton(),
            ],
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

  Widget _addAddressButton() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: InkWell(
        //  customBorder: CircleBorder(),
        onTap: () {},
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
            'ADD',
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
}
