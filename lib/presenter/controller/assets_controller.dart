import 'package:flutter/foundation.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/domain/use_cases/fetch_assets_from_company_use_case.dart';
import 'package:treeview_tractian/presenter/view_model/tree_node_model.dart';

class AssetsController {
  FetchAssetsFromCompanyUseCase fetchAssetsFromCompanyUseCase;

  AssetsController({required this.fetchAssetsFromCompanyUseCase});

  List<TreeNode> itemsBkp = [];

  int? currentFilter;

  ValueNotifier<Resource<List<TreeNode>>> viewItemsList =
      ValueNotifier(Resource.success(data: []));

  void fetchAllAssetsFromCompany(String companyId) async {
    fetchAssetsFromCompanyUseCase.call(companyId).then((result) {
      result.fold((error) {
        viewItemsList.value = Resource.failure(error);
      }, (itemsTreeNode) {
        sortNodesByTotalChildren(itemsTreeNode!);
        itemsBkp = itemsTreeNode;
        viewItemsList.value = Resource.success(data: itemsTreeNode);
      });
    });
  }

  int countTotalChildren(TreeNode node) {
    int count = node.children.length;
    for (var child in node.children) {
      count += countTotalChildren(child);
    }

    return count;
  }

  void sortNodesByTotalChildren(List<TreeNode> nodes) {
    nodes.sort((a, b) {
      int aTotalChildren = countTotalChildren(a);
      int bTotalChildren = countTotalChildren(b);
      return bTotalChildren.compareTo(aTotalChildren);
    });
  }

  void setFilterValue({int? filterValue, String? text}) {
    if (filterValue != null || (text != null && text.isNotEmpty)) {
      currentFilter = filterValue;
      List<TreeNode> listTemp = [];
      List<TreeNode> result = searchTree(
          TreeNode(name: 'Root', type: 'root', status: '', children: itemsBkp),
          isOperation: currentFilter == 1,
          isVibration: currentFilter == 2,
          text: text);
      listTemp.addAll(result.isNotEmpty ? result[0].children : []);
      viewItemsList.value = Resource.success(data: listTemp);
    } else {
      currentFilter = filterValue;
      viewItemsList.value = Resource.success(data: itemsBkp);
    }
  }

  List<TreeNode> searchTree(TreeNode node,
      {String? text, bool isOperation = false, bool isVibration = false}) {
    List<TreeNode> matchingChildren = [];

    for (var child in node.children) {
      var filteredChildren = searchTree(child,
          text: text, isOperation: isOperation, isVibration: isVibration);

      if (filteredChildren.isNotEmpty) {
        matchingChildren.add(filteredChildren[0]);
      }
    }

    bool matchesSearch = (text != null && text.isNotEmpty && node.name.toLowerCase().contains(text.toLowerCase()));

    bool matchFilters = ((node.type == 'component' &&
            isOperation &&
            node.status == 'operating') ||
        (node.type == 'component' && isVibration && node.status == 'alert'));

    if ((matchFilters || matchesSearch) || matchingChildren.isNotEmpty) {
      return [
        TreeNode(
          id: node.id,
          name: node.name,
          type: node.type,
          status: node.status,
          children: matchingChildren,
        )
      ];
    }

    return [];
  }
}
