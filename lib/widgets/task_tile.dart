import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../blocs/bloc_exports.dart';
import '../models/task.dart';
import '../screens/edit_task_screen.dart';
import 'popup_menu.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
  });

  final Task task;

  void _removeOrDeleteTask(BuildContext ctx, Task task) {
    task.isDeleted!
        ? ctx.read<TasksBloc>().add(DeleteTask(task: task))
        : ctx.read<TasksBloc>().add(RemoveTask(task: task));
  }

  void _editTask(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditTaskScreen(oldTask: task),
        ),
      ),
    );
  }

  DateTime _parseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (e) {
      //print('Error parsing date: $e');
      return DateTime.now(); // Provide a fallback date/time
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                task.isFavorite == false
                    ? const Icon(Icons.star_outline)
                    : const Icon(Icons.star),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          decoration:
                              task.isDone! ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        //DateFormat().add_yMEd().format(DateTime.now()),
                        //DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now()),
                        // DateFormat()
                        //     .add_yMMMd()
                        //     .add_Hms()
                        //     .format(DateTime.now()),
                        DateFormat()
                            .add_yMMMd()
                            .add_Hms()
                            .format(_parseDate(task.date)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                onChanged: task.isDeleted == false
                    ? (value) {
                        context.read<TasksBloc>().add(UpdateTask(task: task));
                      }
                    : null,
                value: task.isDone,
              ),
              PopUpMenu(
                task: task,
                // onDelete: () => _removeOrDeleteTask(context, task),
                // onFavorite: () => context.read<TasksBloc>().add(
                //       MarkFavoriteOrUnfavoriteTask(task: task),
                //     ),
                // onEdit: () {
                //   Navigator.of(context).pop();
                //   _editTask(context);
                // },
                // onRestore: () =>
                //     context.read<TasksBloc>().add(RestoreTask(task: task)),

                cancelOrDeleteCallback: () =>
                    _removeOrDeleteTask(context, task),
                likeOrDislikeCallback: () => context.read<TasksBloc>().add(
                      MarkFavoriteOrUnfavoriteTask(task: task),
                    ),
                editTaskCallback: () {
                  Navigator.of(context).pop();
                  _editTask(context);
                },
                restoreTaskCallback: () =>
                    context.read<TasksBloc>().add(RestoreTask(task: task)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ListTile(
//       title: Text(
//         task.title,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//           decoration: task.isDone! ? TextDecoration.lineThrough : null,
//         ),
//       ),
//       trailing: 
//       onLongPress: 
//     );
