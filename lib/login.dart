import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movielist_app/authentication.dart';
import 'package:movielist_app/myhomepage.dart';
import 'package:movielist_app/signup.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          SizedBox(height: 80),
          // logo
          Column(
            children: [
              SizedBox(height: 50),
              Text(
                'Welcome back!',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),

          SizedBox(
            height: 50,
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LoginForm(),
          ),

          SizedBox(height: 20),

          Row(
            children: <Widget>[
              SizedBox(width: 30),
              Text('New here ? ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, '/signup');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: Text('Get Registered Now!!',
                    style: TextStyle(fontSize: 20, color: const Color(0xFF5D79DE))),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // email
          TextFormField(
            // initialValue: 'Input text',
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
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (val) {
              email = val;
            },
          ),
          SizedBox(
            height: 20,
          ),

          // password
          TextFormField(
            // initialValue: 'Input text',
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
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
            obscureText: _obscureText,
            onSaved: (val) {
              password = val;
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),

          SizedBox(height: 30),

          SizedBox(
            height: 52,
            width: 154,
            child: RaisedButton(
              onPressed: () {
                // Respond to button press

                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  context
                      .read<AuthenticationHelper>()
                      .signIn(email: email, password: password)
                      .then((result) {
                    if (result == null) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
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
                  borderRadius: BorderRadius.all(Radius.circular(24.0))),
              color: const Color(0xFF5D79DE),
              textColor: Colors.white,
              child: Text(
                'Login',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
