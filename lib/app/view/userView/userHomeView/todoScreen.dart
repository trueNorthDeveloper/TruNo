import 'package:flutter/material.dart';

import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class Todoscreen extends StatefulWidget {
  const Todoscreen({super.key});
  State<Todoscreen> createState() => _todoScreenState();
}

class _todoScreenState extends State<Todoscreen> {
 final List<Map<String, dynamic>> todo = [
    {
      "name": "ABC",
      "date": "01-2026",
      "done": false,
    },
    {
      "name": "Buy Milk",
      "date": "02-2026",
      "done": true,
    },
  ];

  final List<String> items = ['Personal', 'Work', 'Project', 'Default'];
  String? selectedValue = 'Personal';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "To-Do-List",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            // width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //left item.................................
                SizedBox(
                  width: SizeConFig.proportionalWidth * 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.dark_mode_outlined, size: 30),
                      DropdownButton<String>(
                        value: selectedValue,
                        items: items.map((String value) {
                          return DropdownMenuItem<String>(
                              child: Text(value), value: value);
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                //RIGHT SIZE BOX
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Icon(Icons.search, size: 30),
                      ),
                      SizedBox(
                        child: Icon(
                          Icons.menu_open_rounded,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: SizeConFig.proportionalHeight * 5.3,
            child: Center(
                child: ListView.builder(
              itemCount: todo.length,
              itemBuilder: (context, index) {
                final item = todo[index];

                return Dismissible(
                  key: Key(item["name"]),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() {
                      todo.removeAt(index);
                    });
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          // Checkbox
                          Checkbox(
                            value: item["done"],
                            onChanged: (value) {
                              setState(() {
                                item["done"] = value;
                              });
                            },
                          ),

                          // Task Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["name"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: item["done"]
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["date"],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Edit Button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )),
          ),
        ],

        // Center(
        //     child: ListView.builder(
        //   itemCount: todo.length,
        //   itemBuilder: (context, index) {
        //     final item = todo[index];

        //     return Dismissible(
        //       key: Key(item["name"]),
        //       direction: DismissDirection.endToStart,
        //       background: Container(
        //         alignment: Alignment.centerRight,
        //         padding: const EdgeInsets.only(right: 20),
        //         color: Colors.red,
        //         child: const Icon(Icons.delete, color: Colors.white),
        //       ),
        //       onDismissed: (_) {
        //         setState(() {
        //           todo.removeAt(index);
        //         });
        //       },
        //       child: Card(
        //         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //         elevation: 4,
        //         child: Padding(
        //           padding: const EdgeInsets.all(12),
        //           child: Row(
        //             children: [
        //               // Checkbox
        //               Checkbox(
        //                 value: item["done"],
        //                 onChanged: (value) {
        //                   setState(() {
        //                     item["done"] = value;
        //                   });
        //                 },
        //               ),

        //               // Task Info
        //               Expanded(
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       item["name"],
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         fontWeight: FontWeight.bold,
        //                         decoration: item["done"]
        //                             ? TextDecoration.lineThrough
        //                             : TextDecoration.none,
        //                       ),
        //                     ),
        //                     const SizedBox(height: 4),
        //                     Text(
        //                       item["date"],
        //                       style: TextStyle(
        //                         color: Colors.grey[600],
        //                         fontSize: 13,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),

        //               // Edit Button
        //               IconButton(
        //                 icon: const Icon(Icons.edit, color: Colors.blue),
        //                 onPressed: () {
        //                   // TODO: Edit Bottom Sheet / Dialog
        //                 },
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // )),
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddTaskBottomSheet(context);
        },
      ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Task Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Task Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Date Picker
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Due Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dateController.text =
                        "${picked.day}-${picked.month}-${picked.year}";
                  }
                },
              ),
              const SizedBox(height: 16),

              // Add Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text("Add Task"),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        dateController.text.isNotEmpty) {
                      setState(() {
                        todo.add({
                          "name": nameController.text,
                          "date": dateController.text,
                          "done": false,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
