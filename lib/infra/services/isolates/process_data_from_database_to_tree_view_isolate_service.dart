import 'dart:async';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:treeview_tractian/data/utils/app_errors.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/models/asset_model.dart';
import 'package:treeview_tractian/domain/models/location_model.dart';
import 'package:treeview_tractian/presenter/view_model/tree_node_model.dart';

class ProcessDataFromDatabaseToTreeViewIsolateService {
  TreeNode? findNodeById(
      TreeNode node, String targetId, AssetModel toAddChildren, String type) {
    if (node.id == targetId) {
      node.children.add(TreeNode(
          id: toAddChildren.id,
          name: toAddChildren.name,
          type: type,
          status: toAddChildren.status ?? ''));
      return node;
    }

    for (var child in node.children) {
      findNodeById(child, targetId, toAddChildren, type);
    }

    return null;
  }

  void process(List<AssetModel> assetsData, List<LocationModel> locationsData,
      Completer<Resource<List<TreeNode>>> completer) async {
    try {
      final receivePort = ReceivePort();
      await Isolate.spawn(processData, receivePort.sendPort);
      final sendPort = await receivePort.first as SendPort;

      final result = await sendReceive(sendPort, assetsData, locationsData);
      completer.complete(Resource.success(data: result));
    } catch (error) {
      debugPrint(
          'ProcessDataFromDatabaseToTreeViewIsolateService.process: ${error.toString()}');
      completer.completeError(
          Resource.failure(AppError('Erro ao processsar os dados')));
    }
  }

  void processData(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      final List<AssetModel> assets = msg[0];
      final List<LocationModel> locations = msg[1];
      final SendPort replyTo = msg[2];

      Map<String, TreeNode> locationMap = {};

      var locationsWithParentId = [];

      for (var location in locations) {
        if (location.parentId == null) {
          locationMap[location.id] = TreeNode(
              id: location.id,
              name: location.name,
              type: 'location',
              status: '');
        } else {
          locationsWithParentId.add(location);
        }
      }

      for (var location in locationsWithParentId) {
        if (locationMap.containsKey(location.parentId)) {
          locationMap[location.parentId]!.children.add(TreeNode(
                id: location.id,
                name: location.name,
                type: 'location',
                status: '',
              ));
        }
      }

      List<AssetModel> componentsAlone = [];
      List<AssetModel> assetSameLocationParent = [];
      List<AssetModel> subAssets = [];
      List<AssetModel> componentsInsideAsset = [];
      List<AssetModel> componentsInsideLocation = [];

      for (var element in assets) {
        // If the item has a sensorType, it means it is a component.
        // If it does not have a location or a parentId, it means he is unliked
        // from any asset or location in the tree.
        // SELECT * FROM 'assets' WHERE company_id LIKE "662fd100f990557384756e58" AND sensor_type IS NOT NULL AND location_id IS NULL AND parent_id IS NULL LIMIT 0,30
        if (element.sensorType != null &&
            element.parentId == null &&
            element.locationId == null) {
          componentsAlone.add(element);
        }

        // If the item has a location and does not have a sensorId,
        // it means he is an asset with a location as parent,
        // from the location collection
        if (element.locationId != null && element.sensorId == null) {
          assetSameLocationParent.add(element);
        }

        // If the item has a parentId and does not have a sensorId,
        // it means he is an asset with another asset as a parent
        if (element.parentId != null && element.sensorId == null) {
          subAssets.add(element);
        }

        // If the item has a sensorType, it means it is a component.
        // If it does have a location or a parentId, it means he has an asset
        // or Location as parent
        if (element.sensorType != null &&
            element.parentId != null &&
            element.locationId == null) {
          componentsInsideAsset.add(element);
        }
        if (element.sensorType != null &&
            element.locationId != null &&
            element.parentId == null) {
          componentsInsideLocation.add(element);
        }
      }

      for (var asset in assetSameLocationParent) {
        locationMap.forEach((key, node) {
          findNodeById(node, asset.locationId!, asset, 'asset');
        });
      }

      for (var asset in subAssets) {
        locationMap.forEach((key, node) {
          findNodeById(node, asset.parentId!, asset, 'asset');
        });
      }

      for (var asset in componentsInsideAsset) {
        locationMap.forEach((key, node) {
          findNodeById(node, asset.parentId!, asset, 'component');
        });
      }

      for (var asset in componentsInsideLocation) {
        locationMap.forEach((key, node) {
          findNodeById(node, asset.locationId!, asset, 'component');
        });
      }

      final List<TreeNode> root = [];
      root.addAll(locationMap.values);
      root.addAll(componentsAlone.map((element) => TreeNode(
          id: element.id,
          name: element.name,
          type: 'component',
          status: element.status ?? '')));

      replyTo.send(root);
    }
  }

  sendReceive(SendPort sendPort, assets, locations) async {
    final response = ReceivePort();
    sendPort.send([assets, locations, response.sendPort]);

    final result = await response.first;

    if (result is List<dynamic>) {
      return result;
    } else {
      throw Exception('O resultado não é uma lista');
    }
  }
}
