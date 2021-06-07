import 'package:FIS/screens/Deadwood/deadwoodscreen.dart';
import 'package:FIS/screens/Deadwood/deadwoodformscreen.dart';
import 'package:FIS/screens/Inventory/inventory_list_screen.dart';
import 'package:FIS/screens/Plot/plotScreen.dart';
import 'package:FIS/screens/Plot/plotformScreen.dart';
import 'package:FIS/screens/login/login.dart';
import 'package:FIS/screens/setting/setting.dart';
import 'package:FIS/screens/splash/splashscreen.dart';
import 'package:FIS/screens/tree_screen.dart/RegisterTreeScreen.dart';
import 'package:FIS/screens/tree_screen.dart/register_tree.dart';
import 'package:flutter/widgets.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  InventoryListScreen.routeName: (context) => InventoryListScreen(),
  PlotScreen.routeName: (context) => PlotScreen(),
  PlotFormScreen.routeName: (context) => PlotFormScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  RegisterTree.routeName: (context) => RegisterTree(),
  Setting.routeName: (context) => Setting(),
  DeadWoodScreen.routeName: (context) => DeadWoodScreen(),
  RegisterTreeScreen.routeName: (context) => RegisterTreeScreen(),
  DeadWoodFormScreen.routeName: (context) => DeadWoodFormScreen(),
};
