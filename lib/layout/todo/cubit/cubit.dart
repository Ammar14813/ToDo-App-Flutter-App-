import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/todo/cubit/states.dart';
import 'package:todo_app/modules/archived_task/archived_task.dart';
import 'package:todo_app/modules/done_task/done_task_screen.dart';
import 'package:todo_app/modules/new_task/new_task_screen.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> currentScreen = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> screenTitle = [
    'New Task',
    'Done Task',
    'Archived Task',
  ];

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];


  void createDatabase(){
    openDatabase(
      'Tasks.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute('CREATE TABLE tasks ('
            'id INTEGER PRIMARY KEY , title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error When Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDateFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title ,
    required String time ,
    required String date ,
  }) async{
    await database.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDateFromDatabase(database);
      }).catchError((error) {
        print("Error When Inserting New Record ${error.toString()}");
      });
    });
  }

  void getDateFromDatabase(database){

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppLoadingDatabaseState());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element){
        if (element['status'] == 'new'){
          newTasks.add(element);
        }else if (element['status'] == 'done'){
          doneTasks.add(element);
        }else{
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
  required String status ,
  required int id
}) {
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {

     }).then((value){
       getDateFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });
  }

  void deleteDatabase({
    required int id
  }) {
    database.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value){
      getDateFromDatabase(database);
      emit(AppDeletedDatabaseState());
      print('Task ${id} is Removed !');
    });
  }

  bool bottomSheetShown = false;
  IconData bsIcon = Icons.edit;

  void changeBottomSheetState({
  required bool isShow,
    required IconData icon
}){
    bottomSheetShown = isShow;
    bsIcon = icon;
    emit(AppChangeBottomSheetState());
  }

}
