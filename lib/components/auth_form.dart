import 'dart:io';
import 'dart:math';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;
  const AuthForm({super.key, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePicker(File image) {
    _formData.image = image;
  }

  void _showErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (_formData.image == null && _formData.isSignup) {
      return _showErro('Imagem não selecionada!');
    }

    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_formData.isSignup)
                  UserImagePicker(
                    onImagePick: _handleImagePicker,
                  ),
                if (_formData.isSignup)
                  TextFormField(
                    key: ValueKey('name'),
                    initialValue: _formData.name,
                    onChanged: (name) => _formData.name = name,
                    decoration: InputDecoration(labelText: 'Nome'),
                    validator: (_name) {
                      final name = _name ?? '';
                      if (name.trim().length < 5) {
                        return 'Nome deve ter no minimo 5 caracteres';
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  key: ValueKey('email'),
                  initialValue: _formData.email,
                  onChanged: (email) => _formData.email = email,
                  decoration: InputDecoration(labelText: 'E-mail'),
                  validator: (_email) {
                    final email = _email ?? '';

                    if (!email.contains('@')) {
                      return 'E-mail invalido por favor insira um email válido';
                    }
                  },
                ),
                TextFormField(
                  key: ValueKey('password'),
                  initialValue: _formData.password,
                  onChanged: (password) => _formData.password = password,
                  decoration: InputDecoration(labelText: 'senha'),
                  obscureText: true,
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password.length < 6) {
                      return 'Senha deve ter no mínimo 6 caracteres';
                    }
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_formData.isLogin ? 'Entrar' : 'Cadastrar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _formData.toogleAuthMode();
                    });
                  },
                  child: Text(_formData.isLogin
                      ? 'Criar uma nova conta?'
                      : 'Já possui conta ?'),
                )
              ],
            )),
      ),
    );
  }
}
