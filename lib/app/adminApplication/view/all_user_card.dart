import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_all_employee.dart';

class AllUserCard extends StatefulWidget {
  const AllUserCard({super.key, required this.users});
  final List<Employee> users;
  @override
  State<AllUserCard> createState() => _AllUserContentState();
}

class _AllUserContentState extends State<AllUserCard> {
  final _search = TextEditingController();
  String _query = '';

  List<Employee> get _filtered => _query.isEmpty
      ? widget.users
      : widget.users.where((r) => r.matches(_query)).toList();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // One Card only (original had two nested boxes with double shadows)
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: LayoutBuilder(
        builder: (context, c) {
          final s = _Sizes.of(c.maxWidth);
          final rows = _filtered;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _Header(s: s, total: widget.users.length),
                SizedBox(height: s.gap),
                //search bar with filtering data............
                // SizedBox(
                //   height: s.compact ? 36 : 40,
                //   child: TextField(
                //     controller: _search,
                //     onChanged: (v) => setState(() => _query = v.trim()),
                //     style: TextStyle(fontSize: s.text),
                //     decoration: InputDecoration(
                //       hintText:
                //           s.compact ? 'Search' : 'Search employee, ID or role',
                //       hintStyle: TextStyle(fontSize: s.text),
                //       prefixIcon: Icon(Icons.search, size: s.compact ? 16 : 20),
                //       contentPadding: EdgeInsets.zero,
                //       filled: true,
                //       fillColor: const Color(0xffF5F7FB),
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8),
                //         borderSide: BorderSide.none,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: s.compact ? 36 : 40,

                  //color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: s.compact ? 200 : 180,
                        child: TextField(
                          controller: _search,
                          onChanged: (v) => setState(() => _query = v.trim()),
                          style: TextStyle(fontSize: s.text),
                          decoration: InputDecoration(
                            hintText: s.compact
                                ? 'Search'
                                : 'Search employee, ID or role',
                            hintStyle: TextStyle(fontSize: s.text),
                            prefixIcon:
                                Icon(Icons.search, size: s.compact ? 16 : 20),
                            contentPadding: EdgeInsets.zero,
                            filled: true,
                            fillColor: const Color(0xffF5F7FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              //borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          child: TextButton.icon(
                              icon: Icon(
                                Icons.add,
                                size: s.compact ? 16 : 20,
                              ),
                              onPressed: () {},
                              label: Text("Add User")))
                      // TextField(
                      //   controller: _search,
                      //   onChanged: (v) => setState(() => _query = v.trim()),
                      //   style: TextStyle(fontSize: s.text),
                      //   decoration: InputDecoration(
                      //     hintText:
                      //         s.compact ? 'Search' : 'Search employee, ID or role',
                      //     hintStyle: TextStyle(fontSize: s.text),
                      //     prefixIcon: Icon(Icons.search, size: s.compact ? 2 : 3),
                      //     contentPadding: EdgeInsets.zero,
                      //     filled: true,
                      //     fillColor: const Color(0xffF5F7FB),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //       borderSide: BorderSide.none,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: s.gap),
                Expanded(
                  child: rows.isEmpty
                      ? Center(
                          child: Text('No users records',
                              style: TextStyle(
                                  fontSize: s.text, color: Colors.grey)),
                        )
                      : s.compact
                          ? _RecordList(rows: rows, s: s)
                          : _RecordTable(rows: rows, s: s),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------- responsive sizes in one place ----------
class _Sizes {
  const _Sizes(
      this.compact, this.title, this.text, this.icon, this.avatar, this.gap);

  final bool compact;
  final double title, text, icon, avatar, gap;

  factory _Sizes.of(double w) {
    if (w < 500) return const _Sizes(true, 14, 11, 20, 16, 6);
    if (w < 900) return const _Sizes(false, 16, 12, 24, 19, 10);
    return const _Sizes(false, 18, 13, 28, 22, 14);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.s, required this.total});
  final _Sizes s;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(s.compact ? 6 : 8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.person, size: s.icon, color: Colors.blue),
        ),
        SizedBox(width: s.gap),
        Expanded(
          child: Text('user managements',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: s.title, fontWeight: FontWeight.bold)),
        ),
        Container(
          padding:
              EdgeInsets.symmetric(horizontal: s.compact ? 6 : 9, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('$total',
              style: TextStyle(
                  fontSize: s.text,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
        ),
        SizedBox(width: s.gap),
      ],
    );
  }
}

// ---------- mobile: list ----------
class _RecordList extends StatelessWidget {
  const _RecordList({required this.rows, required this.s});
  final List<Employee> rows;
  final _Sizes s;

  @override
  Widget build(BuildContext context) {
    // NO `primary: true` — the parent GridView already owns the primary
    // controller; two primaries cause scroll-controller errors on web.
    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (_, i) {
        final r = rows[i];
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xffF8FAFC),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: s.avatar,
                backgroundColor: Colors.blue.shade50,
                child: Text(
                  r.empName!.isEmpty ? '?' : r.empName![0].toUpperCase(),
                  style: TextStyle(
                      fontSize: s.text,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              SizedBox(width: s.gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.empName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: s.text, fontWeight: FontWeight.w600)),
                    _Sub(r.empId!, s.text - 1),
                    _Sub(r.empWorkingLocation!, s.text - 2),
                    _Sub('${r.empMobile}, ${r.empEmail}', s.text - 2),
                  ],
                ),
              ),
              _RoleChip(role: r.role!, isLeader: true, size: s.text - 1),
            ],
          ),
        );
      },
    );
  }
}

