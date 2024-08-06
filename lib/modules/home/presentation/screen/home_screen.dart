import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/config/colors.dart';
import 'package:todo_list_app/config/dependency_injection/injection_container.dart';
import 'package:todo_list_app/config/styles.dart';
import 'package:todo_list_app/config/widgets/custom_progress_bar.dart';
import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_bloc.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_event.dart';
import 'package:todo_list_app/modules/complete_task/presentation/bloc/complete_task_state.dart'
    as completed_task_state;
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:todo_list_app/modules/add_task/presentation/screen/add_task_screen.dart';
import 'package:todo_list_app/modules/home/presentation/bloc/home_event.dart';
import 'package:todo_list_app/modules/task_filter/presentation/task_filter_screen.dart';

import '../bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> taskList = [];
  int completedTaskCount = 0;
  int pendingTaskCount = 0;
  List<TaskModel> filterTaskList = [];
  bool isFilter = false;
  String status = '';
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<HomeBloc>()..add(GetTaskList())
        ),
        BlocProvider(
          create: (context) => CompleteTaskBloc(),
        ),
      ],
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
        child: BlocListener<CompleteTaskBloc,
            completed_task_state.CompleteTaskState>(
          listener: (context, state) {
            if (state is completed_task_state.ShowProgressBar) {
              CustomProgressBar(context).showLoadingIndicator();
            } else if (state is completed_task_state.MarkedAsCompletedSuccess) {
              CustomProgressBar(context).hideLoadingIndicator();
              taskList = state.taskList;
              completedTaskCount = state.completedTaskCount;
              pendingTaskCount = state.pendingTaskCount;
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return BlocBuilder<CompleteTaskBloc,
                  completed_task_state.CompleteTaskState>(
                builder: (context, state) {
                  return Scaffold(
                    key: const Key("homeScreenKey"),
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
                        key: const Key("addTaskButtonKey"),
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
                          ).then((value) {
                            if (value != null && value!) {
                              BlocProvider.of<HomeBloc>(context)
                                  .add(GetTaskList());
                            }
                          });
                        }),
                    body: taskList.isNotEmpty
                        ? ListView.builder(
                            itemCount:isFilter?filterTaskList.length+1: taskList.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0, vertical: 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  20.0, 10.0, 10.0, 0.0),
                                              padding: const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: pendingTaskCount != 0
                                                    ? AppColors
                                                        .eventBackGroundColor
                                                    : Colors.green,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10.0)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                    pendingTaskCount != 0
                                                        ? 'You have [ $pendingTaskCount ] pending task out of [ ${completedTaskCount + pendingTaskCount} ]'
                                                        : 'Congratulations! You have completed all the tasks.',
                                                    style: TextStyles
                                                        .whiteRegular14),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: (){
                                              showModalBottomSheet<String>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return  TaskFilterScreen(selectedStatus: status);
                                                },
                                              ).then((String? value) {
                                                if (value != null&&value.isNotEmpty) {
                                                  status = value;
                                                  int filterStatus = value== "Completed"?1:0;
                                                  filterTaskList = taskList.where((task) => task.status == filterStatus).toList();
                                                  isFilter =true;
                                                }else{
                                                  status = '';
                                                  isFilter =false;
                                                }
                                                setState(() {});
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Container(
                                                padding: const EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  color: AppColors
                                                      .eventBackGroundColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10.0)),
                                                ),
                                                child: const Icon(
                                                  Icons.filter_alt_rounded,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.album_rounded,
                                                  color: AppColors
                                                      .eventBackGroundColor,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  AppConstants.pending,
                                                  style:
                                                      TextStyles.blackMedium14,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.album_rounded,
                                                  color: Colors.green,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  AppConstants.completed,
                                                  style:
                                                      TextStyles.blackMedium14,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return _buildTaskView(
                                 isFilter?filterTaskList[index-1]: taskList[index - 1], context);
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
              );
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
                      ).then((value) {
                        if (value != null && value!) {
                          BlocProvider.of<HomeBloc>(context).add(GetTaskList());
                        }
                      });
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
                                        20.0, 10.0, 20.0, 0.0),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: AppColors.eventBackGroundColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                          'You have [ $pendingTaskCount ] pending task out of [ ${completedTaskCount + pendingTaskCount} ]',
                                          style: TextStyles.whiteRegular14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.album_rounded,
                                              color: AppColors
                                                  .eventBackGroundColor,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              AppConstants.pending,
                                              style: TextStyles.blackMedium14,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.album_rounded,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              AppConstants.completed,
                                              style: TextStyles.blackMedium14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return _buildTaskView(taskList[index - 1], context);
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
      ),
    );
  }

  Widget _buildTaskView(TaskModel task, BuildContext context) {
    return Padding(
      key: const Key("taskTileKey"),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.eventBackGroundColor,
            width: 0.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Text(
                      task.title ?? "",
                      style: TextStyles.blackBold14,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text(
                      task.date != null
                          ? _dateFormatter.format(task.date!)
                          : "",
                      style: TextStyles.blackMedium14,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text(
                      task.description ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.blackRegular14,
                      maxLines: 2,
                    ),
                  ),
                  Visibility(
                    visible: task.status != null && task.status! == 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: InkWell(
                        key: const Key("markAsCompletedButtonKey"),
                        onTap: () {
                          BlocProvider.of<CompleteTaskBloc>(context).add(
                            MarkAsCompleteTask(
                                taskList: taskList, markedCompletedTask: task),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.eventBackGroundColor,
                              )),
                          child: Text(
                            AppConstants.markAsCompleted,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.blackMedium14,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            task.status != null
                ? task.status == 0
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Icon(
                          Icons.album_rounded,
                          color: AppColors.eventBackGroundColor,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Icon(
                          Icons.album_rounded,
                          color: Colors.green,
                        ),
                      )
                : Container()
          ],
        ),
      ),
    );
  }
}
