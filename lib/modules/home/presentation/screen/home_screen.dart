import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/config/colors.dart';
import 'package:todo_list_app/config/styles.dart';
import 'package:todo_list_app/config/widgets/custom_progress_bar.dart';
import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:todo_list_app/modules/add_task/presentation/screen/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> taskList = [];
  int completedTaskCount = 0;
  int pendingTaskCount = 0;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(GetTaskList()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is ShowProgressBar) {
            CustomProgressBar(context).showLoadingIndicator();
          } else if (state is ShowTaskList) {
            CustomProgressBar(context).hideLoadingIndicator();
            taskList = state.taskList;
            completedTaskCount = state.completedTaskCount;
            pendingTaskCount = state.pendingTaskCount;
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.eventBackGroundColor,
                centerTitle: true,
                title: Text(
                  AppConstants.cgiToDoList,
                  style: TextStyles.whiteBold16,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: AppColors.eventBackGroundColor,
                  foregroundColor: Colors.black,
                  child: const Icon(
                    Icons.add_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddTaskScreen(),
                      ),
                    );
                  }),
              body: taskList.isNotEmpty
                  ? ListView.builder(
                      itemCount: taskList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.fromLTRB(
                                      20.0, 0.0, 20.0, 0.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Color.fromRGBO(240, 240, 240, 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  child: Center(
                                    child: Text(
                                        'You have [ $pendingTaskCount ] pending task out of [ $completedTaskCount ]',
                                        style: TextStyles.whiteBold16),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return _buildTaskView(taskList[index - 1]);
                      },
                    )
                  : Center(
                      child: Text(
                        AppConstants.noTaskListFound,
                        style: TextStyles.blackRegular14,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskView(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          if (task.status == 0)
            ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
                subtitle: Text(
                  '${_dateFormatter.format(task.date ?? DateTime.now())} • ${task.priority}',
                  style: TextStyle(
                    fontSize: 15.0,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
                trailing: Checkbox(
                  onChanged: (value) {
                    if (value != null) {
                      task.status = value ? 1 : 0;
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value: task.status == 1 ? true : false,
                ),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) =>
                  //         AddTaskScreen(
                  //           updateTaskList: _updateTaskList,
                  //           task: task,
                  //         ),
                  //   ),
                  // );
                }),
          //Divider(),
        ],
      ),
    );
  }
}
