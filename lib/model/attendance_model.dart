class Attendance {
  const Attendance({
    this.name,
    this.id,
    this.dayNum,
  });

  final String name;
  final String id;
  final String dayNum;
}

final List<Attendance> attendanceList = [
  Attendance(name: '张三', id: '01', dayNum: '2'),
  Attendance(name: '张三2', id: '02', dayNum: '20'),
  Attendance(name: '张三3', id: '03', dayNum: '21'),
];
