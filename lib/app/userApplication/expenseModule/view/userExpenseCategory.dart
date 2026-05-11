import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/controller/expenseController.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/app_field_text.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';

class Userexpensecategory extends StatefulWidget {
  Userexpensecategory({super.key});
  State<Userexpensecategory> createState() => _UserexpensescreenzsState();
}

class _UserexpensescreenzsState extends State<Userexpensecategory> {
  String? _selectedCategory;
  final List<String> fuelType = ["Diesel", "Petrol"];
  final List<String> rentType = ["Hotel", "home", "A", "B"];
  final _amountController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Fuel', 'icon': Icons.local_gas_station},
    {'name': 'Rent', 'icon': Icons.home},
    {'name': 'Loading', 'icon': Icons.local_shipping},
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
        },
        {
          "type": "text",
          "label": "KM",
          "hint": "Enter total KM",
          "validator": "number",
        },
      ]
    },
    "Rent": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Rent Type",
          "items": ["Office", "Room"],
        },
        {
          "type": "text",
          "label": "Rent Amount",
          "hint": "Enter rent amount",
          "validator": "amount",
        },
      ]
    },
    "Loading": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Loading Type",
          "items": ["Coupe", "Suv", "Van"],
        },
        {
          "type": "text",
          "label": "loading Amount",
          "hint": "Enter loading amount",
          "validator": "amount",
        },
      ]
    },
    "SiteItem": {
      "fields": [
        {
          "type": "text",
          "label": "Amount",
          "hint": "Enter amount",
          "validator": "amount",
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
        },
      ]
    },
    "Travel": {
      "fields": [
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
          "label": "Bike Amount",
          "hint": "Enter Bike amount",
          "validator": "amount",
        },
      ]
    },
     "Boat": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Boat Type",
          "items": ["Airboat", "Amphibious automobile","Bow rider","Cabin cruiser","Center console"," dory"],
        },
        {
          "type": "text",
          "label": "Boat Amount",
          "hint": "Enter Boat amount",
          "validator": "amount",
        },
      ]
    },
     "Labour": {
      "fields": [
        {
          "type": "dropdown",
          "label": "Labour Type",
          "items": ["Physical Labour", "Skilled Labour","Semi-skilled Labour","Unskilled Labour","Contract Labour"," Casual Labour","Migrant Labour"],
        },
        {
          "type": "text",
          "label": "Labour Amount",
          "hint": "Enter labour amount",
          "validator": "amount",
        },
      ]
    },
     "Water": {
      "fields": [
         {
          "type": "text",
          "label": "Total battles",
          "hint": "Enter Total Battle",
          "validator": "amount",
        },
        {
          "type": "text",
          "label": "Water  Amount",
          "hint": "Enter Water amount",
          "validator": "amount",
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
        },
      ]
    },
  };
  String selectedCategory = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              buildDynamicForm(),
              // Consumer<Expensecontroller>(
              //   builder: (context, controllValue, child) {
              //     if (controllValue.setValue == 0) {
              //       return _buildFieldWithForm(0);
              //     }
              //     if (controllValue.setValue == 1) {
              //       return _buildFieldWithForm(1);
              //     }

              //     return SizedBox();
              //   },
              // ),
            ],
          ),
        )));
  }

  // Widget _buildFieldWithForm(int position) {
  //   if (position == 0)
  //     return Form(
  //         key: _formKey,
  //         child: Column(
  //           children: [
  //             _buildZeroPostionWithFuel(fuelType, "Select Fuel Type",
  //                 "Fuel Amount", "Enter fuel amount", _amountController, 0),
  //             ElevatedButton(
  //               onPressed: () {
  //                 // Step 4: Manually trigger validation
  //                 if (_formKey.currentState!.validate()) {
  //                   ShowTaostMessage.toastMessage(context, "processing data");
  //                 }
  //               },
  //               child: const Text('Submit'),
  //             ),
  //           ],
  //         ));
  //   if (position == 1) {
  //     return Form(
  //         key: _formKey,
  //         child: Column(
  //           children: [
  //             _buildZeroPostionWithFuel(rentType, "Select Rent Type",
  //                 "rent Amount", "Enter rent amount", _fuelTypeController, 1),
  //             ElevatedButton(
  //               onPressed: () {
  //                 // Step 4: Manually trigger validation
  //                 if (_formKey.currentState!.validate()) {
  //                   ShowTaostMessage.toastMessage(context, "processing data");
  //                 }
  //               },
  //               child: const Text('Submit'),
  //             ),
  //           ],
  //         ));
  //   }
  //   return SizedBox();
  // }

  // Widget _buildZeroPostionWithFuel(
  //     List<String> dropDownitem,
  //     String dropDowmLabel,
  //     String label,
  //     String hint,
  //     TextEditingController controller,
  //     int position) {
  //   if (position == 0) {
  //     return Column(
  //       children: [
  //         _buildDropDownText(dropDownitem, dropDowmLabel),
  //         _createResuableTextFiled(label, hint, controller),
  //       ],
  //     );
  //   }
  //   if (position == 1) {
  //     return Column(
  //       children: [_buildDropDownText(dropDownitem, dropDowmLabel)],
  //     );
  //   }
  //   return SizedBox();
  // }

  // Widget _createResuableTextFiled(
  //     String label, String hint, TextEditingController controller) {
  //   return Column(
  //     children: [
  //       // _buildDropDownText(dropDownitem, dropDowmLabel),
  //       Padding(
  //         padding: EdgeInsetsGeometry.all(16.0),
  //         child: AppTextField(
  //           controller: controller,
  //           label: label,
  //           hint: hint,
  //           keyboardType: TextInputType.number,
  //           prefixIcon: const Icon(Icons.local_gas_station),
  //           inputFormatters: [
  //             FilteringTextInputFormatter.digitsOnly,
  //           ],
  //           validator: (value) {
  //             int valtoInteg = int.parse(value!);
  //             if (value.trim().isEmpty) {
  //               return "Please enter ${label}";
  //             }

  //             if (int.tryParse(value) == null) {
  //               return "Invalid number";
  //             }
  //             if (valtoInteg > 150) {
  //               return "Amount should be less then 150 ";
  //             }

  //             return null;
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildDropDownText(List<String> item, String label) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _fuelTypeController,
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
                _fuelTypeController.text = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return item.map((member) {
                return PopupMenuItem<String>(
                  value: member,
                  child: Text(member),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Expensecontroller controller) {
    return Container(
      height: 350,
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
                print(index);
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
    String label,
    String hint, {
    String? validatorType,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppTextField(
        controller: TextEditingController(),
        label: label,
        hint: hint,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter $label";
          }

          /// Amount Validation
          if (validatorType == "amount") {
            final number = int.tryParse(value);

            if (number == null) {
              return "Invalid amount";
            }

            if (number > 10000) {
              return "Amount too large";
            }
          }

          /// Number Validation
          if (validatorType == "number") {
            if (int.tryParse(value) == null) {
              return "Only numbers allowed";
            }
          }

          return null;
        },
      ),
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
        children: [
          ...fields.map<Widget>((field) {
            /// DROPDOWN
            if (field["type"] == "dropdown") {
              return _buildDropDownText(
                List<String>.from(field["items"]),
                field["label"],
              );
            }

            /// TEXTFIELD
            if (field["type"] == "text") {
              return _createResuableTextFiled(
                field["label"],
                field["hint"],
                validatorType: field["validator"],
              );
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
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
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