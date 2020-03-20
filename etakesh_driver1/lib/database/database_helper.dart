import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/services.dart';

class DatabaseHelper {
  static final _databaseName = "driver_etakesh.db";
  static final _databaseVersion = 2;

  static final TABLE_PRESTA = 'prestataires';
  static final TABLE_EPOSITION = 'eposition';
  static final TABLE_SERVICES = 'services';
  static final TABLE_VEHICULES = 'vehicules';
  static final TABLE_PRESTIONS = 'prestations';
  static final TABLE_CMDE = 'commandes';
  static final TABLE_COMPTES = 'ecomptes';
  

  static final COLUMN_PRESTA_ID = 'prestataireid';
  static final COLUMN_PRESTA_CNI = 'cni';
  static final COLUMN_PRESTA_DATE_CREATION = 'date_creation';
  static final COLUMN_PRESTA_DATE_NAISSANCE = 'date_naissance';
  static final COLUMN_PRESTA_EMAIL = 'email';
  static final COLUMN_PRESTA_NOM = 'nom';
  static final COLUMN_PRESTA_PAYS = 'pays';
  static final COLUMN_PRESTA_PRENOM = 'prenom';
  static final COLUMN_PRESTA_STATUS = 'status';
  static final COLUMN_PRESTA_TELEPHONE = 'telephone';
  static final COLUMN_PRESTA_VILLE = 'ville';
  static final COLUMN_PRESTA_POSITION_ID = 'position_id';
  static final COLUMN_PRESTA_USER_ID = 'user_id';
  static final COLUMN_PRESTA_TOKEN = 'token';
  static final COLUMN_PRESTA_TTL = 'ttl';
  static final COLUMN_PRESTA_CODE = 'code';
  static final COLUMN_PRESTA_IMAGE = 'image';
  static final COLUMN_PRESTA_ETAT = 'etat';

  static final COLUMN_POSITION_ID = 'positionid';
  static final COLUMN_POSITION_LAT = 'latitude';
  static final COLUMN_POSITION_LNG = 'longitude';
  static final COLUMN_POSITION_LIBELLE = 'libelle';

  static final COLUMN_SERV_ID = 'serviceid';
  static final COLUMN_SERV_CODE = 'code';
  static final COLUMN_SERV_DUREE = 'duree';
  static final COLUMN_SERV_INTITULE = 'intitule';
  static final COLUMN_SERV_PRIX = 'prix';
  static final COLUMN_SERV_PRIXDLA = 'prix_douala';
  static final COLUMN_SERV_PRIXYDE = 'prix_yaounde';
  static final COLUMN_SERV_STATUS = 'status';
  static final COLUMN_SERV_DATECREATION = 'date_creation';

  static final COLUMN_VEHI_ID = 'vehiculeid';
  static final COLUMN_VEHI_COULEUR = 'couleur';
  static final COLUMN_VEHI_STATUS = 'status';
  static final COLUMN_VEHI_IMMATRICULATION = 'immatriculation';
  static final COLUMN_VEHI_MARQUE = 'marque';
  static final COLUMN_VEHI_NOMBREPLACES = 'nombre_places';
  static final COLUMN_VEHI_DATE = 'date';
  static final COLUMN_VEHI_IMAGE = 'image';
  static final COLUMN_VEHI_CODE = 'code';
  static final COLUMN_VEHI_CATEGORIEVEHICILEID = 'categorievehiculeId';
  static final COLUMN_VEHI_PRESTATAIREID = 'prestataireId';

  static final COLUMN_PRESTION_ID = 'prestationid';
  static final COLUMN_PRESTION_DATE = 'date';
  static final COLUMN_PRESTION_STATUS = 'status';
  static final COLUMN_PRESTION_MONTANT = 'montant';
  static final COLUMN_PRESTION_VEHICULEID = 'vehiculeId';
  static final COLUMN_PRESTION_PRESTATAIREID = 'prestataireId';
  static final COLUMN_PRESTION_SERVICEID = 'serviceId';

