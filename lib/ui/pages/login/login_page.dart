import 'package:ForDev/ui/pages/pages.dart';
import 'package:flutter/material.dart';

import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  late LoginPresenter? presenter;

  LoginPage(this.presenter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email,
                            color: Theme.of(context).primaryColorLight),
                      ),
                      onChanged: presenter?.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 32),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          icon: Icon(Icons.lock,
                              color: Theme.of(context).primaryColorLight),
                        ),
                        obscureText: true,
                        onChanged: presenter?.validatePassword,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: null,
                      child: Text(
                        'Entrar'.toUpperCase(),
                      ),
                    ),
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
      ),
    );
  }
}
