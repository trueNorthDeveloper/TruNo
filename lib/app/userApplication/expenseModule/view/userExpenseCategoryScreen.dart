import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/controller/expenseController.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/model/expenseDynamicFieldResponseModel.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class Userexpensecategory extends StatefulWidget {
  Userexpensecategory({super.key});
  State<Userexpensecategory> createState() => _UserexpensescreenzsState();
}

class _UserexpensescreenzsState extends State<Userexpensecategory> {
  ///new  code--------------------------start-------------------
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Expensecontroller>().fatchExpenseCategory();
    });
  }

//date 30-3-26----------------
  Map<String, TextEditingController> controllers = {};
  Map<String, dynamic> selectedValues = {};
  void initializeControllers(List<DynamicField> fields) {
    for (var field in fields) {
      controllers[field.fieldName] = TextEditingController();
    }
  }

//date 30-3-26----------------
  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });

    super.dispose();
  }

  /// new code   -----------------------------------end------------

  // final List<String> fuelType = ["Diesel", "Petrol"];
  // final List<String> rentType = ["Hotel", "home", "A", "B"];

  //final commanController = TextEditingController();
  // final commanResuableController = TextEditingController();
  // final List<Map<String, dynamic>> _categories = [
  //   {'name': 'Fuel', 'icon': Icons.local_gas_station},
  //   {'name': 'Hotel', 'icon': Icons.home},
  //   {'name': 'Transport', 'icon': Icons.local_shipping},
  //   {'name': 'SiteItem', 'icon': Icons.construction},
  //   {'name': 'Breakfast', 'icon': Icons.coffee},
  //   {'name': 'Lunch', 'icon': Icons.lunch_dining},
  //   {'name': 'Dinner', 'icon': Icons.restaurant},
  //   {'name': 'Travel', 'icon': Icons.directions_bus},
  //   {'name': 'Bike', 'icon': Icons.pedal_bike},
  //   {'name': 'Boat', 'icon': Icons.directions_boat},
  //   {'name': 'Labour', 'icon': Icons.engineering},
  //   {'name': 'Water', 'icon': Icons.water_drop},
  //   {'name': 'Stationary', 'icon': Icons.edit_note},
  //   {'name': 'Grocery', 'icon': Icons.local_grocery_store},
  //   {'name': 'Others', 'icon': Icons.border_outer_sharp},
  // ];
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

  final _formKey = GlobalKey<FormState>();

  // final Map<String, dynamic> categoryConfig = {
  //   "Fuel": {
  //     "fields": [
  //       {
  //         "type": "dropdown",
  //         "label": "Fuel Type",
  //         "items": ["Petrol", "Diesel", "CNG"],
  //       },
  //       {
  //         "type": "text",
  //         "label": "Fuel Amount",
  //         "hint": "Enter fuel amount",
  //         "validator": "amount",
  //         "amount": "100"
  //       },
  //       {"type": "image", "label": "Fuel Receipt"},
  //     ]
  //   },
  //   "Hotel": {
  //     "fields": [
  //       {
  //         "type": "dropdown",
  //         "label": "Select Hotel",
  //         "items": ["Hotel", "Room", "Flat"],
  //       },
  //       {
  //         "type": "text",
  //         "label": "Rent Amount",
  //         "hint": "Enter rent amount",
  //         "validator": "amount",
  //         "amount": "2000"
  //       },
  //     ]
  //   },
  //   "Transport": {
  //     "fields": [
  //       {
  //         "type": "dropdown",
  //         "label": "Transport Type",
  //         "items": ["Coupe", "Suv", "Van"],
  //       },
  //       {
  //         "type": "text",
  //         "label": "From",
  //         "hint": "Enter source",
  //       },
  //       {
  //         "type": "text",
  //         "label": "To",
  //         "hint": "Enter destination",
  //       },
  //       {
  //         "type": "text",
  //         "label": "Transport Amount",
  //         "hint": "Enter Freight Charges",
  //         "validator": "amount",
  //         "amount": "3000"
  //       },
  //     ]
  //   },
  //   "SiteItem": {
  //     "fields": [
  //       {
  //         "type": "dropdown",
  //         "label": "Select Item",
  //         "items": ["Paint", "Brush", "InchTape", "ScrewDriver", "etc"],
  //       },
  //       {
  //         "type": "text",
  //         "label": "Amount",
  //         "hint": "Enter amount",
  //         "validator": "amount",
  //         "amount": "100"
  //       },
  //     ]
  //   },
  //   "Breakfast": {
  //     "fields": [
  //       {
  //         "type": "text",
  //         "label": "Number of Member",
  //         "hint": "Enter total member",
  //         "validator": "amount",
  //       },
  //       {
  //         "type": "text",
  //         "label": "BreakFast Amount",
  //         "hint": "Enter  amount",
  //         "validator": "amount",
  //         "amount": "200"
  //       },
  //     ]
  //   },
  //   "Lunch": {
  //     "fields": [
  //       {
  //         "type": "text",
  //         "label": "Number of Member",
  //         "hint": "Enter total member",
  //         "validator": "amount",
  //       },
  //       {
  //         "type": "text",
  //         "label": "Luch Amount",
  //         "hint": "Enter  amount",
  //         "validator": "amount",
  //         "amount": "200"
  //       },
  //     ]
  //   },
  //   "Dinner": {
  //     "fields": [
  //       {
  //         "type": "text",
  //         "label": "Number of Member",
  //         "hint": "Enter total member",
  //         "validator": "amount",
  //       },
  //       {
  //         "type": "text",
  //         "label": "Dinner Amount",
  //         "hint": "Enter  amount",
  //         "validator": "amount",
  //         "amount": "150"
  //       },
  //     ]
  //   },
  //   "Travel": {
  //     "fields": [
  //       {
  //         "type": "dropdown",
  //         "label": "Type Of Transport",
  //         "items": ["Bus", "Train"],
  //       },
  //       {
  //         "type": "text",
  //         "label": "From",
  //         "hint": "Enter source",
  //       },
  //       {
  //         "type": "text",
  //         "label": "To",
  //         "hint": "Enter destination",
  //       },
  //       {
  //         "type": "text",
  //         "label": "Travel Amount",
  //         "hint": "Enter amount",
  //         "validator": "amount",
  //         "amount": "3000"
  //       },
  //     ]
  //   },
  //   "Bike": {
  //     "fields": [
  //       {
  //         "type": "dropdown",
  //         "label": "Bike Type",
  //         "items": ["Scooty", "Bike"],
  //       },
  //       {
  //         "type": "text",
  //         "label": "Bike Number",
  //         "hint": "Enter Bike Number",
  //         "validator": "amount",
  //       },
  //       {"type": "image", "label": "Bike Image"},
  //       {
  //         "type": "text",
  //         "label": "Bike Amount",
  //         "hint": "Enter Bike amount",
  //         "validator": "amount",
  //         "amount": "1000"
  //       },
  //     ]
  //   },
  //   "Boat": {
  //     "fields": [
  //       // {
  //       //   "type": "dropdown",
  //       //   "label": "Boat Type",
  //       //   "items": [
  //       //     "Airboat",
  //       //     "Amphibious automobile",
  //       //     "Bow rider",
  //       //     "Cabin cruiser",
  //       //     "Center console",
  //       //     " dory"
  //       //   ],
  //       // },
  //       {
  //         "type": "text",
  //         "label": "Boat Amount",
  //         "hint": "Enter Boat amount",
  //         "validator": "amount",
  //         "amount": "1000"
  //       },
  //     ]
  //   },
  //   "Labour": {
  //     "fields": [
  //       {
  //         "type": "dropdown",
  //         "label": "Labour Type",
  //         "items": [
  //           "Physical Labour",
  //           "Skilled Labour",
  //           "Semi-skilled Labour",
  //           "Unskilled Labour",
  //           "Contract Labour",
  //           " Casual Labour",
  //           "Migrant Labour"
  //         ],
  //       },
  //       {"type": "image", "label": "Image & ID"},
  //       {
  //         "type": "text",
  //         "label": "Labour Amount",
  //         "hint": "Enter labour amount",
  //         "validator": "amount",
  //         "amount": "1500"
  //       },
  //     ]
  //   },
  //   "Water": {
  //     "fields": [
  //       // {
  //       //   "type": "text",
  //       //   "label": "Total battles",
  //       //   "hint": "Enter Total Battle",
  //       //   "validator": "amount",
  //       // },
  //       {
  //         "type": "text",
  //         "label": "Water  Amount",
  //         "hint": "Enter Water amount",
  //         "validator": "amount",
  //         "amount": "100"
  //       },
  //     ]
  //   },
  //   "Stationary": {
  //     "fields": [
  //       {
  //         "type": "text",
  //         "label": "Stationary Item",
  //         "hint": "Enter Stationary item",
  //         "validator": "amount",
  //       },
  //       {
  //         "type": "text",
  //         "label": "Water  Amount",
  //         "hint": "Enter Stationary amount",
  //         "validator": "amount",
  //         "amount": "100"
  //       },
  //     ]
  //   },
  //   "Grocery": {
  //     "fields": [
  //       {
  //         "type": "text",
  //         "label": "Grocery Item",
  //         "hint": "Enter Grocery item",
  //         "validator": "amount",
  //       },
  //       {
  //         "type": "text",
  //         "label": "Grocery  Amount",
  //         "hint": "Enter Grocery amount",
  //         "validator": "amount",
  //         "amount": "200"
  //       },
  //     ]
  //   },
  //   "Others": {
  //     "fields": [
  //       {
  //         "type": "text",
  //         "label": "Description",
  //         "hint": "Enter description",
  //       },
  //       {
  //         "type": "text",
  //         "label": "Amount",
  //         "hint": "Enter amount",
  //         "validator": "amount",
  //         "amount": "100"
  //       },
  //     ]
  //   },
  // };

  //String selectedCategory = "";