  static final COLUMN_CMD_ID = 'commandeid';
  static final COLUMN_CMD_CODE = 'code';
  static final COLUMN_CMD_DATE = 'date';
  static final COLUMN_CMD_DATEDEBUT = 'date_debut';
  static final COLUMN_CMD_DATEFIN = 'date_fin';
  static final COLUMN_CMD_MONTANT = 'montant';
  static final COLUMN_CMD_STATUS = 'status';
  static final COLUMN_CMD_DISTANCE = 'distance_client_prestataire';
  static final COLUMN_CMD_DUREE = 'duree_client_prestataire';
  static final COLUMN_CMD_DATEACCEPTATION = 'date_acceptation';
  static final COLUMN_CMD_DATEPRISE = 'date_prise_en_charge';
  static final COLUMN_CMD_POSITIONPRISE = 'position_prise_en_charge';
  static final COLUMN_CMD_POSITIONDEST = 'position_destination';
  static final COLUMN_CMD_RATECOMMENT = 'rate_comment';
  static final COLUMN_CMD_RATEDATE = 'rate_date';
  static final COLUMN_CMD_RATEVALUE = 'rate_value';
  static final COLUMN_CMD_ISCREATED = 'is_created';
  static final COLUMN_CMD_ISACCEPTED = 'is_accepted';
  static final COLUMN_CMD_ISREFUSED = 'is_refused';
  static final COLUMN_CMD_ISTERMINATED = 'is_terminated';
  static final COLUMN_CMD_ISSTARTED = 'is_started';
  static final COLUMN_CMD_CLIENTID = 'clientId';
  static final COLUMN_CMD_PRESTATIONID = 'prestationId';

  static final COLUMN_COMPTE_ID = 'compteid';
  static final COLUMN_COMPTE_DATECREATION = 'date_creation';
  static final COLUMN_COMPTE_NUMCOMPTE = 'numero_compte';
  static final COLUMN_COMPTE_SOLDE = 'solde';
  static final COLUMN_COMPTE_PRESTATAIREID = 'prestataireId';


  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }


  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    debugPrint("initializing the db connection....");
    
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, _databaseName);
  
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
    
  }


  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
