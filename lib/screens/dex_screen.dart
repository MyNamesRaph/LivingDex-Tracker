import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livingdex_tracker/data/data_helper.dart';

import '../notifications/gen_changed.dart';
import '../widgets/side_menu.dart';

class DexScreen extends StatefulWidget {
  const DexScreen({Key? key}) : super(key: key);

  @override
  State<DexScreen> createState() => _DexScreenState();
}

class _DexScreenState extends State<DexScreen> {
  //TODO: get from the constructor
  var _currentGen = DataHelper.generations[0].number;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<GenChanged>(
        onNotification: (notification) {
          setState(() {_currentGen = notification.val;});
          return true;
        },
        child: Scaffold(
          drawer: const SideMenu(),
          appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                "Living Dex",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              )
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
                "Gen: $_currentGen",
                style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        )
    );

  }
}