//?DATE 2-6-2============================================

  int? selectedCategoryId;
  String? selectedCategoryName;
  final Map<String, dynamic> formData = {};

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
          body: RefreshIndicator(
            onRefresh: () async {
              await context.read<Expensecontroller>().refreshExpenseCategory();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<Expensecontroller>(
                      builder: (context, con, child) {
                        return _builDate(con);
                      },
                    ),
                    Center(
                      child: const Text('Select Category:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    //calling method for select list of category top of the screen
                    Consumer<Expensecontroller>(
                      builder: (context, controller, child) =>
                          _buildCategoryItem(controller),
                    ),
                    Divider(),
                    //calling provider method.... dynamic text form field for fill update use expense.....
                    Consumer<Expensecontroller>(
                        builder: (context, controller, child) =>
                            buildDynamicExpenseForm(controller)),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget selectImageAndFill(String label) {
    return Consumer<Expensecontroller>(
      builder: (context, expenseController, child) {
        // No Image Selected
        if (!expenseController.isImage && !expenseController.isFile) {
          return Padding(
            padding: const EdgeInsets.all(16),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Tap to upload images or PDF",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Image Preview
        if (expenseController.listofImage.isNotEmpty) {
          final images = expenseController.listofImage;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Uploaded Image (${images.length})",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: images.length + 1,
                  itemBuilder: (context, index) {
                    // Add More Tile
                    if (index == images.length) {
                      return InkWell(
                        onTap: () {
                          expenseController.selectMutlipleImageFromGallery();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 35,
                            ),
                          ),
                        ),
                      );
                    }

                    final img = images[index];

                    return Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(img),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: InkWell(
                            onTap: () {
                              expenseController.clearImageList(index);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
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

  Widget _buildCategoryItem(Expensecontroller controller) {
    if (controller.isLoadExpenseCategory &&
        controller.expenseCateList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    if (controller.catError != null && controller.expenseCateList.isEmpty) {
      return Center(child: Text("Failed to load categories"));
    }
    if (controller.expenseCateList.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: SizeConFig.screenHeight * 0.28,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4,
        ),
        itemCount: controller.expenseCateList.length,
        itemBuilder: (context, index) {
          final data = controller.expenseCateList[index];
          bool isSelected = selectedCategoryId == data.id;
          return GestureDetector(
            onTap: () async {
              // current code always calls API:
              if (selectedCategoryId == data.id) {
                return;
              }
              // Clear previous form data
              controllers.forEach((key, controller) {
                controller.clear();
              });
              controllers.clear();
              selectedValues.clear();
              formData.clear();
              //for clear image form provider
              controller.clearAllAttachments();

              await controller.dynamicFormField(data.id);
              setState(() {
                selectedCategoryId = data.id;
                selectedCategoryName = data.categoryName;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected

                    // ignore: deprecated_member_use
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(getCategoryIcon(data.categoryName)),
                    Text(
                      data.categoryName,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    )
                  ]),
            ),
          );
        },
      ),
    );
  }

  Widget _builDate(Expensecontroller controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 157, 199, 199),
            borderRadius: BorderRadius.circular(11)),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIncreseDecrseButton(
                () => controller.changeDate(-1), Icons.arrow_back),
            Text("${controller.dateFormat.format(controller.selectedDate)}"),
            _buildIncreseDecrseButton(
                () => controller.changeDate(1), Icons.arrow_forward)
          ],
        )),
      ),
    );
  }

  Widget _buildIncreseDecrseButton(VoidCallback onTap, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
          color: Colors.blue, iconSize: 20, onPressed: onTap, icon: Icon(icon)),
    );
  }

  void submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final expenseController = context.read<Expensecontroller>();
    final payload = {
      "expenseCategoryId": selectedCategoryId,
      "expenseCategoryName": selectedCategoryName,
      "expenseFields": formData,
      "attachments": List<String>.from(expenseController.listofImage),
    };
    debugPrint(payload.toString());
    ShowTaostMessage.toastMessage(
      context,
      "Data Submitted",
    );
  }

  //DATE NEW CODE ..............................1=6-26
  double maxAllowedAmount = 0;
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
            // onPressed: submitValidation,
            onPressed: submitForm,
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }

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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controllers[field.fieldName],
        onChanged: (value) {
          formData[field.fieldName] = value.trim();
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
    );
  }

  Widget buildDropdown(DynamicField field) {
    return Padding(
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
            selectedValues[field.fieldName] = value;
            formData[field.fieldName] = value;
          });
        },
        validator: (value) {
          if (field.isRequired && (value == null || value.isEmpty)) {
            return "${field.fieldLabel} is required";
          }
          return null;
        },
      ),
    );
  }

  Widget buildNumberField(DynamicField field) {
    controllers.putIfAbsent(
      field.fieldName,
      () => TextEditingController(),
    );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controllers[field.fieldName],
        keyboardType: TextInputType.number,
        onChanged: (value) {
          formData[field.fieldName] = int.tryParse(value);
        },
        decoration: InputDecoration(
          labelText: field.fieldLabel,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (field.isRequired && (value == null || value.isEmpty)) {
            return "${field.fieldLabel} is required";
          }

          final amount = int.tryParse(value ?? "");

          if (amount == null) {
            return "Enter valid amount";
          }
          if (field.fieldName.toLowerCase() == "amount") {
            if (amount > maxAllowedAmount) {
              return "Maximum ₹$maxAllowedAmount allowed";
            }
          }

          return null;
        },
      ),
    );
  }
}
// {
//   "expenseCategoryId": 1,
//   "expenseCategoryName": "Fuel",
//   "expenseFields": {
//     "Fuel": "HP Petrol Pump",
//     "Fuel-Type": "Petrol",
//     "Amount": 500,
//     "Bill-Image": [
//       "/storage/emulated/0/Download/bill1.jpg",
//       "/storage/emulated/0/Download/bill2.jpg"
//     ]
//   }
// }
// setState(() {
//   selectedCategoryId = data.id;
//   selectedCategoryName = data.categoryName;

//   formData.clear();
//   selectedValues.clear();

//   controllers.forEach((key, controller) {
//     controller.clear();
//   });
// });
