class TreeNode {
  final String id;
  final String name;
  final String type; // "location", "asset", "component"
  final String status; // "operating", "alert" (para componentes)
  List<TreeNode> children;
  bool expanded;

  TreeNode({
    this.id = '',
    required this.name,
    required this.type,
    required this.status,
    this.expanded = true,
    List<TreeNode>? children,
  }) : children = children ?? <TreeNode>[];

  @override
  String toString() {
    return 'name: $name | type: $type | status: $status\n children: ${children.length}';
  }
}
