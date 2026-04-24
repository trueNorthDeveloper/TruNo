import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/expenseModule/controller/expenseController.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class UserExpenseScreens extends StatefulWidget {
  const UserExpenseScreens({super.key});

  @override
  State<UserExpenseScreens> createState() => _UserexpensescreenzsState();
}

class _UserexpensescreenzsState extends State<UserExpenseScreens> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedCategory;
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Petrol', 'icon': Icons.local_gas_station},
    {'name': 'Rent', 'icon': Icons.home},
    {'name': 'Loading', 'icon': Icons.local_shipping},
    {'name': 'Site Item', 'icon': Icons.construction},
    {'name': 'Breakfast', 'icon': Icons.coffee},
    {'name': 'Lunch', 'icon': Icons.lunch_dining},
    {'name': 'Dinner', 'icon': Icons.restaurant},
    {'name': 'Travel', 'icon': Icons.directions_bus},
    {'name': 'Bike', 'icon': Icons.pedal_bike},
    {'name': 'Boat', 'icon': Icons.directions_boat},
    {'name': 'Labour', 'icon': Icons.engineering},
    {'name': 'Water', 'icon': Icons.water_drop},
    {'name': 'Vehical', 'icon': Icons.settings},
    {'name': 'Stationary', 'icon': Icons.edit_note},
    {'name': 'Grocery', 'icon': Icons.local_grocery_store},
    {'name': 'Others', 'icon': Icons.border_outer_sharp},
  ];
  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      print('Amount: ${_amountController.text}, Cat: $_selectedCategory');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch and format on page open
    Provider.of<Expensecontroller>(context, listen: false).resetDate();
  }

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
          "EXPENSE",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              //show date top of screen with icons increse and decrese date
              Consumer<Expensecontroller>(
                builder: (context, con, child) {
                  return _builDate(con);
                },
              ),
              SizedBox(
                height: SizeConFig.screenHeight * 1 / 100,
              ),
//item of top of the screen like total credit and balance and expense....
              _buildItemCat(),
//TEXT FILED FOR ADD AMOUNT ON SELECTED FILED
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Amount', border: OutlineInputBorder()),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter amount' : null,
                ),
              ),
              const Text('Select Category:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
//create category of selected items
              _buildCategoryItem(),
//SAVE BUTTON OF ITEM......
              ElevatedButton(
                  onPressed: _submitForm, child: const Text('Save Expense')),
            ],
          )),
    );
  }

  Widget _buildCategoryItem() {
    return Expanded(
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
            onTap: () => setState(() => _selectedCategory = cat['name']),
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

  Widget _buildItemCat() {
    return Container(
      height: 100,
      child: GridView.builder(
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 150, mainAxisExtent: 50),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              child: Column(
                children: [
                  Icon(Icons.settings_applications),
                  Text(
                    "Item",
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
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
}
