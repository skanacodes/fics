import 'dart:convert';
import 'dart:io';
import 'package:FIS/services/models/deadwoodmodel.dart';
import 'package:FIS/services/models/districtmodels.dart';
import 'package:FIS/services/models/forestmodels.dart';
import 'package:FIS/services/models/inventorymodels.dart';
import 'package:FIS/services/models/plotmodels.dart';
import 'package:FIS/services/models/speciesmodels.dart';
import 'package:FIS/services/models/treemodels.dart';
import 'package:FIS/services/models/usermodel.dart';

import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB();

    return _database;
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'FIS.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE Forest('
        'id INTEGER PRIMARY KEY,'
        'name TEXT'
        ')',
      );
      await db.execute(
        'CREATE TABLE Districts('
        'id INTEGER PRIMARY KEY,'
        'name TEXT'
        ')',
      );
      await db.execute(
        'CREATE TABLE Species('
        'id INTEGER PRIMARY KEY,'
        'scientific_name TEXT'
        ')',
      );
      await db.execute(
        'CREATE TABLE User('
        'id INTEGER PRIMARY KEY,'
        'first_name TEXT,'
        'last_name TEXT,'
        'email TEXT,'
        'password TEXT,'
        'role TEXT,'
        'statusfetch TEXT'
        ')',
      );
      await db.execute(
        'CREATE TABLE DeadWood('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'plot_id INTEGER,'
        'no_of_stems INTEGER,'
        'length TEXT,'
        'species_id INTEGER,'
        'diameter_one TEXT,'
        'diameter_two TEXT,'
        'decay TEXT,'
        'remarks TEXT,'
        'deadWoodNo TEXT,'
        'uploadStatus TEXT'
        ')',
      );
      await db.execute(
        'CREATE TABLE Tree('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'plot_id INTEGER,'
        'species_id INTEGER,'
        'stem_no INTEGER,'
        'tree_no INTEGER,'
        'dbh TEXT,'
        'height TEXT,'
        'bole_height TEXT,'
        'stump_diameter TEXT,'
        'stump_height TEXT,'
        'uploadStatus TEXT,'
        'is_alive TEXT,'
        'comments TEXT,'
        'tree_form TEXT'
        ')',
      );
      await db.execute(
        'CREATE TABLE InventoryJobs('
        'id INTEGER PRIMARY KEY,'
        'forest_id INTEGER,'
        'name TEXT,'
        'inventory_purpose TEXT,'
        'supervisor TEXT,'
        'title TEXT,'
        'sampling_method TEXT,'
        'number_of_plots INTEGER,'
        'start_date TEXT,'
        'end_date TEXT,'
        'created_at TEXT,'
        'updated_at TEXT,'
        'deleted_at TEXT,'
        'job_type TEXT,'
        'uploadStatus TEXT'
        ')',
      );
      await db.execute(
        'CREATE TABLE Plots('
        'temp_id TEXT PRIMARY KEY,'
        'job_id TEXT,'
        'plot_no TEXT,'
        'plot_area TEXT,'
        'eastings TEXT,'
        'northings TEXT,'
        'plot_size TEXT,'
        'slope TEXT,'
        'radius_correction TEXT,'
        'altitude TEXT,'
        'measurer TEXT,'
        'vegetation_type TEXT,'
        'inventory_date TEXT,'
        'district_id TEXT,'
        'comments TEXT,'
        'compartment_name TEXT,'
        'compartment_area TEXT,'
        'crew_leader TEXT,'
        'planted_year INTERGER,'
        'recorder_name TEXT,'
        'species_name TEXT,'
        'thinning_status TEXT,'
        'uploadStatus TEXT'
        ')',
      );
    });
  }

  // Insert Forest on database
  createForest(Forest newForest) async {
    //sawait deleteAllForest();

    final db = await database;
    return await db.transaction((txn) async {
      Batch batch = txn.batch();

      batch.insert('Forest', newForest.toJson());

      await batch.commit(noResult: true);
    });
  }

