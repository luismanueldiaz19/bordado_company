import 'package:flutter/material.dart';
import '/src/datebase/current_data.dart';
// import '/src/datebase/methond.dart';
// import '/src/datebase/url.dart';
import '/src/model/report_admin.dart';
import '/src/nivel_2/forder_sublimacion/model_nivel/sublima.dart';
import '/src/util/show_mesenger.dart';
import '/src/widgets/custom_app_bar.dart';

import '../datebase/methond.dart';
import '../datebase/url.dart';

class AddReportItemMaster extends StatefulWidget {
  const AddReportItemMaster({Key? key, required this.list, this.current})
      : super(key: key);
  final List<Sublima> list;
  final ReportAdmin? current;
  @override
  State<AddReportItemMaster> createState() => _AddReportItemMasterState();
}

class _AddReportItemMasterState extends State<AddReportItemMaster> {
  String _coment = '';
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future sendData() async {
    if (_coment.isNotEmpty) {
      // setState(() {
      //   isLoading = true;
      // });
      var data = {
        'id_key_revision': widget.current?.idKeyRevision.toString(),
        'type_work':
            '${widget.list.first.nameWork.toString() != 'null' ? widget.list.first.nameWork.toString() : widget.list.first.nameDepartment.toString()} : Depart : ${widget.list.first.nameDepartment.toString()}',
        'cant_work': widget.list.length.toString(),
        'comment': '$_coment-- Por : ${currentUsers?.fullName}',
      };
      // print(data);
      await httpRequestDatabase(insertRevisionReportedItems, data);
      // print(res.body);

      // updatedFrom();

      if (mounted) Navigator.pop(context);
    } else {
      if (mounted) {
        utilShowMesenger(context, 'Tiene que escribir un comentario');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.current?.idKeyRevision);
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Reportar'),
          isLoading
              ? const Center(child: Text('Enviando...'))
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Comentario'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Comentario';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _coment = value!;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              sendData();
                            }
                          },
                          child: const Text('Reportar'),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
