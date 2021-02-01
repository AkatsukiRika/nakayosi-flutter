import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:package_info/package_info.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  bool _isPackageInfoInitialized = false;
  PackageInfo _packageInfo;

  void _initPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _isPackageInfoInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPackageInfoInitialized) {
      _initPackageInfo();
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: null,
            decoration: BoxDecoration(color: GlobalColors.colorPrimary),
          ),
          ListTile(
            dense: true,
            title: Row(
              children: [
                Icon(Icons.settings, size: 20),
                Container(
                  width: 15,
                ),
                Text(GlobalStrings.drawerSettings),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}