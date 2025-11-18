    import 'package:flutter/material.dart';

class CustomFormLayout extends StatelessWidget {
      final List<Widget> children;
      final GlobalKey<FormState> formKey;
      final VoidCallback onSubmit;

      const CustomFormLayout({
        Key? key,
        required this.children,
        required this.formKey,
        required this.onSubmit,
      }) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...children,
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    onSubmit();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      }
    }