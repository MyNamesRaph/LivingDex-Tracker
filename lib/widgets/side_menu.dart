import 'package:flutter/material.dart';
import 'package:livingdex_tracker/data/data_helper.dart';
import 'package:livingdex_tracker/notifications/gen_changed.dart';

//Source: https://maffan.medium.com/how-to-create-a-side-menu-in-flutter-a2df7833fdfb

class SideMenu extends StatelessWidget {


  const SideMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width/3,
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: DataHelper.generations.map<Widget>((gen) =>
            ListTile(
              title: Text(
                gen.text,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              onTap: () => {
                GenChanged(gen.number).dispatch(context)
                },
            )
        ).toList()..insert(0,
          DrawerHeader(
            child: Text(
              'Gen :',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        )
      ),
    );
  }
}