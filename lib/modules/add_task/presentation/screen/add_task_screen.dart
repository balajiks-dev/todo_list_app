import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/config/colors.dart';
import 'package:todo_list_app/config/dependency_injection/injection_container.dart';
import 'package:todo_list_app/config/styles.dart';
import 'package:todo_list_app/config/widgets/common_snack_bar.dart';
import 'package:todo_list_app/config/widgets/common_text_field.dart';
import 'package:todo_list_app/config/widgets/custom_progress_bar.dart';
import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_bloc.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_event.dart';
import 'package:todo_list_app/modules/add_task/presentation/bloc/add_task_state.dart';
import 'package:todo_list_app/modules/home/data/model/task_model.dart';
import 'package:todo_list_app/utils/remove_emoji_input_formatter.dart';
import 'dart:math';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => AddTaskScreenState();
}

@visibleForTesting
class AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  DateTime _date = DateTime.now();

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
      dateController.text = _dateFormatter.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddTaskBloc>(),
      child: BlocListener<AddTaskBloc, AddTaskState>(
        listener: (context, state) {
          if (state is ShowProgressBar) {
            CustomProgressBar(context).showLoadingIndicator();
          } else if (state is TaskAddedSuccess) {
            CustomProgressBar(context).hideLoadingIndicator();
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBarWidget("Task added successfully"));
            Navigator.pop(context, true);
          }
        },
        child: BlocBuilder<AddTaskBloc, AddTaskState>(
          builder: (context, state) {
            return Scaffold(
              key: const Key("addTaskScreenKey"),
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
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 72,
                                child: CommonTextField(
                                  controller: _titleController,
                                  hintText: "",
                                  labelText: AppConstants.title,
                                  isMandatory: true,
                                ),
                              ),
                              const SizedBox(height: 28),
                              InkWell(
                                onTap: _handleDatePicker,
                                child: SizedBox(
                                  height: 72,
                                  child: CommonTextField(
                                    controller: dateController,
                                    hintText: "",
                                    labelText: AppConstants.date,
                                    isMandatory: true,
                                    readOnly: true,
                                    //onTap: _handleDatePicker,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[+a-zA-Z0-9@._-]")),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  inputFormatters: [
                                    RemoveEmojiInputFormatter(),
                                  ],
                                  controller: _descriptionController,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.multiline,
                                  autocorrect: false,
                                  style: TextStyles.blackMedium14,
                                  maxLines: 5,
                                  maxLength: 250,
                                  decoration: InputDecoration(
                                    hintText: AppConstants.description,
                                    hintStyle: TextStyles.whiteRegular14
                                        .copyWith(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontWeight: FontWeight.w500),
                                    contentPadding: const EdgeInsets.only(
                                        top: 15,
                                        left: 10,
                                        right: 10,
                                        bottom: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 0.5,
                                          color: AppColors.greyColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 0.5,
                                          color: AppColors.greyColor),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      CustomProgressBar(context)
                                          .showLoadingIndicator();
                                      // BlocProvider.of<AddQuestionBloc>(context).add(PostButtonEnabled(isEnabled: false));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 28),
                              submitWidget(context),
                              const SizedBox(height: 28),
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

  Widget submitWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: ElevatedButton(
        key: const Key("addTaskSubmitKey"),
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromWidth(MediaQuery.of(context).size.width),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.eventBackGroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onPressed: () async {
          CustomProgressBar(context).showLoadingIndicator();
          int min = 1;
          int max = 100000;
          Random rnd = Random.secure();
          int randomInt = min + rnd.nextInt(max - min);
          BlocProvider.of<AddTaskBloc>(context).add(
            AddTaskTapped(
              taskModel: TaskModel(
                id: randomInt,
                title: _titleController.text,
                description: _descriptionController.text,
                date: _date,
                status: 0,
              ),
            ),
          );
        },
        child: Text(
          AppConstants.addTask,
          textAlign: TextAlign.center,
          style: TextStyles.blackButtonRegular14.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
