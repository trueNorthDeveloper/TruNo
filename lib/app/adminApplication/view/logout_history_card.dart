import 'package:flutter/material.dart';
import 'package:truenorthflutterfrontend/app/adminApplication/model/admin_logout_record.dart';

class LogoutHistoryCard extends StatefulWidget {
  const LogoutHistoryCard({super.key, required this.records});

  final List<AdminLogoutRecord> records;

  @override
  State<LogoutHistoryCard> createState() => _LogoutinHistoryCardState();
}

class _LogoutinHistoryCardState extends State<LogoutHistoryCard> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<AdminLogoutRecord> get _filtered => _query.isEmpty
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
          //size of full header
          final s = _Sizes.of(c.maxWidth);
          final rows = _filtered;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                //HEADER CLASS WIHH ARGUMENT
                _Header(s: s, total: widget.records.length),
                //SIZE BOX
                SizedBox(height: s.gap),
                //SEARCH BAR TOP OF BOX
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
                //IF NO TASK RECORD FOUND SHOW NO RECORD
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
          child: Icon(Icons.login_rounded, size: s.icon, color: Colors.blue),
        ),
        SizedBox(width: s.gap),
        Expanded(
          child: Text('Logout History',
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
       
      ],
    );
  }
}

// ---------- mobile: list ----------
class _RecordList extends StatelessWidget {
  const _RecordList({required this.rows, required this.s});
  final List<AdminLogoutRecord> rows;
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
                    _Sub(r.loginAddress, s.text - 2),
                    _Sub('${r.loginLatitude}, ${r.loginLongitude}', s.text - 2),
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
class _RecordTable extends StatefulWidget {
  const _RecordTable({required this.rows, required this.s});
  final List<AdminLogoutRecord> rows;
  final _Sizes s;

  @override
  State<_RecordTable> createState() => _RecordTableState();
}

class _RecordTableState extends State<_RecordTable> {
  // Own controller: the Scrollbar and the scroll view MUST share it.
  final _vertical = ScrollController();

  @override
  void dispose() {
    _vertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;

    return LayoutBuilder(
      builder: (context, c) => Scrollbar(
        controller: _vertical,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            //scrollDirection: Axis.horizontal,

            // table never overflows
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: c.maxWidth), // fill width
              child: DataTable(
                columnSpacing: s.gap * 2,
                headingRowHeight: 40,
                dataRowMinHeight: 44,
                dataRowMaxHeight: 54,
                headingTextStyle:
                    TextStyle(fontSize: s.text, fontWeight: FontWeight.bold),
                dataTextStyle:
                    TextStyle(fontSize: s.text, color: Colors.black87),
                columns: const [
                  DataColumn(label: Text('Employee')),
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text("Address")),
                  DataColumn(label: Text("LoginLongi")),
                  DataColumn(label: Text("LoginLat")),
                  DataColumn(label: Text("LogoutLongi")),
                  DataColumn(label: Text("LogoutLat")),
                  DataColumn(label: Text('logoutAddress'))
                ],
                rows: [
                  for (final r in widget.rows)
                    DataRow(cells: [
                      DataCell(
                          Text(r.empName, overflow: TextOverflow.ellipsis)),
                      DataCell(Text(r.empId)),
                      DataCell(_RoleChip(
                          role: r.role,
                          isLeader: r.isTeamLeader,
                          size: s.text - 1)),
                      DataCell(Text(r.loginDate)),
                      DataCell(Text(r.loginTime)),
                      DataCell(Text(r.loginAddress)),
                      DataCell(Text(r.loginLatitude)),
                      DataCell(Text(r.loginLongitude)),
                      DataCell(Text(r.logoutLongitude)),
                      DataCell(Text(r.logoutLatitude)),
                      DataCell(Text(r.logoutAddress))
                    ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
