import 'package:flutter/material.dart';
import 'package:treeview_tractian/presenter/navigation/app_routes.dart';
import 'package:treeview_tractian/presenter/pages/assets_page.dart';

class Navigation {
  static navigateToAssets(BuildContext context, String companyId) {
    Navigator.pushNamed(context, AppRoutes.asset,
        arguments: AssetsPageArgs(companyId: companyId));
  }

  static navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.home);
  }
}
