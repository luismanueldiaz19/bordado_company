import 'package:flutter/material.dart';

class CommentDialogDemo extends StatefulWidget {
  @override
  _CommentDialogDemoState createState() => _CommentDialogDemoState();
}

class _CommentDialogDemoState extends State<CommentDialogDemo> {
  final TextEditingController _commentController = TextEditingController();

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enviar un comentario'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: 'Escribe tu comentario aquí'),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Enviar'),
              onPressed: () {
                // Aquí puedes enviar el comentario, por ejemplo, a través de una API
                String comment = _commentController.text;
                // Lógica para enviar el comentario
                print('Comentario enviado: $comment');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentario Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showCommentDialog(context);
          },
          child: Text('Enviar Comentario'),
        ),
      ),
    );
  }
}
