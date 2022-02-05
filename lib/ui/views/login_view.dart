import 'package:flutter/material.dart';
import 'package:pro_build_attendance/core/enums/view_state.dart';
import 'package:pro_build_attendance/core/viewModel/login_model.dart';
import 'package:pro_build_attendance/locator.dart';
import 'package:pro_build_attendance/ui/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  static const String id = '/login';
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
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => locator<LoginModel>(),
      child: Consumer<LoginModel>(
        builder: (context, model, child) => Scaffold(
          body: ModalProgressIndicator(
            isLoading: model.state == ViewState.busy,
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign in",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 60),
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
                          onFieldSubmitted: (value) async {
                            if (_formKey.currentState!.validate()) {
                              await context.read<LoginModel>().login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                var result = await model.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              }
                            },
                            child: Text("Log in"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
