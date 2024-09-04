import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './components/components.dart';
import '../../components/components.dart';
import '../../pages/pages.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  const LoginPage(this.presenter, {super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        widget.presenter?.isLoadingStream.listen((isLoading) {
          if (context.mounted) handleProgressIndicator(context, isLoading);
        });

        widget.presenter?.mainErrorStream.listen((error) {
          if (context.mounted) {
            showErrorMessage(context, error);
          }
        });

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const LoginHeader(),
              const Headline1(text: 'Login'),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Provider(
                  create: (_) => widget.presenter,
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        const EmailInput(),
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 32),
                          child: PasswordInput(),
                        ),
                        const LoginButton(),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.person),
                          label: const Text('Criar Conta'),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
