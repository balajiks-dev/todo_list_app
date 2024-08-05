import 'package:flutter/material.dart';

@immutable
abstract class CompleteTaskEvent {}

class MarkAsCompleteTask extends CompleteTaskEvent {}