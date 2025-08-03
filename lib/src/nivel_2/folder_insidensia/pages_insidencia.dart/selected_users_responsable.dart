import 'package:flutter/material.dart';
import '/src/datebase/methond.dart';
import '/src/datebase/url.dart';
import '/src/model/users.dart';
import '/src/widgets/custom_app_bar.dart';

class SelectedUsersReponsable extends StatefulWidget {
  const SelectedUsersReponsable({super.key, required this.pressDepartment});
  final Function pressDepartment;
  @override
  State<SelectedUsersReponsable> createState() =>
      _SelectedUsersReponsableState();
}

class _SelectedUsersReponsableState extends State<SelectedUsersReponsable> {
  List<Users> userList = [];
  List choosed = [];
  Future getUserAdmin() async {
    final res = await httpRequestDatabase(selectUsersAdmin, {'view': 'view'});
    userList = usersFromJson(res.body);
    if (userList.isNotEmpty) {
      setState(() {});
    }
    // print(res.body);
  }

  @override
  void initState() {
    super.initState();
    // date = DateTime.now().toString().substring(0, 10);
    getUserAdmin();
    // getNiveles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Picked Usuarios'),
          choosed.isNotEmpty
              ? SizedBox(
                  height: 50,
                  width: 300,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: choosed
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Chip(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(e),
                                ),
                                onDeleted: () {
                                  setState(() {
                                    choosed.remove(e);
                                  });
                                },
                                deleteIcon: const Icon(Icons.close),
                              ),
                            ))
                        .toList(),
                  ),
                )
              : const SizedBox(),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                Users current = userList[index];
                return ListTile(
                  onTap: () {
                    setState(() {
                      choosed.add(current.fullName);
                    });
                  },
                  title: Text(current.fullName.toString()),
                  subtitle: const Text('Selected'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.pressDepartment(choosed);
                    },
                    child: const Text('Terminar'))),
          )
        ],
      ),
    );
  }
}
