import 'package:flutter/material.dart';

class WidgetPlan extends StatelessWidget {
  const WidgetPlan({super.key});

  @override
  Widget build(BuildContext context) {
    List planList = [1, 2, 3, 4];
    return Container(
      alignment: Alignment.center,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: planList.length,
          itemBuilder: (context, index) {
            final current = planList[index];
            return current == planList.first
                ? Container(
                    alignment: Alignment.center,
                    width: 200,
                    child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar Nuevo')))
                : Container(
                    width: 200,
                    padding: const EdgeInsets.all(15.0),
                    margin: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.clear_all_outlined),
                            SizedBox(width: 5),
                            Text(
                              'Logo Martines',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Text('25,526'),
                        const Text('2022/02/10'),
                        TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.wb_cloudy_outlined),
                            label: const Text('ver'))
                      ],
                    ),
                  );
          }),
    );
  }
}
