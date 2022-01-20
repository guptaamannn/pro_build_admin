import 'package:flutter/material.dart';
import 'package:pro_build_attendance/views/login/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginViewModel model = LoginViewModel(context);
    return Scaffold(
        body: Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign in",
            style:
                Theme.of(context).textTheme.headline1!.copyWith(fontSize: 60),
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a registered Email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter a password";
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) => logIn(model),
                ),
                SizedBox(height: 20),
                TextButton(onPressed: () => logIn(model), child: Text("Log in"))
              ],
            ),
          )
        ],
      ),
    ));
  }

  void logIn(LoginViewModel model) {
    if (_formKey.currentState!.validate()) {
      model.login(_emailController.text, _passwordController.text);
    }
  }
}
