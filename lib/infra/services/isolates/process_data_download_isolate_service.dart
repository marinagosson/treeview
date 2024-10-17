import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/asset_dao.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/company_dao.dart';
import 'package:treeview_tractian/data/data_sources/local/daos/location_dao.dart';
import 'package:treeview_tractian/infra/services/database/database_service.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/infra/di/injection.dart';
import 'package:treeview_tractian/domain/models/asset_model.dart';
import 'package:treeview_tractian/domain/models/company_model.dart';
import 'package:treeview_tractian/domain/models/location_model.dart';

class ProcessDataDownloadIsolateService {
  Future<Resource<bool>> processDataInIsolate(
      List<CompanyModel> companies,
      List<AssetModel> assets,
      List<LocationModel> locations) async {

    final receivePort = ReceivePort();

    await Isolate.spawn(processData, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;

    final result = await sendReceive(sendPort, companies, assets, locations);

    final List<Map<String, dynamic>> companyMaps = result[0];
    final List<Map<String, dynamic>> assetMaps = result[1];
    final List<Map<String, dynamic>> locationsMaps = result[2];

    return await onResultProcessDataAndSaveToDatabase(
        companyMaps, assetMaps, locationsMaps);
  }

  Future<List<dynamic>> sendReceive(SendPort port, List<CompanyModel> companies,
      List<AssetModel> assets, List<LocationModel> locations) async {
    final response = ReceivePort();
    port.send([companies, assets, locations, response.sendPort]);

    final result = await response.first;

    if (result is List<dynamic>) {
      return result;
    } else {
      throw Exception('O resultado não é uma lista');
    }
  }

  void processData(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      final List<CompanyModel> companies = msg[0];
      final List<AssetModel> assets = msg[1];
      final List<LocationModel> locations = msg[2];
      final SendPort replyTo = msg[3];

      final List<Map<String, dynamic>> companyMaps =
          companies.map((company) => company.parseToDatabase()).toList();
      final List<Map<String, dynamic>> assetMaps =
          assets.map((asset) => asset.parseToDatabase()).toList();
      final List<Map<String, dynamic>> locationsMaps =
          locations.map((location) => location.parseToDatabase()).toList();

      replyTo.send([companyMaps, assetMaps, locationsMaps]);
    }
  }

  Future<Resource<bool>> onResultProcessDataAndSaveToDatabase(
      List<Map<String, dynamic>> companyMaps,
      List<Map<String, dynamic>> assetMaps,
      List<Map<String, dynamic>> locationsMaps) async {
    try {
      final db = await Injection.instance<DatabaseService>().database;
      await db.database.transaction((txn) async {
        final batch = txn.batch();

        for (var companyMap in companyMaps) {
          batch.insert(CompanyDAO.tableName, companyMap,
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }

        for (var assetMap in assetMaps) {
          batch.insert(AssetDAO.tableName, assetMap,
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
        for (var assetMap in locationsMaps) {
          batch.insert(LocationDAO.tableName, assetMap,
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }

        await batch.commit();
      });
      return Resource.success();
    } catch (error) {
      debugPrint(
          'IsolateService.onResultProcessDataAndSaveToDatabase error: ${error.toString()}');
      return Resource.failure(AppError('Erro ao criar realizar o map ', exception: error));
    }
  }
}
