import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/routes/nk_settings.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: null,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/nkimg_drawerbg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
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
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => NkSettings()
              ));
            },
          ),
        ],
      ),
    );
  }
}