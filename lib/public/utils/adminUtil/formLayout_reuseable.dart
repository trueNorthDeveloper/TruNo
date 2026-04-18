import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/controller/admin_dashBoard_provider.dart';


class FormlayoutReuseable extends StatelessWidget {
  FormlayoutReuseable({super.key});

 // final _formKey = GlobalKey<FormState>();
  //final _nameController = TextEditingController();
 // final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
       Center(
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
        //       child: CustomFormLayout(
        //         formKey: _formKey,
        //         onSubmit: () {
        //           print(
        //               'Name: ${_nameController.text}, Email: ${_emailController.text}');
        //         },
        //         children: [
        //           CustomTextFormField(
        //             labelText: 'Name',
        //             controller: _nameController,
        //             validator: (value) =>
        //                 value!.isEmpty ? 'Please enter your name' : null,
        //           ),
        //           SizedBox(height: 16.0),
        //           CustomTextFormField(
        //             labelText: 'Email',
        //             controller: _emailController,
        //             keyboardType: TextInputType.emailAddress,
        //             validator: (value) => value!.isEmpty || !value.contains('@')
        //                 ? 'Enter a valid email'
        //                 : null,
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        child:Consumer<AdminDashboardProvider>(builder: (context, provider, child) {
          return  Center(child: ElevatedButton(onPressed: () {
            provider.allUsers(context);
          
        }, child:Text("Api ")),);
        },)
        
        
        
            )
          )
         ],
      )),
    );
  }
}
