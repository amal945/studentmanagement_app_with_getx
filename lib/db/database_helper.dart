import 'package:final_project/model/student_model.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static const table = 'students';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';
  static const columnGender = 'gender';
  static const columnRollnumber = 'rollno';
  static const columnPicture = 'picture';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      'student.db',
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnAge INTEGER NOT NULL,
        $columnGender TEXT NOT NULL,
        $columnRollnumber INTEGER NOT NULL,
        $columnPicture TEXT NOT NULL
      )''');
  }

  Future<int> insertStudents(Student student) async {
    final db = await database;
    return await db.insert(table, {
      columnName: student.name,
      columnAge: student.age,
      columnGender: student.gender,
      columnRollnumber: student.rollnumber,
      columnPicture: student.picture
    });
  }

  Future<List<Student>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(
        maps.length,
        (index) => Student(
            id: maps[index][columnId],
            name: maps[index][columnName],
            age: maps[index][columnAge],
            gender: maps[index][columnGender],
            rollnumber: maps[index][columnRollnumber],
            picture: maps[index][columnPicture]));
  }

  Future<int> updateStudent(Student student) async {
    final db = await database;
    return await db.update(
      table,
      {
        columnName: student.name,
        columnAge: student.age,
        columnGender: student.gender,
        columnRollnumber: student.rollnumber,
        columnPicture: student.picture
      },
      where: '$columnId = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await database;
    return await db.delete(table, where: '$columnId = ?',
     whereArgs: [id]);
  }
}
