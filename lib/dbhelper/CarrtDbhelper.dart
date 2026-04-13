import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbProductManager {
  Database ?_database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(join(await getDatabasesPath(), "ss6.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE products(id INTEGER PRIMARY KEY autoincrement, pname TEXT, pid TEXT, pimage TEXT, pprice TEXT, pQuantity INTEGER, pcolor TEXT, psize TEXT, pdiscription TEXT, sgst TEXT, cgst TEXT, discount TEXT, discountValue TEXT, adminper TEXT, adminpricevalue TEXT, costPrice TEXT,shipping TEXT,totalQuantity TEXT,varient TEXT,mv INT,moq TEXT,time1 TEXT,date1 TEXT)",
        );
      });
    }
  }

  Future<int> insertStudent(ProductsCart products) async {
    await openDb();
    
    final List<Map<String, dynamic>> maps = await _database!.query('products',
        where: "pid = ?", whereArgs: [products.pid]);
        
    for (var map in maps) {
      String strColorA = (map['pcolor'] == null || map['pcolor'] == "null" || map['pcolor'].toString().trim().isEmpty) ? "" : map['pcolor'].toString().trim();
      String strColorB = (products.pcolor == null || products.pcolor == "null" || products.pcolor!.trim().isEmpty) ? "" : products.pcolor!.trim();
      
      String strSizeA = (map['psize'] == null || map['psize'] == "null" || map['psize'].toString().trim().isEmpty) ? "" : map['psize'].toString().trim();
      String strSizeB = (products.psize == null || products.psize == "null" || products.psize!.trim().isEmpty) ? "" : products.psize!.trim();
      
      String strVarA = (map['varient'] == null || map['varient'] == "null" || map['varient'].toString().trim().isEmpty) ? "" : map['varient'].toString().trim();
      String strVarB = (products.varient == null || products.varient == "null" || products.varient!.trim().isEmpty) ? "" : products.varient!.trim();
      
      if (strColorA == strColorB && strSizeA == strSizeB && strVarA == strVarB) {
         int existingQty = map['pQuantity'] ?? 0;
         int addQty = products.pQuantity ?? 1;
         products.pQuantity = existingQty + addQty;
         
         double singlePrice = double.tryParse(products.pprice ?? "0") ?? 0.0;
         if (addQty > 0) singlePrice = singlePrice / addQty;
         
         products.pprice = (singlePrice * products.pQuantity!).toString();
         products.id = map['id'];
         
         return await updateStudent(products);
      }
    }
    
    return await _database!.insert('products', products.toMap());
  }

  Future<List<ProductsCart>> getProductList() async {
    await openDb();
    final List<Map<String, dynamic>> maps =
        await _database!.query('products', orderBy: "mv ASC");
    return List.generate(maps.length, (i) {
      return ProductsCart(
          id: maps[i]['id'],
          pname: maps[i]['pname'],
          pid: maps[i]['pid'],
          pimage: maps[i]['pimage'],
          pprice: maps[i]['pprice'],
          pQuantity: maps[i]['pQuantity'],
          pcolor: maps[i]['pcolor'],
          psize: maps[i]['psize'],
          pdiscription: maps[i]['pdiscription'],
          sgst: maps[i]['sgst'],
          cgst: maps[i]['cgst'],
          discount: maps[i]['discount'],
          discountValue: maps[i]['discountValue'],
          adminper: maps[i]['adminper'],
          adminpricevalue: maps[i]['adminpricevalue'],
          costPrice: maps[i]['costPrice'],
          shipping: maps[i]['shipping'],
          totalQuantity: maps[i]['totalQuantity'],
          varient: maps[i]['varient'],
          mv: maps[i]['mv'],
          moq: maps[i]['moq'],
          time1: maps[i]['time1'],
          date1: maps[i]['date1']);
    });
  }

  Future<List<ProductsCart>> getProductList1(String pid) async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database!.query('products',
        where: "pid = ?", whereArgs: [pid], orderBy: "mv ASC");
    return List.generate(maps.length, (i) {
      return ProductsCart(
        id: maps[i]['id'],
        pname: maps[i]['pname'],
        pid: maps[i]['pid'],
        pimage: maps[i]['pimage'],
        pprice: maps[i]['pprice'],
        pQuantity: maps[i]['pQuantity'],
        pcolor: maps[i]['pcolor'],
        psize: maps[i]['psize'],
        pdiscription: maps[i]['pdiscription'],
        sgst: maps[i]['sgst'],
        cgst: maps[i]['cgst'],
        discount: maps[i]['discount'],
        discountValue: maps[i]['discountValue'],
        adminper: maps[i]['adminper'],
        adminpricevalue: maps[i]['adminpricevalue'],
        costPrice: maps[i]['costPrice'],
        shipping: maps[i]['shipping'],
        totalQuantity: maps[i]['totalQuantity'],
        varient: maps[i]['varient'],
        mv: maps[i]['mv'],
      );
    });
  }

  Future<int> updateStudent(ProductsCart products) async {
    await openDb();
    return await _database!.update('products', products.toMap(),
        where: "id = ?", whereArgs: [products.id]);
  }

  Future<int> updateStudent1(ProductsCart products) async {
    await openDb();
    return await _database!.update('products', products.toMap(),
        where: "pid = ?", whereArgs: [products.pid]);
  }

  Future<void> deleteProducts(int id) async {
    await openDb();
    await _database!.delete('products', where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteallProducts() async {
    await openDb();
    await _database!.delete('products');
    debugPrint("delete all called food");
  }
}

class ProductsCart {
  int? id;
  String? pname;
  String? pid;
  String? pimage;
  String? pprice;
  int? pQuantity;
  String? pcolor;
  String? psize;
  String? pdiscription;
  String? sgst;
  String? cgst;
  String? discount;
  String? discountValue;
  String? adminper;
  String? adminpricevalue;
  String? costPrice;
  String? shipping;
  String? totalQuantity;
  String? varient;
  String? time1;
  String? date1;
  int? mv;
  String? moq;

  set price(String price) {
    this.pprice = price;
  }

  set quantity(int pQuantity) {
    this.pQuantity = pQuantity;
  }

    String get price => this.pprice??"";
  int get quantity => this.pQuantity!;

  ProductsCart({
     this.pname,
     this.pid,
     this.pimage,
     this.pprice,
     this.pQuantity,
     this.pcolor,
     this.psize,
     this.pdiscription,
     this.sgst,
     this.cgst,
     this.discount,
     this.discountValue,
     this.adminper,
     this.adminpricevalue,
     this.costPrice,
     this.shipping,
     this.totalQuantity,
     this.varient,
     this.mv,
     this.moq,
     this.time1,
     this.date1,
     this.id,
  });
  Map<String, dynamic> toMap() {
    return {
      'pname': pname,
      'pid': pid,
      'pimage': pimage,
      'pprice': pprice,
      'pQuantity': pQuantity,
      'pcolor': pcolor,
      'psize': psize,
      'pdiscription': pdiscription,
      'sgst': sgst,
      'cgst': cgst,
      'discount': discount,
      'discountValue': discountValue,
      'adminper': adminper,
      'adminpricevalue': adminpricevalue,
      'costPrice': costPrice,
      'shipping': shipping,
      'totalQuantity': totalQuantity,
      'varient': varient,
      'mv': mv,
      'moq': moq,
      'time1': time1,
      'date1': date1
    };
  }
}
