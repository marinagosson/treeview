import 'package:flutter/material.dart';
import 'package:treeview_tractian/presenter/const/assets.dart';
import 'package:treeview_tractian/presenter/utils/colors.dart';
import 'package:treeview_tractian/presenter/utils/custom_paint.dart';
import 'package:treeview_tractian/presenter/widgets/image.dart';
import 'package:treeview_tractian/presenter/widgets/text.dart';
import 'package:treeview_tractian/presenter/view_model/tree_node_model.dart';

class AssetTreeView extends StatefulWidget {
  final List<TreeNode> nodes;

  const AssetTreeView({super.key, required this.nodes});

  @override
  State<AssetTreeView> createState() => _AssetTreeViewState();
}

class _AssetTreeViewState extends State<AssetTreeView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: widget.nodes.map((node) => buildNode(node)).toList(),
    );
  }

  Widget buildNode(TreeNode node, {int level = 0, String? parent}) {
    const sizeContainerIcon = 20.0;
    const paddingLeft = sizeContainerIcon * 0.8;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: node.type == 'root' ? null : () {
        node.expanded = !node.expanded;
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.only(left: level == 0 ? 0 : paddingLeft, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (node.type == 'component' &&
                parent != null &&
                parent == 'asset') ...[
              Padding(
                padding: const EdgeInsets.only(left: paddingLeft - 2),
                child: CustomPaint(
                  painter: LShapeBorderPainter(
                      lineWidth: 1.0,
                      baseLength: 20,
                      color: AppColors.neutralGrey200),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: paddingLeft,
                      ),
                      SizedBox(
                        width: sizeContainerIcon,
                        height: sizeContainerIcon,
                        child: CustomImage(
                                asset: getIconHeaderForType(
                                    node.type, node.status))
                            .fromAsset(),
                      ),
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: CustomText(value: node.name).tree,
                      )),
                      const SizedBox(width: 10),
                      CustomImage(asset: getIconFromStatus(node.status))
                          .fromAsset(),
                    ],
                  ),
                ),
              )
            ] else ...[
              Row(
                children: [
                  if ((node.type == 'location' || node.type == 'asset') &&
                      node.children.isNotEmpty) ...[
                    SizedBox(
                      width: sizeContainerIcon,
                      height: sizeContainerIcon,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: CustomImage(
                                asset: node.expanded
                                    ? Assets.arrowDown
                                    : Assets.arrowUp)
                            .fromAsset(),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                  ],
                  if (node.type == 'root') ...[
                    SizedBox(
                        width: sizeContainerIcon,
                        height: sizeContainerIcon,
                        child: CustomText(value: '-').tree),
                  ],
                  if (node.type != 'root') ...[
                    SizedBox(
                      width: sizeContainerIcon,
                      height: sizeContainerIcon,
                      child: CustomImage(
                              asset:
                                  getIconHeaderForType(node.type, node.status))
                          .fromAsset(),
                    ),
                  ],
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: CustomText(value: node.name).tree,
                  )),
                  if (node.type == 'component') ...[
                    const SizedBox(width: 10),
                    CustomImage(asset: getIconFromStatus(node.status))
                        .fromAsset(),
                  ]
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              AnimatedSize(
                alignment: Alignment.topCenter,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                child: Visibility(
                  visible: node.children.isNotEmpty && node.expanded,
                  child: Container(
                    padding:
                        EdgeInsets.only(left: level > 0 ? paddingLeft / 2 : 0),
                    decoration: node.type == 'location' || node.type == 'root'
                        ? BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: AppColors.neutralGrey100, width: 1)))
                        : null,
                    child: Column(
                      children: node.children
                          .map((child) => buildNode(child,
                              level: level + 1, parent: node.type))
                          .toList(),
                    ),
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  String getIconFromStatus(String status) {
    switch (status) {
      case 'operating':
        return Assets.boltGreen;
      case 'alert':
        return Assets.operation;
      default:
        return '';
    }
  }

  String getIconHeaderForType(String type, String status) {
    switch (type) {
      case 'location':
        return Assets.location;
      case 'asset':
        return Assets.cube;
      case 'component':
        return Assets.codepen;
      default:
        return Assets.parent;
    }
  }
}