// Insert All Districts
  createDistricts(Districts newDistricts) async {
    //  await deleteAllDistricts();
    final db = await database;
    return await db.transaction((txn) async {
      Batch batch = txn.batch();
      // ignore: await_only_futures
      await batch.insert('Districts', newDistricts.toJson());

      await batch.commit(noResult: true);
    });
  }

// Insert All Inventory Jobs
  createInventoryJobs(Inventory newInventory) async {
    // await deleteAllInventory();
    final db = await database;
    final res = await db.insert('InventoryJobs', newInventory.toJson());

    return res;
  }

  createPlots(Plot newPlot) async {
    final db = await database;
    final res = await db.insert('Plots', newPlot.toJson());

    return res;
  }

//Insert a single plot
  Future<String> insertSinglePlot(Plot plot) async {
    // Get a reference to the database.
    final db = await database;
    try {
      await db.insert(
        'Plots',
        plot.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return 'Success';
    } catch (e) {
      print('error while inserting data');
      return 'failed';
    }
  }

  Future<String> insertSingleTree(TreeModel plot) async {
    // Get a reference to the database.
    final db = await database;
    try {
      await db.insert(
        'Tree',
        plot.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return 'Success';
    } catch (e) {
      print('error while inserting data');
      return 'failed';
    }
  }

  Future<String> insertSingleDeadWood(DeadWoodModel wood) async {
    // Get a reference to the database.
    final db = await database;
    try {
      await db.insert(
        'DeadWood',
        wood.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return 'Success';
    } catch (e) {
      print('error while inserting data');
      return 'failed';
    }
  }

  //Insert a user
  Future<String> insertUser(User user) async {
    // Get a reference to the database.
    final db = await database;
    try {
      await db.insert(
        'User',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return 'Success';
    } catch (e) {
      print('error while inserting data');
      return e;
    }
  }

  //Insert All Species
  createSpecies(Species newSpecies) async {
    //await deleteAllSpecies();
    final db = await database;
    return await db.transaction((txn) async {
      Batch batch = txn.batch();
      // ignore: await_only_futures
      await batch.insert('Species', newSpecies.toJson());

      await batch.commit(noResult: true);
    });
  }

  // Delete all employees
  deletePlot<String>(int id) async {
    try {
      final db = await database;
      final res = await db.rawDelete('DELETE FROM Plots WHERE id = ?', [id]);
      print(res);
      return 'Success';
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  // Delete all DeadWood
  deleteDeadWood<String>(int id) async {
    try {
      final db = await database;
      final res = await db.rawDelete('DELETE FROM DeadWood WHERE id = ?', [id]);
      print(res);
      return 'Success';
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  // Delete all employees
  deleteTree<String>(int id) async {
    try {
      final db = await database;
      final res = await db.rawDelete('DELETE FROM Tree WHERE id = ?', [id]);
      print(res);
      return 'Success';
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  // Delete all employees
  Future deleteAllForest() async {
    final db = await database;
    return await db.transaction((txn) async {
      Batch batch = txn.batch();
      // ignore: await_only_futures
      await batch.delete('Forest');

      await batch.commit(noResult: true);
    });
  }

  Future deleteAllDistricts() async {
    final db = await database;
    return await db.transaction((txn) async {
      Batch batch = txn.batch();
      // ignore: await_only_futures
      await batch.delete('Districts');

      await batch.commit(noResult: true);
    });
  }

  Future deleteAllSpecies() async {
    final db = await database;
    return await db.transaction((txn) async {
      Batch batch = txn.batch();
      // ignore: await_only_futures
      await batch.delete('Species');

      await batch.commit(noResult: true);
    });
  }

  Future deleteAllInventory() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM InventoryJobs');

    return res;
  }

// list Of All Inventory Jobs
  Future<List<Inventory>> getAllInventory() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM InventoryJobs");

    List<Inventory> list =
        res.isNotEmpty ? res.map((c) => Inventory.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<Plot>> getAllPlotsDetails() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Plots");

    List<Plot> list =
        res.isNotEmpty ? res.map((c) => Plot.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<TreeModel>> getAllTreesDetails() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Tree");

    List<TreeModel> list =
        res.isNotEmpty ? res.map((c) => TreeModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<void> updateStatusValue() async {
    // Get a reference to the database.
    final db = await database;
    int updateCount = await db.rawUpdate('''
    UPDATE User 
    SET statusfetch = ? 
    
    ''', [
      '1',
    ]);

    print('updated: ' + updateCount.toString());
    return;
  }

  //List of All Forest
  Future<List<Species>> getAllSpecies() async {
    final db = await database;
    final res = await db
        .rawQuery("SELECT DISTINCT * FROM Species ORDER BY scientific_name");

    List<Species> list =
        res.isNotEmpty ? res.map((c) => Species.fromJson(c)).toList() : [];

    return list;
  }

// list Of All Districts Jobs
  Future<List<Districts>> getAllDistricts() async {
    final db = await database;
    final res =
        await db.rawQuery("SELECT DISTINCT * FROM Districts ORDER BY name");

    List<Districts> list =
        res.isNotEmpty ? res.map((c) => Districts.fromJson(c)).toList() : [];

    return list;
  }

  Future<String> getstatusValue() async {
    final db = await database;
    final res = await db.rawQuery("SELECT statusfetch FROM User ");
    print(res);
    print(res[0]['statusfetch']);
    String value = res[0]['statusfetch'];
    return value;
  }

  //List Of All Trees
  Future<List<TreeModel>> getAllTrees(int id) async {
    final db = await database;

    final res = await db.query("Tree", where: "plot_id = ?", whereArgs: [id]);

    // print(res);

    List<TreeModel> list =
        res.isNotEmpty ? res.map((c) => TreeModel.fromJson(c)).toList() : [];
    print('printing List' + list.toString());
    return list;
  }

  Future<List> getAllTreeForPlot(int id) async {
    final db = await database;

    List res = await db.query("Tree", where: "plot_id = ?", whereArgs: [id]);
    print('list of tree......');
    print(res);

    // print('Mimi');

    return res;
  }

//List of All DeadWood
  Future<List<DeadWoodModel>> getAllDeadWood(int id) async {
    final db = await database;

    final res =
        await db.query("DeadWood", where: "plot_id = ?", whereArgs: [id]);

    print(res);

    List<DeadWoodModel> list = res.isNotEmpty
        ? res.map((c) => DeadWoodModel.fromJson(c)).toList()
        : [];
    print('printing List' + list.toString());
    return list;
  }

  // list Of All Forest
  Future<List<DeadWoodModel>> getAllDeadWoods() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM DeadWood ");
    print(res);
    List<DeadWoodModel> list = res.isNotEmpty
        ? res.map((c) => DeadWoodModel.fromJson(c)).toList()
        : [];
    print('.....');
    print(list);
    return list;
  }

  // list Of All Forest
  Future<List<Forest>> getAllForest() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Forest ORDER BY name");

    List<Forest> list =
        res.isNotEmpty ? res.map((c) => Forest.fromJson(c)).toList() : [];

    return list;
  }

// list Of All Plots
  Future<List<Plot>> getAllPlots(int id) async {
    final db = await database;
    print('Doing Query');
    final res = await db.query("Plots", where: "job_id = ?", whereArgs: [id]);

    print(res);

    List<Plot> list =
        res.isNotEmpty ? res.map((c) => Plot.fromJson(c)).toList() : [];
    print('printing List' + list.toString());
    List chckList = list.map((e) => json.encode(e.toJson())).toList();
    print('this is my List');
    print(chckList);
    print(list.toString());
    return list;
  }

  Future getAllPlotsToApi(int id) async {
    final db = await database;
    print('Doing Query');
    final res = await db.query("Plots", where: "job_id = ?", whereArgs: [id]);

    print(res);
    List<Plot> list =
        res.isNotEmpty ? res.map((c) => Plot.fromJson(c)).toList() : [];
    print('printing List' + list.toString());
    return list;
    //return res;
  }
}
