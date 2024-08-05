import 'package:flutter/material.dart';

@immutable
abstract class CompleteTaskState {}

class AddTaskInitial extends CompleteTaskState {}

class TaskAddedState extends CompleteTaskState {}

class ShowProgressBar extends CompleteTaskState {}