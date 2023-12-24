import 'package:flutter/material.dart';
import 'package:goods_transport/Widegts/custom_text_field.dart';

class AddTextFieldWidget extends StatefulWidget {
  const AddTextFieldWidget({Key? key}) : super(key: key);

  @override
  State<AddTextFieldWidget> createState() => _AddTextFieldWidgetState();
}

class _AddTextFieldWidgetState extends State<AddTextFieldWidget> {
  List<Widget> _children = [];
  List<TextEditingController> controllers = []; //the controllers list
  int _count = 0;

  List<TextEditingController> dropOffControllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Title"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: (){
            setState(() {
              dropOffControllers.add(TextEditingController());
            });
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 1; i < dropOffControllers.length && i <= 6; i++)
              SizedBox(
                width: 250,
                height: 60,
                child: CustomTextField(
                  hintText: 'Lahore no ${i + 1}',
                  controller: dropOffControllers[i],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Display the first text field by default
    _add();
  }

  void _add() {
    if (_count < 6) {
      TextEditingController controller = TextEditingController();
      controllers.add(controller);

      for (int i = 0; i < controllers.length; i++) {
        print(controllers[i].text);
      }

      _children = List.from(_children)
        ..add(CustomTextField(
          controller: controller,
          hintText: "Drop Off $_count",
        ));

      setState(() => ++_count);
    } else {
      // Optionally, you can display a message or take some action
      print("Cannot add more than 6 text fields.");
    }
  }
}
