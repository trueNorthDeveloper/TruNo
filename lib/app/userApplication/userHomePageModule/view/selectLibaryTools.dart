import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userHomePageModule/controller/user_dashboard_provider.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/buildCustomText.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/mesage_snack_bar.dart';
import 'package:truenorthflutterfrontend/public/utils/userUtil/size_config.dart';

class Selectlibarytools extends StatefulWidget {
  const Selectlibarytools({super.key});
  @override
  State<Selectlibarytools> createState() => CreateLibaryToolsState();
}

class CreateLibaryToolsState extends State<Selectlibarytools> {
  List<String> libaryTools = [
    "office-tools",
    'site-tools',
    "vehical",
    "Miscellaneous"
  ];
  final Map<String, List<String>> toolItemsMap = {
    "office-tools": [
      "Desktop",
      "Laptop",
      "Printer",
    ],
    "site-tools": [
      "DGPS",
      "Survey Machine",
      "Total Station",
    ],
    "vehical": [
      "DGPS Vehicle",
      "Transport Vehicle",
    ],
    "Miscellaneous": [],
  };
  TextEditingController selectCategoryController = TextEditingController();
  TextEditingController selectCategoryItemController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController requestController = TextEditingController();
  @override
  void initState() {
    super.initState();

    // Reset when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserDashboardProvider>().resetRequestState();
    });
  }

  @override
  void dispose() {
    selectCategoryController.dispose();
    selectCategoryItemController.dispose();
    itemController.dispose();
    //requestController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserDashboardProvider>(context, listen: false)
        .clearToolsAndSelected();
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
            "Select Tools",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
            ),
          ),
        ),
        body: Column(
          children: [
            SizeConFig.verticalBox(0.03),
//SELECT TOOLS TYPE.............................................1
            Consumer<UserDashboardProvider>(
              builder: (context, toolPro, _) {
                return buildSelectField<String>(
                  controller: selectCategoryController,
                  label: "Select  Category",
                  items: toolPro.category,
                  itemLabel: (item) => item,
                  leadingIcon: Icons.category,
                  onSelected: (selectedType) {
                    selectCategoryController.text = selectedType;
                    // selectItemController.cl();
                    // toolPro.selectToolType(selectedType);
                    toolPro.availableTools(selectedType);
                  },
                );
              },
            ),
            SizeConFig.verticalBox(0.01),
//---------------------------------------------------2
            Consumer<UserDashboardProvider>(
              builder: (context, toolPro, _) {
                if (toolPro.currentSelectCategory == null) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: buildSelectField<String>(
                    controller: selectCategoryItemController,
                    label: "Category tools",
                    items: toolPro.chooseAvaibleTools,
                    itemLabel: (item) => item,
                    leadingIcon: Icons.build,
                    onSelected: (selected) {
                      toolPro.selectChooseCategory(selected);
                    },
                  ),
                );
              },
            ),
            SizeConFig.verticalBox(0.01),
            //date 24-1-26
//---------------------------------------------------------------3
            Consumer<UserDashboardProvider>(
              builder: (context, toolPro, _) {
                if (toolPro.selectChooseItem == null) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: buildSelectField<String>(
                    controller: itemController,
                    label: "select tools",
                    //here new seleted list view
                    items: toolPro.selectChooseItemList,
                    itemLabel: (item) => item,
                    leadingIcon: Icons.build,
                    onSelected: (selected) {
                      toolPro.findAvaibliltiy(selected);
                      print(selected);
                    },
                  ),
                );
              },
            ),

            //---------------------------------------------4

            Consumer<UserDashboardProvider>(
              builder: (context, toolPro, _) {
                if (itemController.text.isEmpty) return const SizedBox();

                if (toolPro.toolsAvaibles) {
                  return BuildCustomText(
                    data: "✅ ${itemController.text} is available",
                    color: Colors.green,
                  );
                }

                if (!toolPro.toolsAvaibles && toolPro.errorMessage != null) {
                  return BuildCustomText(
                    data: toolPro.errorMessage!,
                    color: Colors.red,
                  );
                }

                return const SizedBox();
              },
            ),
            Consumer<UserDashboardProvider>(
              builder: (context, toolPro, _) {
                if (!toolPro.showRequestField) return const SizedBox();

                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Request this tool from admin",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: toolPro.requestToolController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Why do you need this tool?",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
//date picker use from end date user want to tools......................................
            SizeConFig.verticalBox(0.01),
            Consumer<UserDashboardProvider>(
              builder: (context, pro, _) {
                return buildSelectDateField(
                  label: "To-From",
                  controller: pro.dueDateController,
                  onTap: () {
                    pro.datePickForTools(
                      context: context,
                    );
                  },
                );
              },
            ),
            Consumer<UserDashboardProvider>(
              builder: (context, proTools, _) {
                final bool isRequestMode = proTools.showRequestField;

                return ElevatedButton(
                  onPressed: () {
                    if (isRequestMode) {
                      // ❌ Item NOT available → Request
                      if (proTools.requestToolController.text.trim().isEmpty) {
                        ShowTaostMessage.toastMessage(
                            context, "Please enter request details");

                        return;
                      }

                      // Send request to admin
                      print("REQUESTED TOOL: ${itemController.text}");
                      print("MESSAGE: ${proTools.requestToolController.text}");
                    } else {
                      // ✅ Item available → Normal submit
                      print("SUBMITTED TOOL: ${itemController.text}");
                    }

                    // Clear everything after action
                    proTools.clearToolsAndSelected();
                  },
                  child: Text(
                    isRequestMode ? "Request Tool" : "Submit",
                  ),
                );
              },
            ),
          ],
        ));
  }

  Widget buildSelectDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return TextField(
      readOnly: true,
      controller: controller,
      cursorColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.calendar_month_outlined,
            size: 24,
          ),
          onPressed: onTap,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget buildSelectField<T>({
    required TextEditingController controller,
    required String label,
    required List<T> items,
    required String Function(T item) itemLabel,
    IconData? leadingIcon,
    void Function(T selected)? onSelected,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      cursorColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: PopupMenuButton<T>(
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 28,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            controller.text = itemLabel(value);
            if (onSelected != null) {
              onSelected(value);
            }
          },
          itemBuilder: (context) {
            return items.map((item) {
              return PopupMenuItem<T>(
                value: item,
                child: Row(
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(leadingIcon, size: 18),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: Text(
                        itemLabel(item),
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
///code................................

//  Consumer<UserDashboardProvider>(
//               builder: (context, toolPro, _) {
//                 return buildSelectField<String>(
//                   controller: selectTypeController,
//                   label: "Select Tools Type",
//                   items: toolPro.libaryTools,
//                   itemLabel: (item) => item,
//                   leadingIcon: Icons.category,
//                   onSelected: (selectedType) {
//                     selectTypeController.text = selectedType;
//                     // selectItemController.cl();
//                     toolPro.selectToolType(selectedType);
//                   },
//                 );
//               },
//             ),
//             Consumer<UserDashboardProvider>(
//               builder: (context, toolPro, _) {
//                 if (toolPro.selectedToolType == null) {
//                   return const SizedBox();
//                 }

//                 if (toolPro.errorMessage != null) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8),
//                     child: Text(
//                       toolPro.errorMessage!,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   );
//                 }

//                 return Padding(
//                   padding: const EdgeInsets.only(top: 12),
//                   child: buildSelectField<String>(
//                     controller: selectItemController,
//                     label: "Select Item",
//                     items: toolPro.currentItemList,
//                     itemLabel: (item) => item,
//                     leadingIcon: Icons.build,
//                   ),
//                 );
//               },
//             ),