class _Sub extends StatelessWidget {
  const _Sub(this.text, this.size);
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) => Text(text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: size, color: Colors.grey));
}

class _RoleChip extends StatelessWidget {
  const _RoleChip(
      {required this.role, required this.isLeader, required this.size});
  final String role;
  final bool isLeader;
  final double size;

  @override
  Widget build(BuildContext context) {
    final base = isLeader ? Colors.orange : Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: base.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(role,
          style: TextStyle(
              fontSize: size, fontWeight: FontWeight.bold, color: base)),
    );
  }
}

class _RecordTable extends StatefulWidget {
  const _RecordTable({required this.rows, required this.s});
  final List<Employee> rows;
  final _Sizes s;

  @override
  State<_RecordTable> createState() => _RecordTableState();
}

class _RecordTableState extends State<_RecordTable> {
  // Own controller: the Scrollbar and the scroll view MUST share it.
  final _vertical = ScrollController();
  final _horizontal = ScrollController();

  static const _cols = <(String, double)>[
    ('Emp ID', 160),
    ('Name', 100),
    ('DOB', 110),
    ('Email', 220),
    ('Join Date', 110),
    ('Designation', 140),
    ('System Name', 140),
    ('System Type', 120),
    ('Working Type', 120),
    ('CL', 80),
    ('ML', 80),
    ('Password', 120),
    ('Mobile', 130),
    ('Location', 160),
    ('Created Date', 130),
    ('Role', 120),
    ('Cur CL', 90),
    ('Cur ML', 90),
    ('Cur LWP', 100),
    ('Next CL', 90),
    ('Next ML', 90),
    ('UI Status', 110),
    ('Work Status', 120),
    ("Action", 120)
  ];
  @override
  void dispose() {
    _vertical.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;

    final baseWidth = _cols.fold<double>(0, (sum, c) => sum + c.$2);
    return LayoutBuilder(builder: (context, c) {
      final tableWidth = baseWidth > c.maxWidth ? baseWidth : c.maxWidth;
      final scale = tableWidth / baseWidth;
      double w(int i) => _cols[i].$2 * scale;

      return Scrollbar(
          controller: _horizontal,
          thumbVisibility: true,
          notificationPredicate: (n) => n.depth == 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horizontal,
            // table never overflows
            child: SizedBox(
                width: tableWidth,
                child: Column(children: [
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 128, 176, 223),
                      border: const Border(
                        top: BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Color(0xFFDDE3EA),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        for (int i = 0; i < _cols.length; i++)
                          _cell(
                            w(i),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: const Color(0xFFE5E7EB),
                                    width: i == _cols.length - 1 ? 0 : 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                _cols[i].$1,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: s.text,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF374151),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                      child: Scrollbar(
                          child: ListView.separated(
                              itemBuilder: (_, index) {
                                final r = widget.rows[index];
                                final style = TextStyle(
                                    fontSize: s.text, color: Colors.black87);
                                return SizedBox(
                                  height: 48,
                                  child: Row(
                                    children: [
                                      //  _cell(w(0),Text(r.empName!,style: style,maxLines: 1,overflow: TextOverflow.ellipsis,))

                                      CircleAvatar(
                                        radius: s.avatar,
                                        backgroundColor: Colors.blue.shade50,
                                        child: Text(
                                          r.empName!.isEmpty
                                              ? '?'
                                              : r.empName![0].toUpperCase(),
                                          style: TextStyle(
                                              fontSize: s.text,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                      ),
                                      _cell(
                                          w(0),
                                          Text(r.empId ?? '',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(1),
                                          Text(r.empName!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(2),
                                          Text(r.empDob!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(3),
                                          Text(r.empEmail!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(4),
                                          Text(r.joinDate!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(5),
                                          Text(r.empDesignation!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(6),
                                          Text(r.empSystemName!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(7),
                                          Text(r.empSystemType!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(8),
                                          Text(r.workStatus!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(9),
                                          Text('${r.empCl!}',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(10),
                                          Text('${r.empMl!}',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(11),
                                          Text(r.empPassword!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(12),
                                          Text(r.empMobile!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(13),
                                          Text(r.empWorkingLocation!,
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(14),
                                          Text(r.createdDate ?? '',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),

                                      _RoleChip(
                                          role: r.role!,
                                          isLeader: true,
                                          size: s.text - 1),

                                      // _cell(
                                      //     w(15),
                                      //     Text(r.role ?? '',
                                      //         style: style,
                                      //         maxLines: 1,
                                      //         overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(16),
                                          Text('${r.curcl ?? ''}',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(17),
                                          Text('${r.cuml ?? ''}',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(18),
                                          Text('${r.curlwp ?? ''}',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(19),
                                          Text('${r.nextcl ?? '1'}',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(20),
                                          Text('${r.nextml ?? '3'}',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(21),
                                          Text(r.userInterface ?? 'Civil',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      _cell(
                                          w(22),
                                          Text(r.workStatus ?? 'Present',
                                              style: style,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis)),
                                      SizedBox(
                                          child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.delete))
                                        ],
                                      ))
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) => const Divider(
                                    height: 1,
                                  ),
                              itemCount: widget.rows.length))),
                ])),
          ));
    });
  }

  Widget _cell(double width, Widget child) => SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(alignment: Alignment.centerLeft, child: child),
        ),
      );
}
