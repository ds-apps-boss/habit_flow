import 'package:flutter/material.dart';
import 'package:habit_flow/core/models/habit.dart';

class ItemList extends StatelessWidget {
  const ItemList({
    super.key,
    required this.items,
    required this.isDoneToday,
    required this.onToggleDoneToday,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Habit> items;

  final bool Function(Habit habit) isDoneToday;
  final Future<void> Function(Habit habit) onToggleDoneToday;
  final Future<void> Function(Habit habit, String newName) onEdit;
  final Future<void> Function(Habit habit) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final habit = items[index];
        final done = isDoneToday(habit);

        return ListTile(
          leading: IconButton(
            icon: Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
            ),
            onPressed: () => onToggleDoneToday(habit),
          ),
          title: Text(habit.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  final editController = TextEditingController(
                    text: habit.name,
                  );

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Task bearbeiten'),
                      content: TextField(
                        autofocus: true,
                        controller: editController,
                        decoration: const InputDecoration(
                          hintText: 'Task bearbeiten',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Abbrechen'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await onEdit(habit, editController.text);
                            if (context.mounted) Navigator.of(context).pop();
                          },
                          child: const Text('Speichern'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete(habit),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) =>
          const Divider(thickness: 1, color: Colors.white10),
    );
  }
}