debugPrint("initializing the table connection....");
    await db.execute("DROP TABLE IF EXISTS $TABLE_PRESTA");
    await db.execute("DROP TABLE IF EXISTS $TABLE_EPOSITION");
    await db.execute("DROP TABLE IF EXISTS $TABLE_SERVICES");
    await db.execute("DROP TABLE IF EXISTS $TABLE_VEHICULES");
    await db.execute("DROP TABLE IF EXISTS $TABLE_PRESTIONS");
    await db.execute("DROP TABLE IF EXISTS $TABLE_CMDE");
    await db.execute("DROP TABLE IF EXISTS $TABLE_COMPTES");


    await db.execute('''
          CREATE TABLE $TABLE_PRESTA (
            ${COLUMN_PRESTA_ID} INTEGER PRIMARY KEY,
            ${COLUMN_PRESTA_CNI} TEXT,
            ${COLUMN_PRESTA_DATE_CREATION} TEXT,
            ${COLUMN_PRESTA_DATE_NAISSANCE} TEXT,
            ${COLUMN_PRESTA_EMAIL} TEXT,
            ${COLUMN_PRESTA_NOM} TEXT,
            ${COLUMN_PRESTA_PAYS} TEXT,
            ${COLUMN_PRESTA_PRENOM} TEXT,
            ${COLUMN_PRESTA_STATUS} TEXT,
            ${COLUMN_PRESTA_TELEPHONE} TEXT,
            ${COLUMN_PRESTA_VILLE} TEXT,
            ${COLUMN_PRESTA_TOKEN} TEXT,
            ${COLUMN_PRESTA_TTL} TEXT,
            ${COLUMN_PRESTA_CODE} TEXT,
            ${COLUMN_PRESTA_IMAGE} TEXT,
            ${COLUMN_PRESTA_POSITION_ID} INTEGER NOT NULL,
            ${COLUMN_PRESTA_USER_ID} INTEGER NOT NULL,
            ${COLUMN_PRESTA_ETAT} BOOLEAN
          )
          ''');
          
    await db.execute('''
          CREATE TABLE  $TABLE_EPOSITION (
            ${COLUMN_POSITION_ID} INTEGER PRIMARY KEY,
            ${COLUMN_POSITION_LAT} FLOAT,
            ${COLUMN_POSITION_LNG} FLOAT,
            ${COLUMN_POSITION_LIBELLE} TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE  $TABLE_SERVICES (
            ${COLUMN_SERV_ID} INTEGER PRIMARY KEY,
            ${COLUMN_SERV_CODE} TEXT,
            ${COLUMN_SERV_DUREE} INTEGER,
            ${COLUMN_SERV_INTITULE} TEXT,
            ${COLUMN_SERV_PRIX} FLOAT,
            ${COLUMN_SERV_PRIXDLA} FLOAT,
            ${COLUMN_SERV_PRIXYDE} FLOAT,
            ${COLUMN_SERV_STATUS} TEXT,
            ${COLUMN_SERV_DATECREATION} TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE  $TABLE_VEHICULES (
            ${COLUMN_VEHI_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${COLUMN_VEHI_COULEUR} TEXT,
            ${COLUMN_VEHI_STATUS} TEXT,
            ${COLUMN_VEHI_IMMATRICULATION} TEXT,
            ${COLUMN_VEHI_MARQUE} TEXT,
            ${COLUMN_VEHI_NOMBREPLACES} INTEGER,
            ${COLUMN_VEHI_DATE} TEXT,
            ${COLUMN_VEHI_IMAGE} TEXT,
            ${COLUMN_VEHI_CODE} TEXT,
            ${COLUMN_VEHI_CATEGORIEVEHICILEID} TEXT,
            ${COLUMN_VEHI_PRESTATAIREID} TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE  $TABLE_PRESTIONS (
            ${COLUMN_PRESTION_ID} INTEGER PRIMARY KEY,
            ${COLUMN_PRESTION_DATE} TEXT,
            ${COLUMN_PRESTION_STATUS} TEXT,
            ${COLUMN_PRESTION_MONTANT} INTEGER,
            ${COLUMN_PRESTION_VEHICULEID} TEXT,
            ${COLUMN_PRESTION_PRESTATAIREID} INTEGER,
            ${COLUMN_PRESTION_SERVICEID} TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE  $TABLE_CMDE (
            ${COLUMN_CMD_ID} INTEGER PRIMARY KEY,
            ${COLUMN_CMD_CODE} TEXT,
            ${COLUMN_CMD_DATE} TEXT,
            ${COLUMN_CMD_DATEDEBUT} TEXT,
            ${COLUMN_CMD_DATEFIN} TEXT,
            ${COLUMN_CMD_MONTANT} FLOAT,
            ${COLUMN_CMD_STATUS} TEXT,
            ${COLUMN_CMD_DISTANCE} TEXT,
            ${COLUMN_CMD_DUREE} TEXT,
            ${COLUMN_CMD_DATEACCEPTATION} TEXT,
            ${COLUMN_CMD_DATEPRISE} TEXT,
            ${COLUMN_CMD_POSITIONPRISE} TEXT,
            ${COLUMN_CMD_POSITIONDEST} TEXT,
            ${COLUMN_CMD_RATECOMMENT} TEXT,
            ${COLUMN_CMD_RATEDATE} TEXT,
            ${COLUMN_CMD_RATEVALUE} FLOAT,
            ${COLUMN_CMD_ISCREATED} BOOLEAN,
            ${COLUMN_CMD_ISACCEPTED} BOOLEAN,
            ${COLUMN_CMD_ISREFUSED} BOOLEAN,
            ${COLUMN_CMD_ISTERMINATED} BOOLEAN,
            ${COLUMN_CMD_ISSTARTED} BOOLEAN,
            ${COLUMN_CMD_CLIENTID} TEXT,
            ${COLUMN_CMD_PRESTATIONID} TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE  $TABLE_COMPTES (
            ${COLUMN_COMPTE_ID} INTEGER PRIMARY KEY,
            ${COLUMN_COMPTE_DATECREATION} TEXT,
            ${COLUMN_COMPTE_NUMCOMPTE} TEXT,
            ${COLUMN_COMPTE_PRESTATAIREID} TEXT,
            ${COLUMN_COMPTE_SOLDE} FLOAT
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
 
  Future<int> insert_presta(Map<String, dynamic> row) async {
    Database db = await instance.database;
     debugPrint("initializing the insertion presta....");
    return await db.insert(TABLE_PRESTA, row);
  }
  Future<int> insert_eposition(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_EPOSITION, row);
  }
  Future<int> insert_service(Map<String, dynamic> row) async {
    Database db = await instance.database;
     debugPrint("initializing the insertion service....");
    return await db.insert(TABLE_SERVICES, row);
  }
  Future<int> insert_vehicule(Map<String, dynamic> row) async {
    Database db = await instance.database;
    debugPrint("initializing the insertion vehicule....");
    return await db.insert(TABLE_VEHICULES, row);
  }
  Future<int> insert_prestation(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_PRESTIONS, row);
  }
  Future<int> insert_cmde(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_CMDE, row);
  }
  Future<int> insert_compte(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(TABLE_COMPTES, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAll_presta() async {
    Database db = await instance.database;
    return await db.query(TABLE_PRESTA);
  }
  Future<List<Map<String, dynamic>>> queryAll_eposition() async {
    Database db = await instance.database;
    return await db.query(TABLE_EPOSITION);
  }
  Future<List<Map<String, dynamic>>> queryAll_service() async {
    Database db = await instance.database;
    return await db.query(TABLE_SERVICES);
  }
  Future<List<Map<String, dynamic>>> queryAll_vehicule() async {
    Database db = await instance.database;
    return await db.query(TABLE_VEHICULES);
  }
  Future<List<Map<String, dynamic>>> queryAll_prestation() async {
    Database db = await instance.database;
    return await db.query(TABLE_PRESTIONS);
  }
  Future<List<Map<String, dynamic>>> queryAll_compte() async {
    Database db = await instance.database;
    return await db.query(TABLE_COMPTES);
  }

  Future<ServicesModel> queryServ_byid(int serviceid) async {
    Database db = await instance.database;
    List<Map> maps = await db.query(TABLE_SERVICES,
        columns: [COLUMN_SERV_ID, COLUMN_SERV_CODE, COLUMN_SERV_PRIXDLA, COLUMN_SERV_PRIX, COLUMN_SERV_PRIXYDE, COLUMN_SERV_INTITULE, COLUMN_SERV_STATUS, COLUMN_SERV_DATECREATION, COLUMN_SERV_DUREE],
        where: '${COLUMN_SERV_ID} = ?',
        whereArgs: [serviceid]);
    if (maps.length > 0) {
      return ServicesModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> queryAll_cmde() async {
    Database db = await instance.database;
    return await db.query(TABLE_CMDE);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $TABLE_PRESTA'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update_presta(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[COLUMN_PRESTA_ID];
    return await db.update(TABLE_PRESTA, row,
        where: '$COLUMN_PRESTA_ID = ?', whereArgs: [id]);
  }



  Future<int> update_compte(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[COLUMN_COMPTE_ID];
    return await db.update(TABLE_COMPTES, row,
        where: '$COLUMN_COMPTE_ID = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete_presta(int id) async {
    Database db = await instance.database;
    return await db
        .delete(TABLE_PRESTA, where: '$COLUMN_PRESTA_ID = ?', whereArgs: [id]);
  }

  Future<int> delete_all_presta() async {
    Database db = await instance.database;
    print("delete_all_presta");
    return await db
        .delete(TABLE_PRESTA);
  }
  Future<int> delete_all_eposition() async {
    Database db = await instance.database;
    print("delete_all_eposition");
    return await db
        .delete(TABLE_EPOSITION);
  }
  Future<int> delete_all_service() async {
    Database db = await instance.database;
    print("delete_all_service");
    return await db
        .delete(TABLE_SERVICES);
  }
  Future<int> delete_all_vehicule() async {
    Database db = await instance.database;
    print("delete_all_vehicule");
    return await db
        .delete(TABLE_VEHICULES);
  }
  Future<int> delete_all_prestation() async {
    Database db = await instance.database;
    print("delete_all_prestation");
    return await db
        .delete(TABLE_PRESTIONS);
  }
  Future<int> delete_all_cmde() async {
    Database db = await instance.database;
    print("delete_all_cmde");
    return await db
        .delete(TABLE_CMDE);
  }
  Future<int> delete_all_compte() async {
    Database db = await instance.database;
    print("delete_all_compte");
    return await db
        .delete(TABLE_COMPTES);
  }
}
