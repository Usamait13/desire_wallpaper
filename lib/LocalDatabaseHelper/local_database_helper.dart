import 'dart:io';

import 'package:desire_wallpaper/ApplicationModules/Models/category_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseHepler {
  static Database? _database;
  static String DBNAME = "db_desire";

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database!;
    // If database don't exists, create one
    _database = await initLocalDatabase();
    return _database!;
  }

  Future<bool> databaseExists() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DBNAME);
    return databaseFactory.databaseExists(path);
  }

  // Create the database and the Employee table
  initLocalDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DBNAME);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE tbl_user('
          'user_id INTEGER PRIMARY KEY,'
          'user_name Text,'
          'user_email Text'
          'user_phone Text'
          'user_image Text'
          ')');
      await db.execute('CREATE TABLE tbl_category('
          'category_id INTEGER PRIMARY KEY,'
          'category_name Text,'
          'category_image Text'
          ')');
      await db.execute('CREATE TABLE tbl_wallpaper('
          'wallpaper_id INTEGER PRIMARY KEY,'
          'category Text,'
          'wallpaper_image Text'
          ')');
    });
  }

  insertCategory({required CategoryModel categoryModel}) async {
    final db = await database;

    final res = await db.insert('tbl_category', {
      // 'category_id': categoryModel.category_id,
      'category_name': categoryModel.category_name,
      'category_image': categoryModel.category_image,
    });
    print(res.runtimeType);
    return res;
  }
  insertCategoryList(List<CategoryModel> category) {
    for (int i = 0; i < category.length; i++) {
      insertCategory(
        categoryModel: category[i],
      );
    }
  }

  Future<List<CategoryModel>> fetchCategoryFromLocal() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM tbl_category");
    return CategoryModel.localToListView(res);
  }

  deleteAllCategories() async {
    final db = await database;
    final res = await db.rawQuery("DELETE FROM tbl_category");
  }

  checkDataExistenceByLength( String table) async {
    final db = await database;
    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM ${table}'))!;
    return count;
  }
}
