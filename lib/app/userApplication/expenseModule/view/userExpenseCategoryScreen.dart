import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/controller/expenseController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/expenseDynamicFieldResponseModel.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/validation.dart';

class Userexpensecategory extends StatefulWidget {
  Userexpensecategory({super.key});
  State<Userexpensecategory> createState() => _UserexpensescreenzsState();
}

class _UserexpensescreenzsState extends State<Userexpensecategory> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = Provider.of<Expensecontroller>(context, listen: false);
      provider.callCategoryFirstTime(forceRefresh: true);
      provider.clearFormField(); // first-time fresh fetch on screen enter
    });
  }

  // Text controllers keyed by field name (TEXT / NUMBER fields)
  final Map<String, TextEditingController> controllers = {};
  // Selected category tracking
  int? selectedCategoryId;
  String? selectedCategoryName;
  // Submitted form values: [{ "fieldId": ..., "value": ... }, ...]
  List<Map<String, dynamic>> myFormList = [];
//date make list of json............................20-7-26
  // Currently selected dropdown values, keyed by field name
  final Map<String, String?> selectedValues = {};
// Generic form data map (if you're using it elsewhere alongside myFormList)
  final Map<String, dynamic> formData = {};
  // Max amount allowed, set when a dropdown option is picked
  double maxAllowedAmount = 0;
  // final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<Expensecontroller>(context, listen: false);

    return PopScope(
        canPop: true, // Allows the system to pop the screen normally
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            // Runs immediately after the screen is popped off the navigation stack
            controller.resetControllerState();
          }
        },
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 184, 203, 219),
                      Color.fromARGB(255, 168, 243, 245)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: const Text(
                "EXPENSE CATEGORY",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            body: RefreshIndicator(onRefresh: () async {
              final pro =
                  Provider.of<Expensecontroller>(context, listen: false);

              //calling on refresh current date...................
              await pro.onRefeshDate(forceRefrsh: true);
            }, child: LayoutBuilder(builder: (context, Constraints) {
              return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: Constraints.maxHeight),
                    child: SafeArea(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //INCRESE AND DECRESE DATE COUNTER..............
                            Consumer<Expensecontroller>(
                              builder: (context, con, child) {
                                //return _builDate(con);
                                return _buildDateBar(con);
                              },
                            ),
                            //CATEGORY NAME
                            Consumer<Expensecontroller>(
                              builder: (context, con, child) {
                                return Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //USER ANITMATION TEXT STYLE...........
                                      animatedText("Selected Category Date:"),
                                      animatedText(con.formateDate
                                          .format(con.categoryCurrentDate)),
                                    ],
                                  ),
                                );
                              },
                            ),

                            //BUILD CATEGORY LIST
                            Consumer<Expensecontroller>(
                              builder: (context, controller, child) =>
                                  _buildCategoryItem(controller),
                            ),
                            Divider(),
                            //calling provider method.... dynamic text form field for fill update use expense.....

                            IntrinsicHeight(
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Consumer<Expensecontroller>(
                                        builder: (context, controller, child) =>
                                            buildDynamicExpenseForm(
                                                controller)),
                                  ),
                                  const SizedBox(width: 8),
                                  //show item card fill details
                                  // _buildSelectItemviewCard()
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ));
            }))));
  }

  Future<String?> showDialogBoxForImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.image, color: Colors.deepPurple),
              title: Text('Image from Gallery'),
              onTap: () {
                Navigator.of(context).pop('image'); // return "image" action
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.insert_drive_file, color: Colors.teal),
              title: Text('Pick File (PDF, DOC, etc.)'),
              onTap: () {
                Navigator.of(context).pop('file'); // return "file" action
              },
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final expenseController = context.read<Expensecontroller>();

    String expenseDate =
        expenseController.formateDate.format(expenseController.submitDate);
    final amountFiled = expenseController.dynamicField.firstWhere(
        (f) => f.fieldName.toLowerCase() == "amount",
        orElse: () => throw Exception("amount"));

    final amountEntry = myFormList.firstWhere(
      (e) => e["fieldId"] == amountFiled.id,
      orElse: () => {},
    );
    final doubleAmount =
        double.tryParse(amountEntry['value']?.toString() ?? "") ?? 0;
    final dynamicFieldPayload = myFormList
        .map((e) => {
              "fieldId": e["fieldId"],
              "value": e["value"].toString(),
            })
        .toList();
