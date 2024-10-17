import 'package:flutter/material.dart';
import 'package:treeview_tractian/infra/di/injection.dart';
import 'package:treeview_tractian/presenter/navigation/app_routes.dart';
import 'package:treeview_tractian/presenter/utils/colors.dart';
import 'package:treeview_tractian/presenter/pages/assets_page.dart';
import 'package:treeview_tractian/presenter/pages/home_page.dart';
import 'package:treeview_tractian/presenter/pages/loading_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Injection().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            switch (settings.name) {
              case AppRoutes.initial:
                return const LoadingPage();
              case AppRoutes.home:
                return const HomePage();
              case AppRoutes.asset:
                return AssetsPage(
                  args: settings.arguments as AssetsPageArgs,
                );
              default:
                throw UnimplementedError('${settings.name} route not founded');
            }
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      },
      theme: ThemeData(
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            titleTextStyle: TextStyle(color: AppColors.white, fontSize: 18),
            backgroundColor: AppColors.tractian,
          )),
    );
  }
}
