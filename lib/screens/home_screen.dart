import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livingdex_tracker/data/generation_helper.dart';
import 'package:livingdex_tracker/screens/dex_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/images/dex.png"),
          alignment: Alignment(-0.8,-0.975)
        ),
        color: Theme.of(context).primaryColor,
      ),
        child:
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: GenerationHelper.generations.map((gen) {
                    return
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  splashColor: Theme.of(context).shadowColor,
                                  focusColor: Theme.of(context).shadowColor,
                                  highlightColor: Theme.of(context).shadowColor,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DexScreen(generation: gen.number),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width/2,
                                        child: Text(
                                          "   Gen. ${gen.text}",
                                          style: Theme.of(context).textTheme.titleLarge,
                                          textAlign: TextAlign.left,
                                        ),
                                      )
                                    ],
                                  )
                                ),
                              ),

                              const Divider(
                                height: 5,
                                thickness: 5,
                                indent: 10,
                                endIndent: 10,
                              ),
                            ],
                          )
                      );
                  }).toList(),
                ),
                const Spacer(),
              ],
            )

    );
  }
}