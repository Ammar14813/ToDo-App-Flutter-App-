import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/components.dart';
import 'package:todo_app/layout/todo/cubit/cubit.dart';
import 'package:todo_app/layout/todo/cubit/states.dart';

class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit , AppStates>(
        listener: (context , state){
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context , state){

          AppCubit cubit = BlocProvider.of(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.screenTitle[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
                condition: state is! AppLoadingDatabaseState,
                builder: (context) => cubit.currentScreen[cubit.currentIndex] ,
                fallback: (context) => Center(child: CircularProgressIndicator()) ,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.bottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                      padding: const EdgeInsets.all(20.00),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: 'Title must not be empty!',
                                label: 'Task Title',
                                prefix: Icons.title,
                                onTap: (){
                                  return '';
                                }
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            defaultFormField(
                              controller: timeController,
                              type: TextInputType.datetime,
                              validate: 'Time must not be empty!',
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                });
                              },
                              label: 'Task Time',
                              prefix: Icons.timer_outlined,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            defaultFormField(
                              controller: dateController,
                              type: TextInputType.datetime,
                              validate: 'Date must not be empty!',
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-03-16'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                });
                              },
                              label: 'Task Date',
                              prefix: Icons.calendar_today,
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add);
                }
              },
              child: Icon(cubit.bsIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {

              cubit.changeIndex(index);

              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived Tasks'),
              ],
            ),
          );
        },
      ),
    );
  }

  }
