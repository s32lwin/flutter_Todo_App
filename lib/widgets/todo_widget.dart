
import 'package:flutter/material.dart';
import 'package:storage/model/todo.dart';


class CreateToDoWidget extends StatefulWidget {
  final Todo? todo;
  final ValueChanged<String> onSubmit;

  const CreateToDoWidget({
    Key? key,
    this .todo,
    required this.onSubmit,
  }) : super (key:key);

@override
State<CreateToDoWidget> createState()=>_CreateToDoWidgetState();
  }

 class _CreateToDoWidgetState extends State <CreateToDoWidget>{
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();


    @override
    void initState(){
      super.initState();

      controller.text=widget.todo?.title??'';
    }
    @override
    
  Widget build(BuildContext context){
    final isEditing = widget.todo != null;
    return AlertDialog(
      title: Text(isEditing?'Edit Todo': 'Add Todo'),
      content: Form(
      key: formKey,
      child: TextFormField(
        autofocus: true,
        controller: controller,
        decoration: const InputDecoration(hintText: 'add task'),
        validator: (value)=>
        value !=null && value.isEmpty? 'Title id required':null
      ),
      ),
      actions: [
        TextButton(onPressed: () =>Navigator.pop(context),
         child: const Text('cancel' ),
         ),
         TextButton(onPressed: (){
          if (formKey.currentState!.validate()){ 
          widget.onSubmit(controller.text);
             }
          }, 
         child: const Text('Ok'),
         )
      ],
    );
  }
 }   