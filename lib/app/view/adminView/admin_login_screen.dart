import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import 'package:truenorthflutterfrontend/app/controller/adminController/admin_dashBoard_provider.dart';

import 'package:truenorthflutterfrontend/public/utils/adminUtil/custom_form_layout.dart';
import 'package:truenorthflutterfrontend/public/utils/adminUtil/custom_textForm_Field.dart';

class AdminLoginScreenUi extends StatefulWidget {
  const AdminLoginScreenUi({super.key});

  @override
  State<AdminLoginScreenUi> createState() => _AdminLoginUiScreenState();
}

class _AdminLoginUiScreenState extends State<AdminLoginScreenUi> {
  final _formKey = GlobalKey<FormState>();
  final _loginIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF3F4F6), // light background
        body: Center(child: SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constraints) {
          double width = constraints.maxWidth;
          double formWidth = width > 1000
              ? 400
              : width > 600
                  ? 350
                  : width * 0.9;

          return Container(
              width: formWidth,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Optional: Add your logo here
                // Image.asset('assets/logo.png', height: 60),
                const Text(
                  'Welcome To TrueNorth',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),

                Consumer<AdminDashboardProvider>(
                    builder: (context, adminContro, child) {
                  return adminContro.isLogin == true
                      ? Center(
                          child: LoadingAnimationWidget.inkDrop(
                            color: Color(0xfffb934d),
                            size: 50,
                          ),
                        )
                      : CustomFormLayout(
                          formKey: _formKey,
                          onSubmit: () {
                            if (_formKey.currentState!.validate()) {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => AdminDashboardPage()),
                              // );
                              adminContro.adminLoginWithIdAndPassword(
                                  _loginIdController.text.trim(),
                                  _passwordController.text.trim(),
                                  context);
                            }
                          },
                          children: [
                              CustomTextFormField(
                                labelText: 'Login ID',
                                controller: _loginIdController,
                                validator: (value) => value!.isEmpty
                                    ? 'Please enter your Login ID'
                                    : null,
                              ),
                              const SizedBox(height: 16.0),
                              CustomTextFormField(
                                labelText: 'Password',
                                controller: _passwordController,
                                // obscureText: true,
                                validator: (value) => value!.isEmpty
                                    ? 'Please enter your password'
                                    : null,
                              ),
                            ]);
                })
              ]));
        }))));
  }
}
