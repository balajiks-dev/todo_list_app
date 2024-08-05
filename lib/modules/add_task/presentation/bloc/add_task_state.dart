import 'package:flutter/material.dart';

@immutable
abstract class AddTaskState {}

class AddTaskInitial extends AddTaskState {}

class TaskAddedState extends AddTaskState {}

class ShowProgressBar extends AddTaskState {}

class TaskAddedSuccess extends AddTaskState {}