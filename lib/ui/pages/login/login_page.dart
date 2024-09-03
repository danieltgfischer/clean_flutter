import 'package:ForDev/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';

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
              LoginHeader(),
              const Headline1(text: 'Login'),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<String?>(
                          stream: widget.presenter?.emailErrorStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                icon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                errorText: snapshot.data?.isEmpty == true
                                    ? null
                                    : snapshot.data,
                              ),
                              onChanged: widget.presenter?.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 32),
                        child: StreamBuilder<String?>(
                            stream: widget.presenter?.passwordErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  icon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                  errorText: snapshot.data?.isEmpty == true
                                      ? null
                                      : snapshot.data,
                                ),
                                obscureText: true,
                                onChanged: widget.presenter?.validatePassword,
                              );
                            }),
                      ),
                      StreamBuilder<bool?>(
                          stream: widget.presenter?.isFormValidStream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed: snapshot.data == true
                                  ? widget.presenter?.auth
                                  : null,
                              child: Text(
                                'Entrar'.toUpperCase(),
                              ),
                            );
                          }),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person),
                        label: const Text('Criar Conta'),
                      )
                    ],
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
