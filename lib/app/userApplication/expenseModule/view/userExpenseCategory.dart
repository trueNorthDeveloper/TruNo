import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/controller/expenseController.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/app_button.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/app_field_text.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class Userexpensecategory extends StatefulWidget {
  Userexpensecategory({super.key});
  State<Userexpensecategory> createState() => _UserexpensescreenzsState();
}

class _UserexpensescreenzsState extends State<Userexpensecategory> {
  ///new  code--------------------------start-------------------

  Map<String, TextEditingController> controllers = {};
  Map<String, dynamic> formData = {};
  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  void initializeControllers() {
    categoryConfig.forEach((category, config) {
      for (var field in config['fields']) {
        String key = field['label'];

        controllers[key] = TextEditingController();
      }
    });
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });

    super.dispose();
  }

  /// new code   -----------------------------------end------------

  String? _selectedCategory;
  final List<String> fuelType = ["Diesel", "Petrol"];
  final List<String> rentType = ["Hotel", "home", "A", "B"];
  // final _amountController = TextEditingController();
  //final _fuelTypeController = TextEditingController();
  final commanController = TextEditingController();
  final commanResuableController = TextEditingController();
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Fuel', 'icon': Icons.local_gas_station},
    {'name': 'Hotel', 'icon': Icons.home},
    {'name': 'Transport', 'icon': Icons.local_shipping},
    {'name': 'SiteItem', 'icon': Icons.construction},
    {'name': 'Breakfast', 'icon': Icons.coffee},
    {'name': 'Lunch', 'icon': Icons.lunch_dining},
    {'name': 'Dinner', 'icon': Icons.restaurant},
    {'name': 'Travel', 'icon': Icons.directions_bus},
    {'name': 'Bike', 'icon': Icons.pedal_bike},
    {'name': 'Boat', 'icon': Icons.directions_boat},
    {'name': 'Labour', 'icon': Icons.engineering},
    {'name': 'Water', 'icon': Icons.water_drop},
    {'name': 'Stationary', 'icon': Icons.edit_note},
    {'name': 'Grocery', 'icon': Icons.local_grocery_store},
    {'name': 'Others', 'icon': Icons.border_outer_sharp},
  ];
  final _formKey = GlobalKey<FormState>();
  String? fuelTypee;
  final Map<String, dynamic> categoryConfig = {
    "Fuel": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Fuel Type",
          "items": ["Petrol", "Diesel", "CNG"],
        },
        {
          "type": "text",
          "label": "Fuel Amount",
          "hint": "Enter fuel amount",
          "validator": "amount",
          "amount": "100"
        },
        {"type": "image", "label": "Fuel Receipt"},
      ]
    },
    "Hotel": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Select Hotel",
          "items": ["Hotel", "Room", "Flat"],
        },
        {
          "type": "text",
          "label": "Rent Amount",
          "hint": "Enter rent amount",
          "validator": "amount",
          "amount": "2000"
        },
      ]
    },
    "Transport": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Transport Type",
          "items": ["Coupe", "Suv", "Van"],
        },
        {
          "type": "text",
          "label": "From",
          "hint": "Enter source",
        },
        {
          "type": "text",
          "label": "To",
          "hint": "Enter destination",
        },
        {
          "type": "text",
          "label": "Transport Amount",
          "hint": "Enter Freight Charges",
          "validator": "amount",
          "amount": "3000"
        },
      ]
    },
    "SiteItem": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Select Item",
          "items": ["Paint", "Brush", "InchTape", "ScrewDriver", "etc"],
        },
        {
          "type": "text",
          "label": "Amount",
          "hint": "Enter amount",
          "validator": "amount",
          "amount": "100"
        },
      ]
    },
    "Breakfast": {
      "fields": [
        {
          "type": "text",
          "label": "Number of Member",
          "hint": "Enter total member",
          "validator": "amount",
        },
        {
          "type": "text",
          "label": "BreakFast Amount",
          "hint": "Enter  amount",
          "validator": "amount",
          "amount": "200"
        },
      ]
    },
    "Lunch": {
      "fields": [
        {
          "type": "text",
          "label": "Number of Member",
          "hint": "Enter total member",
          "validator": "amount",
        },
        {
          "type": "text",
          "label": "Luch Amount",
          "hint": "Enter  amount",
          "validator": "amount",
          "amount": "200"
        },
      ]
    },
    "Dinner": {
      "fields": [
        {
          "type": "text",
          "label": "Number of Member",
          "hint": "Enter total member",
          "validator": "amount",
        },
        {
          "type": "text",
          "label": "Dinner Amount",
          "hint": "Enter  amount",
          "validator": "amount",
          "amount": "150"
        },
      ]
    },
    "Travel": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Type Of Transport",
          "items": ["Bus", "Train"],
        },
        {
          "type": "text",
          "label": "From",
          "hint": "Enter source",
        },
        {
          "type": "text",
          "label": "To",
          "hint": "Enter destination",
        },
        {
          "type": "text",
          "label": "Travel Amount",
          "hint": "Enter amount",
          "validator": "amount",
          "amount": "3000"
        },
      ]
    },
    "Bike": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Bike Type",
          "items": ["Scooty", "Bike"],
        },
        {
          "type": "text",
          "label": "Bike Number",
          "hint": "Enter Bike Number",
          "validator": "amount",
        },
        {"type": "image", "label": "Bike Image"},
        {
          "type": "text",
          "label": "Bike Amount",
          "hint": "Enter Bike amount",
          "validator": "amount",
          "amount": "1000"
        },
      ]
    },
    "Boat": {
      "fields": [
        // {
        //   "type": "dropdown",
        //   "label": "Boat Type",
        //   "items": [
        //     "Airboat",
        //     "Amphibious automobile",
        //     "Bow rider",
        //     "Cabin cruiser",
        //     "Center console",
        //     " dory"
        //   ],
        // },
        {
          "type": "text",
          "label": "Boat Amount",
          "hint": "Enter Boat amount",
          "validator": "amount",
          "amount": "1000"
        },
      ]
    },
    "Labour": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Labour Type",
          "items": [
            "Physical Labour",
            "Skilled Labour",
            "Semi-skilled Labour",
            "Unskilled Labour",
            "Contract Labour",
            " Casual Labour",
            "Migrant Labour"
          ],
        },
        {"type": "image", "label": "Image & ID"},
        {
          "type": "text",
          "label": "Labour Amount",
          "hint": "Enter labour amount",
          "validator": "amount",
          "amount": "1500"
        },
      ]
    },
    "Water": {
      "fields": [
        // {
        //   "type": "text",
        //   "label": "Total battles",
        //   "hint": "Enter Total Battle",
        //   "validator": "amount",
        // },
        {
          "type": "text",
          "label": "Water  Amount",
          "hint": "Enter Water amount",
          "validator": "amount",
          "amount": "100"
        },
      ]
    },
    "Stationary": {
      "fields": [
        {
          "type": "text",
          "label": "Stationary Item",
          "hint": "Enter Stationary item",
          "validator": "amount",
        },
        {
          "type": "text",
          "label": "Water  Amount",
          "hint": "Enter Stationary amount",
          "validator": "amount",
          "amount": "100"
        },
      ]
    },
    "Grocery": {
      "fields": [
        {
          "type": "text",
          "label": "Grocery Item",
          "hint": "Enter Grocery item",
          "validator": "amount",
        },
        {
          "type": "text",
          "label": "Grocery  Amount",
          "hint": "Enter Grocery amount",
          "validator": "amount",
          "amount": "200"
        },
      ]
    },
    "Others": {
      "fields": [
        {
          "type": "text",
          "label": "Description",
          "hint": "Enter description",
        },
        {
          "type": "text",
          "label": "Amount",
          "hint": "Enter amount",
          "validator": "amount",
          "amount": "100"
        },
      ]
    },
  };

  String selectedCategory = "";

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
            body: SafeArea(
              child: SingleChildScrollView(
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
                    //SELCYT EXPENSE CATEGORY BASED ON INDEX.... VARIABLE.............
                    Consumer<Expensecontroller>(
                      builder: (context, controller, child) =>
                          _buildCategoryItem(controller),
                    ),
                    Divider(),
                    buildDynamicForm(),
                  ],
                ),
              ),
            )));
  }

  Widget selectImageAndFill(String label) {
    return Consumer<Expensecontroller>(
      builder: (context, expenseController, child) {
        if (expenseController.isImage == false &&
            expenseController.isFile == false) {
          return Center(
            child: AppButton(
              text: label,
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final result = await showDialogBoxForImage(context);
                if (result == "image") {
                  expenseController.selectMutlipleImageFromGallery();
                } else if (result == "file") {
                  expenseController.selectPdfDocFromDevice();
                }
              },
              buttonColor: Colors.blue,
              borderRadius: 80,
              elevation: 4,
              padding: 12,
              fontSize: 12,
              textColor: Colors.white,
              fontWeight: FontWeight.bold,
              width: MediaQuery.of(context).size.width * 0.3,
              height: 40,
              borderWidth: 0,
            ),
          );
        }

        if (expenseController.listofImage.isNotEmpty) {
          final image = expenseController.listofImage;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: image.length + 1,
              itemBuilder: (context, index) {
                if (index == image.length) {
                  return GestureDetector(
                    onTap: () {
                      expenseController.selectMutlipleImageFromGallery();
                    },
                    child: Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.add, size: 40),
                    ),
                  );
                }

                final img = image[index];
                // FIXED: Stack is now placed correctly inside the grid item cell
                return Stack(
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
                    Positioned(
                      right: 4,
                      top: 4,
                      child: GestureDetector(
                        onTap: () {
                          expenseController.clearImageList(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
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

  Widget _buildDropDownText(
      List<String> item, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          // decoration: BoxDecoration(
          //   color: Colors.red,
          // ),
          width: SizeConFig.proportionalWidth * 5,
          child: TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              prefixIcon: const Icon(
                Icons.local_gas_station,
              ),
              suffixIcon: PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  setState(() {
                    // selectedFuelType = value;
                    // controller.text = value;
                    // _fuelTypeController.text = value;
                    controller.text = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return item.map((item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList();
                },
              ),
            ),
          )),
    );
  }

  Widget _buildCategoryItem(Expensecontroller controller) {
    return Container(
      //height: 285,
      height: SizeConFig.screenHeight * 0.28,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4,
          //
          //mainAxisSpacing: 10
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          bool isSelected = _selectedCategory == cat['name'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat["name"];
                selectedCategory = _categories[index]['name'];
              });
              // controller.setIndexValue(index);
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
                    Icon(cat['icon']),
                    Text(
                      cat['name'],
                      style: TextStyle(fontSize: 13),
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
                () => controller.changeDate(-1), Icons.arrow_forward_ios),
            Text("${controller.dateFormat.format(controller.selectedDate)}"),
            _buildIncreseDecrseButton(
                () => controller.changeDate(1), Icons.arrow_back_ios_new_sharp)
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

  Widget _createResuableTextFiled(
    TextEditingController controller,
    String label,
    String hint, {
    String? validatorType,
    String? validateAmount,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: SizeConFig.proportionalWidth * 5,
          child: AppTextField(
            controller: controller,
            label: label,
            //   focusNode: _myFocusNode,
            hint: hint,
            keyboardType: TextInputType.numberWithOptions(),
            // validator: (value) {
            //   if (value == null || value.trim().isEmpty) {
            //     return "Please enter $label";
            //   }

            //   /// Amount Validation
            //   if (validatorType == "amount") {
            //     final number = int.tryParse(value);

            //     if (number == null) {
            //       return "Invalid amount";
            //     }

            //     if (number > 100) {
            //       return "Amount too large";
            //     }
            //   }

            //   /// Number Validation
            //   if (validatorType == "number") {
            //     if (int.tryParse(value) == null) {
            //       return "Only numbers allowed";
            //     }
            //   }

            //   return null;
            // },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "please enter $label";
              }
              final validAmount = int.tryParse(validateAmount!);
              if (validatorType == "amount") {
                final number = int.tryParse(value);
                if (number == null) {
                  return "Invalid amount";
                }
                if (number > validAmount!) {
                  return "Amount too Large >${validAmount}";
                }
              }
              return null;
            },
          )),
    );
  }

  Widget buildDynamicForm() {
    if (selectedCategory.isEmpty) {
      return const SizedBox();
    }

    final fields = categoryConfig[selectedCategory]["fields"];

    return Form(
      key: _formKey,
      child: Column(
        //  / mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...fields.map<Widget>((field) {
            /// DROPDOWN
            final label = field["label"];
            final controller = controllers[label]!;
            if (field["type"] == "dropdown") {
              return _buildDropDownText(
                  List<String>.from(field["items"]), label, controller);
            }

            /// TEXTFIELD
            if (field["type"] == "text") {
              return _createResuableTextFiled(
                  //commanResuableController, field["label"], field["hint"],
                  controller,
                  label,
                  field["hint"],
                  validatorType: field["validator"],
                  validateAmount: field["amount"]);
            }
            if (field["type"] == "image") {
              return selectImageAndFill(field["label"]);
            }

            return const SizedBox();
          }).toList(),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ShowTaostMessage.toastMessage(
                  context,
                  "Processing Data",
                );
              }
              submitForm();
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> finalData = {};

      final fields = categoryConfig[selectedCategory]["fields"];

      for (var field in fields) {
        String label = field["label"];

        finalData[label] = controllers[label]?.text ?? "";
      }

      finalData["category"] = selectedCategory;

      print(finalData);

      /*
    OUTPUT:

    {
      category: Fuel,
      Fuel Type: Diesel,
      Fuel Amount: 50
    }

    */

      ShowTaostMessage.toastMessage(
        context,
        "Data Submitted",
      );
    }
  }
}
  // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: TextFormField(
              //     controller: _amountController,
              //     keyboardType: TextInputType.number,
              //     decoration: const InputDecoration(
              //         labelText: 'Amount', border: OutlineInputBorder()),
              //     validator: (v) =>
              //         (v == null || v.isEmpty) ? 'Enter amount' : null,
              //   ),
              // ),