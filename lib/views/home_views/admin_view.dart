import 'package:flutter/material.dart';
import 'package:movies_webapp/dependencyInjection.dart';
import 'package:movies_webapp/providers/authentication.dart';
import 'package:movies_webapp/routing/route_names.dart';
import 'package:movies_webapp/services/firebase_services.dart';
import 'package:movies_webapp/services/navigation_service.dart';
import 'package:movies_webapp/widgets/appbar.dart';
import 'package:provider/provider.dart';

class AdminView extends StatefulWidget {
  AdminView({Key? key}) : super(key: key);

  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider auth = Provider.of<AuthenticationProvider>(context);
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height - appBarSize.height,
      child: loading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Row(
                        children: [
                          Text(
                            'To Upgrade User to be a Manager : ',
                          ),
                          Icon(
                            Icons.upgrade,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'To Delete User : ',
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: auth.users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${auth.users[index].userName}'),
                          subtitle: Text(
                              'Role: ${auth.users[index].role.toUpperCase()} \nEmail: ${auth.users[index].email}'),
                          leading: auth.users[index].wannaBeManager
                              ? IconButton(
                                  icon: Icon(
                                    Icons.upgrade,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    print('Upgrade user with uid: ' +
                                        auth.users[index].id);

                                    bool isUpgraded =
                                        await FireBaseServices().updateUserRole(
                                      auth.users[index].id,
                                    );
                                    if (isUpgraded) {
                                      auth.users = [];
                                      auth.getAllUsers();
                                      setState(() {
                                        loading = false;
                                      });
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.person,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              print('Delete user with uid: ' +
                                  auth.users[index].id);

                              bool isDeleted =
                                  await FireBaseServices().deleteUser(
                                auth.users[index].id,
                                auth.users[index].email,
                                '12345678',
                                //TODO: Think about that if you have time!!
                                //-> no way to get password of specific user , also no way to delete an auth user from other account using just his uid;
                                //-> need server side or cloud as I understand
                              );
                              print('isDeleted : ' + isDeleted.toString());
                              if (isDeleted) {
                                auth.users = [];
                                auth.getAllUsers();
                                setState(() {
                                  loading = false;
                                });
                              } else {
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
