import 'package:covid_hospital_app/get_location.dart';
import 'package:covid_hospital_app/register.dart';
import 'package:covid_hospital_app/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'api.dart';

//enum Logger { volunteer, miner, controlStation }
//enum FormType { login, register }
//Logger logger = Logger.volunteer;

class LoginPage extends StatefulWidget {

//  final Function(int) loginState ;
//  LoginPage({this.loginState});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  bool isLoading ;

  String _email, _password ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

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
                    Container(
                      child: Text('Login', style: TextStyle(fontSize: 40),),
                    ),
                    Text('' , style: TextStyle(fontSize: 30),),
                    Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: Text(
                            'Welcome Back, please login to your account',
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
                    Text('' , style: TextStyle(fontSize: 15),),
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
                        child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 20,letterSpacing: 2),),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async{
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          await submit(context);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account? ', style: TextStyle(color: Colors.grey[600], fontSize: 20),),
                        FlatButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage())),
                          child: Text('Sign Up', style: TextStyle(color: Colors.red, fontSize: 20, decorationStyle: TextDecorationStyle.solid, decoration: TextDecoration.underline),),
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

  submit(BuildContext context) async {
    final userMap = await Login.signIn(_email, _password, context);
    if (userMap != null) {
      Login.user = User.fromJson(userMap);
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => GetLocationHome()), (
          route) => false);
    }
  }
}