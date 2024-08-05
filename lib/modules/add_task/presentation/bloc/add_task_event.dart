import 'package:flutter/material.dart';

@immutable
abstract class AddTaskEvent {}

class AddTaskTapped extends AddTaskEvent{}