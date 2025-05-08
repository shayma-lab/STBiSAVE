import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_first_project/models/objectif.dart';
import 'package:my_first_project/pages/client/objectif/objetif_details_page.dart';

class ObjectifWidget extends StatelessWidget {
  final Objectif objectif;
  final num index;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ObjectifWidget(
    this.objectif,
    this.index, {
    super.key,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObjetifDetailsPage(objectif.id),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Slidable(
            key: ValueKey(objectif.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => onEdit(),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (_) => onDelete(),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: ListTile(
              leading: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(objectif.name),
              trailing: Text(
                '${objectif.amount.toStringAsFixed(2)} DT',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
