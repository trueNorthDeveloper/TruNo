import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/public/utils/adminUtil/custom_form_layout.dart';
import 'package:truenorthflutterfrontend/public/utils/adminUtil/custom_textForm_Field.dart';

class AdminCreateprojectScreen extends StatefulWidget {
  const AdminCreateprojectScreen({super.key});

  @override
  State<AdminCreateprojectScreen> createState() => _AdminCreateprojectScreenState();
}

class _AdminCreateprojectScreenState extends State<AdminCreateprojectScreen> {
final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Project")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 2 / 100,
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(20)),
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: CustomFormLayout(
                formKey: _formKey,
                onSubmit: () {
                  print(
                      'Name: ${_projectNameController.text}, Email: ${_emailController.text}');
                },
                children: [
                  CustomTextFormField(
                    labelText: 'Name',
                    controller: _projectNameController,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your project name' : null,
                  ),
                  SizedBox(height: 16.0),
                  CustomTextFormField(
                    labelText: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty || !value.contains('@')
                        ? 'Enter a valid email'
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
      ),
    );
  }
}
