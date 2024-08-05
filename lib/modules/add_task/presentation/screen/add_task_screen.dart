import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/config/colors.dart';
import 'package:todo_list_app/config/styles.dart';
import 'package:todo_list_app/config/widgets/common_snack_bar.dart';
import 'package:todo_list_app/config/widgets/custom_progress_bar.dart';
import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_bloc.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_event.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_state.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  DateTime _date = DateTime.now();
  String? _currentPriority;

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskBloc(),
      child: BlocListener<AddTaskBloc, AddTaskState>(
        listener: (context, state) {
          if (state is ShowProgressBar) {
            CustomProgressBar(context).showLoadingIndicator();
          } else if (state is TaskAddedSuccess){
            CustomProgressBar(context).hideLoadingIndicator();
            ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
              "Task added successfully"
            ));
          }
        },
        child: BlocBuilder<AddTaskBloc, AddTaskState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: AppColors.eventBackGroundColor,
                centerTitle: true,
                title: Text(
                  AppConstants.addToDoWork,
                  style: TextStyles.whiteBold16,
                ),
              ),
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  controller: _titleController,
                                  style: TextStyle(fontSize: 18.0),
                                  decoration: InputDecoration(
                                    labelText: 'Title',
                                    labelStyle: TextStyle(fontSize: 18.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (input) => input != null ? input.trim().isEmpty
                                      ? 'Please enter a task title'
                                      : null : null,
                                  onSaved: (input) => _titleController.text = input ?? "",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _dateController,
                                  style: const TextStyle(fontSize: 18.0),
                                  onTap: _handleDatePicker,
                                  decoration: InputDecoration(
                                    labelText: 'Date',
                                    labelStyle: TextStyle(fontSize: 18.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: DropdownButtonFormField(
                                  isDense: true,
                                  icon: Icon(Icons.arrow_drop_down_circle),
                                  iconSize: 22.0,
                                  iconEnabledColor: Theme.of(context).primaryColor,
                                  items: _priorities.map((String priority) {
                                    return DropdownMenuItem(
                                      value: priority,
                                      child: Text(
                                        priority,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  style: TextStyle(fontSize: 18.0),
                                  decoration: InputDecoration(
                                    labelText: 'Priority',
                                    labelStyle: TextStyle(fontSize: 18.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  validator: (input) => _currentPriority == null
                                      ? 'Please select a priority level'
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      _currentPriority = value;
                                    });
                                  },
                                  value: _currentPriority,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<AddTaskBloc>(context).add(AddTaskTapped());
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  height: 60.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  // ignore: deprecated_member_use
                                    child: Text(
                                      'Add',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),

                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
