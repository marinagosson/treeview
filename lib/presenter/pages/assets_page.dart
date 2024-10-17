import 'package:flutter/material.dart';
import 'package:treeview_tractian/data/utils/resource.dart';
import 'package:treeview_tractian/infra/di/injection.dart';
import 'package:treeview_tractian/domain/use_cases/fetch_assets_from_company_use_case.dart';
import 'package:treeview_tractian/presenter/controller/assets_controller.dart';
import 'package:treeview_tractian/presenter/utils/colors.dart';
import 'package:treeview_tractian/presenter/utils/debounce.dart';
import 'package:treeview_tractian/presenter/widgets/asset_tree_view_widget.dart';
import 'package:treeview_tractian/presenter/widgets/filter_button.dart';
import 'package:treeview_tractian/presenter/widgets/image.dart';
import 'package:treeview_tractian/presenter/view_model/tree_node_model.dart';
import 'package:treeview_tractian/presenter/widgets/text.dart';

import '../const/assets.dart';

class AssetsPageArgs {
  final String companyId;

  AssetsPageArgs({required this.companyId});
}

class AssetsPage extends StatefulWidget {
  final AssetsPageArgs args;

  const AssetsPage({super.key, required this.args});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  late AssetsController _controller;
  TextEditingController textEditingController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _controller = AssetsController(
        fetchAssetsFromCompanyUseCase:
            Injection.instance<FetchAssetsFromCompanyUseCase>());
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(5);
    var textStyle = TextStyle(fontSize: 14, color: AppColors.neutralGrey500);
    var borderSide = BorderSide(color: AppColors.neutralGrey100, width: 2);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: CustomImage(asset: Assets.appBarLeading).fromAsset(),
        ),
        title: const Text(
          'Assets',
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.neutralGrey100,
                      borderRadius: borderRadius),
                  child: TextField(
                    style: textStyle,
                    controller: textEditingController,
                    onChanged: (search) {
                      _debouncer.run(() {
                        _controller.setFilterValue(
                            text: search,
                            filterValue: _controller.currentFilter);
                      });
                    },
                    decoration: InputDecoration(
                        hintStyle: textStyle,
                        labelStyle: textStyle,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.neutralGrey500,
                        ),
                        hintText: 'Buscar Ativo ou Local',
                        enabledBorder: OutlineInputBorder(
                            borderSide: borderSide, borderRadius: borderRadius),
                        focusedBorder: OutlineInputBorder(
                            borderSide: borderSide, borderRadius: borderRadius),
                        border: OutlineInputBorder(
                            borderSide: borderSide, borderRadius: borderRadius),
                        disabledBorder: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FilterGroupWidget<int>(
                      onChanged: (FilterItem<int>? filterValue) {
                        _controller.setFilterValue(
                            filterValue: filterValue?.value,
                            text: textEditingController.text);
                      },
                      list: [
                        FilterItem<int>(
                            enabled: true,
                            isSelect: false,
                            value: 1,
                            text: 'Sensor de energia',
                            iconSelected: Assets.boltWhite,
                            iconDefault: Assets.boltGrey),
                        FilterItem<int>(
                            enabled: true,
                            isSelect: false,
                            value: 2,
                            text: 'Crítico',
                            iconSelected: Assets.infoGrey,
                            iconDefault: Assets.infoWhite)
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors.neutralGrey100,
          ),
          Expanded(
              child: ValueListenableBuilder<Resource<List<TreeNode>>>(
                  valueListenable: _controller.viewItemsList,
                  builder: (context, resource, child) {
                    if (resource.isSuccess()) {
                      if (resource.data == null ||
                          resource.data != null && resource.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: CustomText(
                                  value: 'Nenhum asset encontrado',
                                  color: AppColors.neutralGrey500)
                              .filterButton,
                        );
                      }
                      return AssetTreeView(
                        nodes: [
                          TreeNode(
                              name: 'Root',
                              type: 'root',
                              status: '',
                              children: resource.data!)
                        ],
                      );
                    }
                    return const SizedBox();
                  }))
        ],
      ),
    );
  }

  void _loadData() {
    _controller.fetchAllAssetsFromCompany(widget.args.companyId);
  }
}
