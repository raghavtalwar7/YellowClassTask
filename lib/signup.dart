import 'package:flutter/material.dart';
import 'package:movielist_app/authentication.dart';
import 'package:movielist_app/myhomepage.dart';
import 'package:provider/provider.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SizedBox(height: 80),
          Text(
            'Welcome!',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SignupForm(),
          ),
          SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Already here  ?',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(' Get Logged in Now!',
                        style: TextStyle(
                            fontSize: 20, color: const Color(0xFF819BFA))),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  SignupForm({Key key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String name;

  bool agree = false;

  final pass = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    var space = SizedBox(height: 10);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: 'Email',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
                borderSide:
                    BorderSide(color: const Color(0xFF5D79DE), width: 2.5),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
            keyboardType: TextInputType.emailAddress,
          ),

          space,

          // password
          TextFormField(
            controller: pass,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
                borderSide:
                    BorderSide(color: const Color(0xFF5D79DE), width: 2.5),
              ),
            ),
            onSaved: (val) {
              password = val;
            },
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),
          space,
          // confirm passwords
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: Icon(Icons.lock_outline),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
                borderSide:
                    BorderSide(color: const Color(0xFF5D79DE), width: 2.5),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value != pass.text) {
                return 'password does not match';
              }
              return null;
            },
          ),
          space,
          // name
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Full name',
              prefixIcon: Icon(Icons.account_circle),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  const Radius.circular(100.0),
                ),
                borderSide:
                    BorderSide(color: const Color(0xFF5D79DE), width: 2.5),
              ),
            ),
            onSaved: (val) {
              name = val;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some name';
              }
              return null;
            },
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Checkbox(
                onChanged: (_) {
                  setState(() {
                    agree = !agree;
                  });
                },
                value: agree,
              ),
              Flexible(
                child: Text(
                    'By creating account, I agree to Terms & Conditions and Privacy Policy.'),
              ),
            ],
          ),
          SizedBox(height: 30),
          // signUP button
          RaisedButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                final result = await context
                    .read<AuthenticationHelper>()
                    .signUp(email: email, password: password)
                    .then((result) {
                  if (result == null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        result,
                        style: TextStyle(fontSize: 16),
                      ),
                    ));
                  }
                });
              }
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            color: const Color(0xFF5D79DE),
            textColor: Colors.white,
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
