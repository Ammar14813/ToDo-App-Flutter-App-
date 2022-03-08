import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'package:todo_app/layout/todo/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color backgroundColor = Colors.blue,
  bool isUpperCase = true,
  double radius = 25.0,
  required Function onPress,
  required String text,
}) =>
    Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: () {
          onPress();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function?  onTap,
  bool isPassword = false,
  required String validate,
  required String label,
  required IconData prefix,
  IconButton? suffix,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: (value) {
        if (value == null || value.isEmpty){
          onSubmit??(value);
        }else{
          onSubmit??(value);
        }
      },
      onChanged: (value) {
        if (value == null || value.isEmpty){
          onChange??(value);
        }else{
          onChange??(value);
        }
      },
      onTap: (){
        onTap!();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$validate';
        }else{
          return null ;
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );

// buildTaskItem use for delete any item in list by swap it right or left
Widget buildTaskItem(Map model , context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteDatabase(id: model['id']);
  },
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(

      mainAxisSize: MainAxisSize.min,

      children: [

        CircleAvatar(

          radius: 40,

          child: Text(

              '${model['time']}',

          ),

        ),

        SizedBox(width: 20,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontWeight: FontWeight.bold,

                  fontSize: 20,

                ),

              ),

              SizedBox(

                height: 5,),

              Text(

                '${model['date']}',

                style: TextStyle(

                    color: Colors.grey

                ),),

            ],

          ),

        ),

        SizedBox(width: 20,),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateDatabase(status: 'done', id: model['id']);

            },

            icon: Icon(Icons.check_box , color: Colors.green,),

        ),

        SizedBox(width: 20,),

        IconButton(

          onPressed: (){

            AppCubit.get(context).updateDatabase(status: 'archived', id: model['id']);

          },

          icon: Icon(Icons.archive , color: Colors.grey,),

        ),

      ],

    ),

  ),
);

// taskBuilder use for creating list of tasks that waiting the coming data
Widget taskBuilder({required List<Map> tasks}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context , index) => buildTaskItem(tasks[index] , context),
    separatorBuilder: (context , index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu , size: 70,color: Colors.grey,
        ),
        SizedBox(height: 7,),
        Text(
          'Please Add Tasks !',
          style: TextStyle(
            fontSize: 20 , color : Colors.grey,
          ),
        ),
      ],
    ),
  ),

);

// myDivider use for the divider line that separate the list Items
Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);


// method navigateTo
void navigateTo(context , widget) => Navigator.push(
  context,
  MaterialPageRoute(
      builder: (context) => widget,
  ),
);