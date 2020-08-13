import 'package:covid_hospital_app/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'api.dart';
import 'get_location.dart';

class RegisterPage extends StatefulWidget {

//  final Function(int) loginState ;
//  RegisterPage({this.loginState});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _formKey = GlobalKey<FormState>();
  String _email, _name, _phone, _password ;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        opacity: 0.5,
        color: Colors.black,
        progressIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(16),
            child: Theme(
              data: ThemeData(primaryColor: Colors.red),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(height: 16,),
                    Container(
                      child: Text('Register', style: TextStyle(fontSize: 40),),
                    ),
                    Container(height: 20,),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            'Lets get you on board',
                            style: TextStyle(
                                fontSize: 30, color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Text(''),
                        ),
                      ],
                    ),
                    Text('' , style: TextStyle(fontSize: 30),),
                    Text('' , style: TextStyle(fontSize: 15),),
                    TextFormField(
                      style: TextStyle(fontSize: 20),
                      cursorColor: Colors.amber[800],
                      decoration: InputDecoration(
                        labelText: 'Name',
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
                        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                      ),
                      onChanged: (value) => _name = value,
                      validator: MultiValidator(
                        [
                          RequiredValidator(errorText: 'This Field is required'),
                          MinLengthValidator(6, errorText: 'Name must be at least 6 characters long'),
                        ],
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: TextStyle(fontSize: 20),
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.amber[800],
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
                        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                      ),
                      onChanged: (value) => _phone = value,
                      validator: MinLengthValidator(10, errorText: 'Phone number must be 10 digits long'),
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 20),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.amber[800],
                      decoration: InputDecoration(
                        labelText: 'Email',
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
                        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                      ),
                      onChanged: (value) => _email = value.replaceAll(' ', ''),
                      validator: (value) {
                        final isValid = EmailValidator(errorText: 'Enter a valid email address').isValid(value.replaceAll(' ', '')) ;
                        if (!isValid)
                          return 'Enter a valid email address';
                        return null;
                      },
                    ),
                    //Text('' , style: TextStyle(fontSize: 15),),
                    TextFormField(
                      obscureText: true,
                      style: TextStyle(fontSize: 20, letterSpacing: 2),
                      cursorColor: Colors.amber[800],
                      decoration: InputDecoration(
                        labelText: 'Password',
                        contentPadding: EdgeInsets.symmetric(vertical: 1),
                        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onChanged: (value) => _password = value,
                      validator: MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
                    ),
                    Text('' , style: TextStyle(fontSize: 2),),
                    Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: (){},
                        padding: EdgeInsets.zero,
                        child: Text(
                          'Forgot Password ?',
                          style: TextStyle(fontSize: 18, color: Colors.red, letterSpacing: 2),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    Text('' , style: TextStyle(fontSize: 5),),
                    FlatButton(
                      color: Colors.red,
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Container(
                        height: 50,
                        clipBehavior: Clip.hardEdge,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 20,letterSpacing: 2),),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      onPressed: () async{
                        setState(() {
                          isLoading = true;
                        });
                        await submit(context);
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                    Text('' , style: TextStyle(fontSize: 15),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: TextStyle(color: Colors.grey[600], fontSize: 20),),
                        FlatButton(
                          onPressed:() => Navigator.pop(context),
                          child: Text('Sign In', style: TextStyle(color: Colors.red, fontSize: 20, decorationStyle: TextDecorationStyle.solid, decoration: TextDecoration.underline),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  submit(context) async {
    if (_formKey.currentState.validate()) {
      final userMap =
          await Login.signUp(_name, _email, _phone, _password, context);
      if (userMap != null) {
        Login.user = User.fromJson(userMap);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => GetLocationHome()),
            (route) => false);
      }
    }
  }
}
