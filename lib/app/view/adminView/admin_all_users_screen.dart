import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/model/adminModel/admin_registration_for_user_account_model.dart';

class AdminAllUsers extends StatefulWidget {
  @override
  _AdminAllUsersState createState() => _AdminAllUsersState();
}

class _AdminAllUsersState extends State<AdminAllUsers> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  //late Future<List<User>> _user;

  List<UserRegistration> user = [
    UserRegistration(
      uuid: 1,
      empId: 'EMP001',
      empName: 'Alice Smith',
      empDob: DateTime(1990, 5, 10),
      empEmail: 'alice@example.com',
      joinDate: DateTime(2020, 1, 1),
      empDesignation: 'Developer',
      empSystemName: 'PC-101',
      empSystemType: 'Laptop',
      empWorkingType: 'Remote',
      empCl: 5,
      empMl: 3,
      empPassword: 'pass123',
      empMobile: '1234567890',
      empWorkingLocation: 'Office',
      createdDate: DateTime(2021, 1, 1),
      role: 'Admin',
      curcl: 2,
      cuml: 1,
      curlwp: 0,
      nextcl: 3,
      nextml: 2,
      userInterface: 'Web',
      workStatus: 'Active',
    ),
    UserRegistration(
      uuid: 1,
      empId: 'EMP001',
      empName: 'Alice Smith',
      empDob: DateTime(1990, 5, 10),
      empEmail: 'alice@example.com',
      joinDate: DateTime(2020, 1, 1),
      empDesignation: 'Developer',
      empSystemName: 'PC-101',
      empSystemType: 'Laptop',
      empWorkingType: 'Remote',
      empCl: 5,
      empMl: 3,
      empPassword: 'pass123',
      empMobile: '1234567890',
      empWorkingLocation: 'Office',
      createdDate: DateTime(2021, 1, 1),
      role: 'Admin',
      curcl: 2,
      cuml: 1,
      curlwp: 0,
      nextcl: 3,
      nextml: 2,
      userInterface: 'Web',
      workStatus: 'Active',
    ),
    UserRegistration(
      uuid: 1,
      empId: 'EMP001',
      empName: 'Alice Smith',
      empDob: DateTime(1990, 5, 10),
      empEmail: 'alice@example.com',
      joinDate: DateTime(2020, 1, 1),
      empDesignation: 'Developer',
      empSystemName: 'PC-101',
      empSystemType: 'Laptop',
      empWorkingType: 'Remote',
      empCl: 5,
      empMl: 3,
      empPassword: 'pass123',
      empMobile: '1234567890',
      empWorkingLocation: 'Office',
      createdDate: DateTime(2021, 1, 1),
      role: 'Admin',
      curcl: 2,
      cuml: 1,
      curlwp: 0,
      nextcl: 3,
      nextml: 2,
      userInterface: 'Web',
      workStatus: 'Active',
    ),
    UserRegistration(
      uuid: 1,
      empId: 'EMP001',
      empName: 'Alice Smith',
      empDob: DateTime(1990, 5, 10),
      empEmail: 'alice@example.com',
      joinDate: DateTime(2020, 1, 1),
      empDesignation: 'Developer',
      empSystemName: 'PC-101',
      empSystemType: 'Laptop',
      empWorkingType: 'Remote',
      empCl: 5,
      empMl: 3,
      empPassword: 'pass123',
      empMobile: '1234567890',
      empWorkingLocation: 'Office',
      createdDate: DateTime(2021, 1, 1),
      role: 'Admin',
      curcl: 2,
      cuml: 1,
      curlwp: 0,
      nextcl: 3,
      nextml: 2,
      userInterface: 'Web',
      workStatus: 'Active',
    ),
    UserRegistration(
      uuid: 1,
      empId: 'EMP001',
      empName: 'Alice Smith',
      empDob: DateTime(1990, 5, 10),
      empEmail: 'alice@example.com',
      joinDate: DateTime(2020, 1, 1),
      empDesignation: 'Developer',
      empSystemName: 'PC-101',
      empSystemType: 'Laptop',
      empWorkingType: 'Remote',
      empCl: 5,
      empMl: 3,
      empPassword: 'pass123',
      empMobile: '1234567890',
      empWorkingLocation: 'Office',
      createdDate: DateTime(2021, 1, 1),
      role: 'Admin',
      curcl: 2,
      cuml: 1,
      curlwp: 0,
      nextcl: 3,
      nextml: 2,
      userInterface: 'Web',
      workStatus: 'Active',
    ),
    UserRegistration(
      uuid: 1,
      empId: 'EMP001',
      empName: 'Alice Smith',
      empDob: DateTime(1990, 5, 10),
      empEmail: 'alice@example.com',
      joinDate: DateTime(2020, 1, 1),
      empDesignation: 'Developer',
      empSystemName: 'PC-101',
      empSystemType: 'Laptop',
      empWorkingType: 'Remote',
      empCl: 5,
      empMl: 3,
      empPassword: 'pass123',
      empMobile: '1234567890',
      empWorkingLocation: 'Office',
      createdDate: DateTime(2021, 1, 1),
      role: 'Admin',
      curcl: 2,
      cuml: 1,
      curlwp: 0,
      nextcl: 3,
      nextml: 2,
      userInterface: 'Web',
      workStatus: 'Active',
    ),
    UserRegistration(
      uuid: 1,
      empId: 'EMP001',
      empName: 'Alice Smith',
      empDob: DateTime(1990, 5, 10),
      empEmail: 'alice@example.com',
      joinDate: DateTime(2020, 1, 1),
      empDesignation: 'Developer',
      empSystemName: 'PC-101',
      empSystemType: 'Laptop',
      empWorkingType: 'Remote',
      empCl: 5,
      empMl: 3,
      empPassword: 'pass123',
      empMobile: '1234567890',
      empWorkingLocation: 'Office',
      createdDate: DateTime(2021, 1, 1),
      role: 'Admin',
      curcl: 2,
      cuml: 1,
      curlwp: 0,
      nextcl: 3,
      nextml: 2,
      userInterface: 'Web',
      workStatus: 'Active',
    ),
  ];

  void _deleteEmployee(int index) {
    setState(() {
      user.removeAt(index);
    });
  }

  void _editEmployee(int index) {
   // final emp = user[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Employee'),
        content: Text('You selected to edit: ${"name"}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    ///here its mt all user.................................
    //final myProvider = Provider.of<AdminDashboardProvider>(context, listen: false);
    //  myProvider.allUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        controller: _verticalController,
        thumbVisibility: true,
        child: SingleChildScrollView(
            controller: _verticalController,
            scrollDirection: Axis.vertical,
            child: Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                    controller: _horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 800),
                            child: DataTable(
                              columnSpacing: 20,
                              columns: const [
                                DataColumn(label: Text("Uuid")),
                                DataColumn(label: Text("EmpId")),
                                DataColumn(label: Text("EmpName")),
                                DataColumn(label: Text("EmpDob")),
                                DataColumn(label: Text("EmpEmail")),
                                DataColumn(label: Text("JoinDate")),
                                DataColumn(label: Text("EmpDesignation")),
                                DataColumn(label: Text("EmpSystemName")),
                                DataColumn(label: Text("EmpSystemType")),
                                DataColumn(label: Text("EmpWorkingType")),
                                DataColumn(label: Text("EmpCl")),
                                DataColumn(label: Text("EmpMl")),
                                DataColumn(label: Text("EmpPassword")),
                                DataColumn(label: Text("EmpMobile")),
                                DataColumn(label: Text("EmpWorkingLocation")),
                                DataColumn(label: Text("CreatedDate")),
                                DataColumn(label: Text("Role")),
                                DataColumn(label: Text("Curcl")),
                                DataColumn(label: Text("Cuml")),
                                DataColumn(label: Text("Curlwp")),
                                DataColumn(label: Text("Nextcl")),
                                DataColumn(label: Text("Nextml")),
                                DataColumn(label: Text("UserInterface")),
                                DataColumn(label: Text("WorkStatus")),
                                DataColumn(label: Text("Action")),
                              ],
                              rows: user.map((e) {
                                return DataRow(cells: [
                                  DataCell(Text(e.uuid.toString())),
                                  DataCell(Text(e.empId)),
                                  DataCell(Text(e.empName)),
                                  DataCell(Text(e.empDob != null
                                      ? e.empDob!
                                          .toIso8601String()
                                          .split('T')
                                          .first
                                      : '')),
                                  DataCell(Text(e.empEmail ?? '')),
                                  DataCell(Text(e.joinDate != null
                                      ? e.joinDate!
                                          .toIso8601String()
                                          .split('T')
                                          .first
                                      : '')),
                                  DataCell(Text(e.empDesignation ?? '')),
                                  DataCell(Text(e.empSystemName ?? '')),
                                  DataCell(Text(e.empSystemType ?? '')),
                                  DataCell(Text(e.empWorkingType ?? '')),
                                  DataCell(Text(e.empCl.toString())),
                                  DataCell(Text(e.empMl.toString())),
                                  DataCell(Text(e.empPassword ?? '')),
                                  DataCell(Text(e.empMobile ?? '')),
                                  DataCell(Text(e.empWorkingLocation ?? '')),
                                  DataCell(Text(e.createdDate != null
                                      ? e.createdDate!
                                          .toIso8601String()
                                          .split('T')
                                          .first
                                      : '')),
                                  DataCell(Text(e.role ?? '')),
                                  DataCell(Text(e.curcl.toString())),
                                  DataCell(Text(e.cuml.toString())),
                                  DataCell(Text(e.curlwp.toString())),
                                  DataCell(Text(e.nextcl.toString())),
                                  DataCell(Text(e.nextml.toString())),
                                  DataCell(Text(e.userInterface ?? '')),
                                  DataCell(Text(e.workStatus ?? '')),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => _editEmployee(1),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _deleteEmployee(1),
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            )))))));
  }
}
