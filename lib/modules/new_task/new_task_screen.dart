import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/components.dart';
import 'package:todo_app/layout/todo/cubit/cubit.dart';
import 'package:todo_app/layout/todo/cubit/states.dart';


class NewTaskScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
        listener: (context , state){},
        builder: (context , state){

          var tasks = AppCubit.get(context).newTasks;
          return taskBuilder(
            tasks : tasks ,
          );
        },
    );
  }
}
