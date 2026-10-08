import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_login_record.dart';

class LoginHistoryCard extends StatefulWidget {
  const LoginHistoryCard({super.key, required this.records});

  final List<AdminLoginRecord> records;

  @override
  State<LoginHistoryCard> createState() => _LoginHistoryCardState();
}

class _LoginHistoryCardState extends State<LoginHistoryCard> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<AdminLoginRecord> get _filtered => _query.isEmpty
      ? widget.records
      : widget.records.where((r) => r.matches(_query)).toList();

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
                //top header name with icons
                _Header(s: s, total: widget.records.length),

                SizedBox(height: s.gap),
                //search bar.......................................
                SizedBox(
                  height: s.compact ? 36 : 40,
                  child: TextField(
                    controller: _search,
                    onChanged: (v) => setState(() => _query = v.trim()),
                    style: TextStyle(fontSize: s.text),
                    decoration: InputDecoration(
                      hintText:
                          s.compact ? 'Search' : 'Search employee, ID or role',
                      hintStyle: TextStyle(fontSize: s.text),
                      prefixIcon: Icon(Icons.search, size: s.compact ? 16 : 20),
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: const Color(0xffF5F7FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: s.gap),
                //show list....
                Expanded(
                  child: rows.isEmpty
                      ? Center(
                          child: Text('No login records',
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
          child: Text('Login History',
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
                  fontSize: 20,
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
  final List<AdminLoginRecord> rows;
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
                  r.empName.isEmpty ? '?' : r.empName[0].toUpperCase(),
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
                    Text(r.empName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: s.text, fontWeight: FontWeight.w600)),
                    _Sub(r.empId, s.text - 1),
                    _Sub(r.address, s.text - 2),
                    _Sub('${r.latitude}, ${r.longitude}', s.text - 2),
                  ],
                ),
              ),
              _RoleChip(
                  role: r.role, isLeader: r.isTeamLeader, size: s.text - 1),
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

// ---------- tablet/web: table ----------
// class _RecordTable extends StatefulWidget {
//   const _RecordTable({required this.rows, required this.s});
//   final List<AdminLoginRecord> rows;
//   final _Sizes s;

//   @override
//   State<_RecordTable> createState() => _RecordTableState();
// }

// class _RecordTableState extends State<_RecordTable> {
//   // Own controller: the Scrollbar and the scroll view MUST share it.
//   final _vertical = ScrollController();

//   @override
//   void dispose() {
//     _vertical.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final s = widget.s;

//     return LayoutBuilder(
//       builder: (context, c) => Scrollbar(
//         controller: _vertical,
//         thumbVisibility: true,
//         child: SingleChildScrollView(
//           controller: _vertical,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal, // table never overflows
//             child: ConstrainedBox(
//               constraints: BoxConstraints(minWidth: c.maxWidth), // fill width
//               child: DataTable(
//                 columnSpacing: s.gap * 2,
//                 headingRowHeight: 40,
//                 dataRowMinHeight: 44,
//                 dataRowMaxHeight: 54,
//                 headingTextStyle:
//                     TextStyle(fontSize: s.text, fontWeight: FontWeight.bold),
//                 dataTextStyle:
//                     TextStyle(fontSize: s.text, color: Colors.black87),
//                 columns: const [
//                   DataColumn(label: Text('Employee')),
//                   DataColumn(label: Text('ID')),
//                   DataColumn(label: Text('Role')),
//                   DataColumn(label: Text('Date')),
//                   DataColumn(label: Text('Time')),
//                   DataColumn(label: Text("Address")),
//                   DataColumn(label: Text("Longitude")),
//                   DataColumn(label: Text("Latitude"))
//                 ],
//                 rows: [
//                   for (final r in widget.rows)
//                     DataRow(cells: [
//                       DataCell(
//                           Text(r.empName, overflow: TextOverflow.ellipsis)),
//                       DataCell(Text(r.empId)),
//                       DataCell(_RoleChip(
//                           role: r.role,
//                           isLeader: r.isTeamLeader,
//                           size: s.text - 1)),
//                       DataCell(Text(r.loginDate)),
//                       DataCell(Text(r.loginTime)),
//                       DataCell(Text(r.address)),
//                       DataCell(Text(r.longitude)),
//                       DataCell(Text(r.latitude))
//                     ]),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// ---------- tablet/web: table with FIXED header ----------
class _RecordTable extends StatefulWidget {
  const _RecordTable({required this.rows, required this.s});
  final List<AdminLoginRecord> rows;
  final _Sizes s;

  @override
  State<_RecordTable> createState() => _RecordTableState();
}

class _RecordTableState extends State<_RecordTable> {
  final _vertical = ScrollController();
  final _horizontal = ScrollController();

  // column name + base width
  static const _cols = <(String, double)>[
    ('Employee', 160),
    ('ID', 100),
    ('Role', 120),
    ('Date', 110),
    ('Time', 90),
    ('Address', 260),
    ('Longitude', 110),
    ('Latitude', 110),
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

    return LayoutBuilder(
      builder: (context, c) {
        final tableWidth = baseWidth > c.maxWidth ? baseWidth : c.maxWidth;
        final scale = tableWidth / baseWidth;
        double w(int i) => _cols[i].$2 * scale;

        return Scrollbar(
          controller: _horizontal,
          thumbVisibility: true,
          notificationPredicate: (n) => n.depth == 0,
          child: SingleChildScrollView(
            controller: _horizontal,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Column(
                children: [
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

                  // ---------- only ROWS scroll vertically ----------
                  Expanded(
                    child: Scrollbar(
                      controller: _vertical,
                      thumbVisibility: true,
                      child: ListView.separated(
                        controller: _vertical,
                        itemCount: widget.rows.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, index) {
                          final r = widget.rows[index];
                          final style = TextStyle(
                              fontSize: s.text, color: Colors.black87);
                          return SizedBox(
                            height: 48,
                            child: Row(
                              children: [
                                _cell(
                                    w(0),
                                    Text(r.empName,
                                        style: style,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                                _cell(
                                    w(1),
                                    Text(r.empId,
                                        style: style,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                                _cell(
                                  w(2),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: _RoleChip(
                                        role: r.role,
                                        isLeader: r.isTeamLeader,
                                        size: s.text - 1),
                                  ),
                                ),
                                _cell(w(3), Text(r.loginDate, style: style)),
                                _cell(w(4), Text(r.loginTime, style: style)),
                                _cell(
                                    w(5),
                                    Text(r.address,
                                        style: style,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis)),
                                _cell(w(6), Text(r.longitude, style: style)),
                                _cell(w(7), Text(r.latitude, style: style)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cell(double width, Widget child) => SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(alignment: Alignment.centerLeft, child: child),
        ),
      );
}

class DataColumnclass extends StatelessWidget {
  // 1. Made the list 'final' since it belongs to an immutable StatelessWidget
  final List<String> columnsList = const [
    'Employee',
    'ID',
    'Role'
        'Date',
    'Time',
    'Address',
    'Longitude',
    'Latitude',
  ];

  // 2. Added a standard missing constructor
  const DataColumnclass({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // 3. Spreads items evenly across the horizontal row space
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        for (int i = 0; i < columnsList.length; i++)
          // 4. Wrapped in Expanded to prevent text from overflowing off the screen
          Expanded(
            child: Text(
              columnsList[i],
              textAlign:
                  TextAlign.center, // Centers text within its allotted slot
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
