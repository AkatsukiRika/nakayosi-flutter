import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/routes/become_pro.dart';
import 'package:nakayosi_flutter/routes/nk_settings.dart';
import 'package:nakayosi_flutter/routes/pro_login.dart';

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
          ListTile(
            dense: true,
            title: Row(
              children: [
                Icon(Icons.person, size: 20),
                Container(
                  width: 15,
                ),
                Text(GlobalStrings.drawerBecomePro),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => BecomePro()
              ));
            },
          ),
          getProUserTile(),
        ],
      ),
    );
  }

  Widget getProUserTile() {
    if (GlobalStates.realNameLoggedIn != null) {
      return ListTile(
        dense: true,
        title: Row(
          children: [
            Icon(Icons.logout, size: 20),
            Container(
              width: 15,
            ),
            Text(GlobalStrings.drawerProLogout),
          ],
        ),
        onTap: () {
          showLogoutDialog();
        },
      );
    } else {
      return ListTile(
        dense: true,
        title: Row(
          children: [
            Icon(Icons.login, size: 20),
            Container(
              width: 15,
            ),
            Text(GlobalStrings.drawerProLogin),
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ProLogin()
          ));
        },
      );
    }
  }

  void showLogoutDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(GlobalStrings.confirmLogoutTitle),
          content: Text(GlobalStrings.confirmLogoutContent(GlobalStates.realNameLoggedIn)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(GlobalStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                /**
                 * 由于realNameLoggedIn参数是直接存在本地的，
                 * 为了简化流程，暂不调用服务器接口，
                 * 直接将本地的该变量置空来进行登出操作
                 * （服务器端session可覆盖，在第二次登录时会被新值覆盖）
                 */
                GlobalStates.realNameLoggedIn = null;
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
              child: Text(GlobalStrings.confirm),
            ),
          ],
        );
      }
    );
  }
}