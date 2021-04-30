import 'package:workmannow/providers/auth.dart';
import 'package:workmannow/widgets/divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authprovider, child) {
        var user = authprovider.user;
        return Drawer(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                          radius: 70.0,
                          backgroundImage: user['dpImage'] != null
                              ? NetworkImage(
                                  user['dpImage'],
                                )
                              : AssetImage('assets/dp.png')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: Row(
                        children: [
                          Text(
                            '${user['lastName']} ${user['firstName']}'
                                .titleCase,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DividerWidget(),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                      ),
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/user_profile');
                      },
                    )
                  ],
                )),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text('Logout'),
                  onTap: authprovider.logout,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
