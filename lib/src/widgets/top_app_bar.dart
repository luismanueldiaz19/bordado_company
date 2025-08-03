import 'package:flutter/material.dart';
import '/src/home.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({Key? key, required this.press, this.modoOnLine})
      : super(key: key);
  final Function press;
  final bool? modoOnLine;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // print(size.width);
    var style = TextStyle(
        fontSize: size.width <= 600 ? 12 : 16,
        color: const Color.fromARGB(255, 0, 0, 0));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: size.width * 0.90,
            child: Material(
              color: const Color.fromARGB(244, 246, 244, 242),
              borderRadius: BorderRadius.circular(15.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (conext) => const MyHomePage()),
                              (route) => false);
                        },
                        child: Text('LuDeveloper Software', style: style)),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: modoOnLine! ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(50.0)),
                      ),
                      // const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => press(),
                        child: Text(
                          modoOnLine! ? 'En Linea' : 'Desconectado',
                          style: TextStyle(
                            color: modoOnLine! ? Colors.green : Colors.red,
                            fontSize: size.width <= 600 ? 12 : 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // const Padding(
                      //   padding: EdgeInsets.only(right: 2),
                      //   child: Text('@copyright 2021',
                      //       style: TextStyle(color: Colors.grey, fontSize: 13)),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