//------------------------Testing program====start

    if (!mounted) return;
    print(dynamicFieldPayload);

    final success = await expenseController.submitExpense(
      selectedCategoryId!,
      expenseDate,
      doubleAmount,
      dynamicFieldPayload,
      List<String>.from(expenseController.listofImage),
    );

    if (!mounted) return;
    if (success) {
      ShowTaostMessage.toastMessage(
        context,
        "Expense submitted successfully",
      );

      for (var ctrl in controllers.values) {
        ctrl.clear();
      }
      dateController.clear();
      myFormList.clear();
      selectedValues.clear();
      formData.clear();
      maxAllowedAmount = 0;
      expenseController.clearAllAttachments();
      expenseController.clearDynamicField();
      setState(() {
        selectedCategoryId = null;
        selectedCategoryName = null;
        _formKey.currentState?.reset();
      });
      //refresh category..............................

      final pro = Provider.of<Expensecontroller>(context, listen: false);
      //pro.clearFormField();
      pro.callCategoryFirstTime(forceRefresh: true);
    } else {
      ShowTaostMessage.toastMessage(
        context,
        expenseController.submitError ?? "Expense submission failed",
      );
    }
  }

  ///anitmated text color...........
  Widget animatedText(dynamic value) {
    return AnimatedTextKit(
      // Key forces the animation to replay whenever the date changes

      key: ValueKey(value),
      totalRepeatCount: 1, // Animated once per date change
      animatedTexts: [
        TypewriterAnimatedText(
          value,
          textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              // color: Colors., // Matches your original card color theme
              backgroundColor: const Color(0xFFFFFF00),
              color: const Color(0xFF000000)),
          speed: const Duration(milliseconds: 100),
        ),
      ],
    );
  }

  //DATE NEW CODE ..............................1=6-26
  //double maxAllowedAmount = 0;
  Widget buildDynamicExpenseForm(Expensecontroller controller) {
    if (controller.showAllField) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (controller.dynamicField.isEmpty) {
      return const SizedBox();
    }

    return Form(
      key: _formKey,
      child: SizedBox(
        width: SizeConFig.screenWidth * 0.5,
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //margin: EdgeInsets.all(16),
          child: Column(
            children: [
              ...controller.dynamicField.map((field) {
                switch (field.fieldType) {
                  case "DROPDOWN":
                    return buildDropdown(field);

                  case "TEXT":
                    return buildTextField(field);

                  case "NUMBER":
                    return buildNumberField(field);

                  case "IMAGE":
                    return buildImageField(field);

                  default:
                    return const SizedBox();
                }
              }).toList(),
              ElevatedButton(
                onPressed: controller.isSubmitting ? null : submitForm,
                child: controller.isSubmitting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget selectImageAndFill(String label) {
    return Consumer<Expensecontroller>(
      builder: (context, expenseController, child) {
        // No Image Selected
        if (!expenseController.isImage && !expenseController.isFile) {
          return Padding(
            padding: const EdgeInsets.all(12), // Reduced padding
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                FocusScope.of(context).unfocus();
                final result = await showDialogBoxForImage(context);
                if (result == "image") {
                  expenseController.selectMutlipleImageFromGallery();
                } else if (result == "file") {
                  expenseController.selectPdfDocFromDevice();
                }
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12), // Compact height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined,
                        size: 28, color: Colors.blue), // Smaller icon
                    const SizedBox(height: 4),
                    Text(label,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    const Text("Tap to upload", style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ),
          );
        }

        // Image Preview (Horizontal List to fix size & crash issues)
        if (expenseController.listofImage.isNotEmpty) {
          final images = expenseController.listofImage;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Uploaded (${images.length})",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 8),

                // Fixed container height protects your layout from blowing up
                SizedBox(
                  height: 70, // Limits the image height explicitly
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length + 1,
                    itemBuilder: (context, index) {
                      // Small Add More Tile
                      if (index == images.length) {
                        return InkWell(
                          onTap: () {
                            expenseController.selectMutlipleImageFromGallery();
                          },
                          child: Container(
                            width: 70, // Matches height for a perfect square
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child:
                                const Center(child: Icon(Icons.add, size: 24)),
                          ),
                        );
                      }

                      final img = images[index];

                      return Container(
                        width: 70, // Small explicit width
                        margin: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(img),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // Small close button
                            Positioned(
                              top: 2,
                              right: 2,
                              child: InkWell(
                                onTap: () {
                                  expenseController.clearImageList(index);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(Icons.close,
                                      size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  // Widget selectImageAndFill(String label) {
  //   return Consumer<Expensecontroller>(
  //     builder: (context, expenseController, child) {
  //       // No Image Selected
  //       if (!expenseController.isImage && !expenseController.isFile) {
  //         return Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: InkWell(
  //             borderRadius: BorderRadius.circular(12),
  //             onTap: () async {
  //               FocusScope.of(context).unfocus();

  //               final result = await showDialogBoxForImage(context);

  //               if (result == "image") {
  //                 expenseController.selectMutlipleImageFromGallery();
  //               } else if (result == "file") {
  //                 expenseController.selectPdfDocFromDevice();
  //               }
  //             },
  //             child: Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.symmetric(
  //                 vertical: 12,
  //                 //24
  //               ),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(12),
  //                 border: Border.all(
  //                   color: Colors.blue.shade300,
  //                 ),
  //               ),
  //               child: Column(
  //                 children: [
  //                   const Icon(
  //                     Icons.cloud_upload_outlined,
  //                     size: 28,
  //                     color: Colors.blue,
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     label,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 4),
  //                   const Text(
  //                     "Tap to upload images or PDF",
  //                     style: TextStyle(fontSize: 11),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       }

  //       // Image Preview
  //       if (expenseController.listofImage.isNotEmpty) {
  //         final images = expenseController.listofImage;

  //         return Padding(
  //           padding: const EdgeInsets.all(12),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Uploaded Image (${images.length})",
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               const SizedBox(height: 13),
  //               GridView.builder(
  //                 shrinkWrap: true,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //                   crossAxisCount: 3,
  //                   crossAxisSpacing: 10,
  //                   mainAxisSpacing: 10,
  //                 ),
  //                 itemCount: images.length + 1,
  //                 itemBuilder: (context, index) {
  //                   // Add More Tile
  //                   if (index == images.length) {
  //                     return InkWell(
  //                       onTap: () {
  //                         expenseController.selectMutlipleImageFromGallery();
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(12),
  //                           border: Border.all(
  //                             color: Colors.grey,
  //                           ),
  //                         ),
  //                         child: const Center(
  //                           child: Icon(
  //                             Icons.add,
  //                             size: 35,
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   }

  //                   final img = images[index];

  //                   return Stack(
  //                     children: [
  //                       Positioned.fill(
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(12),
  //                           child: Image.file(
  //                             File(img),
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                       ),
  //                       Positioned(
  //                         top: 5,
  //                         right: 5,
  //                         child: InkWell(
  //                           onTap: () {
  //                             expenseController.clearImageList(index);
  //                           },
  //                           child: Container(
  //                             decoration: const BoxDecoration(
  //                               color: Colors.red,
  //                               shape: BoxShape.circle,
  //                             ),
  //                             padding: const EdgeInsets.all(4),
  //                             child: const Icon(
  //                               Icons.close,
  //                               size: 16,
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       }

  //       return const SizedBox();
  //     },
  //   );
  // }

  Widget buildImageField(DynamicField field) {
    return FormField(
      validator: (value) {
        final expenseController =
            Provider.of<Expensecontroller>(context, listen: false);

        if (field.isRequired &&
            expenseController.listofImage.isEmpty &&
            expenseController.isFile == false) {
          return "${field.fieldLabel} is required";
        }

        return null;
      },
      builder: (FormFieldState state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selectImageAndFill(field.fieldLabel),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget buildTextField(DynamicField field) {
    controllers.putIfAbsent(
      field.fieldName,
      () => TextEditingController(),
    );
    return SizedBox(
      height: SizeConFig.screenHeight * 0.08,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          controller: controllers[field.fieldName],
          onChanged: (value) {
            // formData[field.fieldName] = value.trim();
            final exitingIndex = myFormList
                .indexWhere((element) => element['fieldId'] == field.id);
            if (exitingIndex != -1) {
              myFormList[exitingIndex]["value"] = value; // ✅ correct
            } else {
              myFormList.add({"fieldId": field.id, "value": value});
            }
          },
          decoration: InputDecoration(
            labelText: field.fieldLabel,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) {
            if (field.isRequired && (value == null || value.trim().isEmpty)) {
              return "${field.fieldLabel} is required";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildDropdown(DynamicField field) {
    return SizedBox(
      height: SizeConFig.screenHeight * 0.08,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<String>(
          menuMaxHeight: 250,
          itemHeight: 50,
          isDense: true,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          value: selectedValues[field.fieldName],
          decoration: InputDecoration(
              labelText: field.fieldLabel,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.2,
                  )),
              filled: true),
          items: field.optionss.map((option) {
            return DropdownMenuItem(
              value: option.label,
              child: Text(option.label),
              onTap: () {
                maxAllowedAmount = option.value;
              },
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              final exitingIndex = myFormList
                  .indexWhere((element) => element['fieldId'] == field.id);
              if (exitingIndex != -1) {
                myFormList[exitingIndex]["value"] = value; // ✅ correct
              } else {
                myFormList.add({"fieldId": field.id, "value": value});
              }
            });
          },
          validator: (value) {
            if (field.isRequired && (value == null || value.isEmpty)) {
              return "${field.fieldLabel} is required";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildNumberField(DynamicField field) {
    controllers.putIfAbsent(
      field.fieldName,
      () => TextEditingController(),
    );
    return SizedBox(
      height: SizeConFig.screenHeight * 0.08,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          controller: controllers[field.fieldName],
          keyboardType: TextInputType.number,
          onChanged: (value) {

            setState(() {
              maxAllowedAmount=double.parse(value);
            });
            final exitingIndex = myFormList
                .indexWhere((element) => element['fieldId'] == field.id);
            if (exitingIndex != -1) {
              myFormList[exitingIndex]["value"] = value; // ✅ correct
            } else {
              myFormList.add({"fieldId": field.id, "value": value});
            }
          },
          decoration: InputDecoration(
            labelText: field.fieldLabel,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          //here used VAlIDATION CLASS USING STATIC METHOD
          //   validator: Validation.validateNumber,
          //  validator: Validation.dynamicNumberValidation(min: 10, max: 100),
          validator: (value) {
            final dynamicLimit = field.fieldName.toLowerCase() == "amount"
                ? maxAllowedAmount
                : null;

            return Validation.validateDynamicNumber(
                value: value,
                fieldLabel: field.fieldLabel,
                isRequired: field.isRequired,
                maxLimit: dynamicLimit);
          },

          // validator: (value)
          // validator: (value) {
          //  if (Validation.validateNumber(value) != null)
          // if (field.isRequired && (value == null || value.trim().isEmpty)) {
          //   return "${field.fieldLabel} is required";
          // }
          // if(Validation.validateNumber(value)!=null)

          // final amount = int.tryParse(value ?? "");

          // if (amount == null) return "Enter valid amount";
          // if (amount>0) return "Maximum ₹$amount allowed";

          // if()

          // if (maxAllowedAmount != null && amount > maxAllowedAmount) {
          //   return "Maximum ₹$maxAllowedAmount allowed";
          // }

          // if (field.fieldName.toLowerCase() == "amount") {
          //   // if (amount > maxAllowedAmount) {
          //   //   return "Maximum ₹$maxAllowedAmount allowed";
          //   // }
          //   if (amount > maxAllowedAmount) {
          //     return "Maximum ₹$maxAllowedAmount allowed";
          //   }
          // }

          // return null;
          //},
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ',
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRouteColumn(String s, Map<String, dynamic> formData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(s, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(s,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSelectItemviewCard() {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // const Icon(Icons.flight_takeoff,
                      //     color: Colors.blue, size: 12),
                      Icon(getCategoryIcon("${selectedCategoryName}")),
                      const SizedBox(width: 8),
                      Text(
                        "${selectedCategoryName ?? "Travel"}",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    '${formData['Amount'] ?? '0'}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),
              _buildDetailRow('Type', ""),
              const SizedBox(height: 8),
              _buildRouteColumn('Select', formData),
              const Icon(Icons.arrow_forward, color: Colors.grey),
              //  _buildRouteColumn('Select', "To"),
            ],
          ),
        ),
      ),
    );
  }

  // Refactored rounded structural button configuration
  Widget _buildNavigationButton(
      {required VoidCallback onTap, required IconData icon}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: const Color(0xFF004D40).withOpacity(0.12),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color(
                0xFF00796B), // Deep complementary accent teal matching design flow
            size: 16,
          ),
        ),
      ),
    );
  }

//method  show slected date top of page({ method 1})
  Widget _buildDateBar(Expensecontroller controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        height: 64, // Explicit comfortable sizing constraint
        decoration: BoxDecoration(
          color: const Color(
              0xFF8BB1B1), // Polished slate teal matching your original palette
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: _buildNavigationButton(
                onTap: () {
                  //decrease date by one day
                  // controller.nextDayAndPreviousDay(-1);
                  controller.changeCategoryDate(-1);
                },
                icon: Icons.arrow_back_ios_new_rounded,
              ),
            ),

            // Current Date Title Header View
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SELECTED DATE",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                //SHOW CURRENT DATE USING PROVIDER
                Text(
                  controller.formateDate.format(controller.categoryCurrentDate),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            // Next Day Action Button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _buildNavigationButton(
                onTap: () => {
                  //increase date by one day
                  //controller.nextDayAndPreviousDay(1)
                  controller.changeCategoryDate(1)
                },
                icon: Icons.arrow_forward_ios_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Expensecontroller controller) {
    // Convert current selected date instance to your formatted string key
    ;
    String currentDateKey =
        controller.formateDate.format(controller.categoryCurrentDate);

    // Extract list array for this day
    final categories = controller.getCategoriesForDate(currentDateKey);

    // // Loading and error layouts
    // if (controller.isLoadExpenseCategory && categories.isEmpty) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    // Loading and error layouts
    if (controller.isLoadExpenseCategory) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      if (controller.errorMessage != null) {
        return Center(child: Text(controller.errorMessage!));
      }
      return const SizedBox();
    }

    return SizedBox(
      height: SizeConFig.screenHeight * 0.28,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final data = categories[index];

          bool isLocked = data.isLocked == true;
          bool isSelected = selectedCategoryId == data.id;

          return GestureDetector(
            onTap: () async {
              if (isLocked) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          data.lockMessage ?? "Category locked for today.")),
                );
                return;
              }

              if (selectedCategoryId == data.id) return;

              // Dispose old text controllers (field names differ per category,
              // so stale entries would otherwise pile up in the map)
              for (final ctrl in controllers.values) {
                ctrl.dispose();
              }
              controllers.clear();

              // Clear all previously entered form data
              myFormList.clear();
              selectedValues.clear();
              formData.clear();
              maxAllowedAmount = 0;

              // Clear selected images/files from the old category
              controller.clearAllAttachments();

              await controller.dynamicFormField(data.id);

              // Guard against the widget being disposed during the await
              if (!mounted) return;

              // Don't commit selection if the fetch failed — avoids showing
              // a category as "selected" with no form loaded underneath
              if (controller.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(controller.errorMessage!)),
                );
                return;
              }

              setState(() {
                selectedCategoryId = data.id;
                selectedCategoryName = data.categoryName;
                _formKey =
                    GlobalKey<FormState>(); // reset validation/error state
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isLocked
                    ? Colors.grey[300]
                    : (isSelected
                        // ignore: deprecated_member_use
                        ? Colors.blue.withOpacity(0.2)
                        : Colors.grey[100]),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLocked
                      ? Colors.red
                      : (isSelected ? Colors.blue : Colors.green),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    getCategoryIcon(data.categoryName),
                    color: isLocked ? Colors.grey : Colors.black87,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.categoryName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isLocked ? Colors.grey : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase().trim()) {
      case 'fuel':
        return Icons.local_gas_station;
      case 'hotel':
        return Icons.home;
      case 'transport':
        return Icons.local_shipping;
      case 'site_item':
        return Icons.construction;
      case 'breakfast':
        return Icons.coffee;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.restaurant;
      case 'travel':
        return Icons.directions_bus;
      case 'bike':
        return Icons.pedal_bike;
      case 'boat':
        return Icons.directions_boat;
      case 'labour':
        return Icons.engineering;
      case 'water':
        return Icons.water_drop;
      case 'stationary':
        return Icons.edit_note;
      case 'grocery':
        return Icons.local_grocery_store;

      default:
        return Icons.category;
    }
  }
}
