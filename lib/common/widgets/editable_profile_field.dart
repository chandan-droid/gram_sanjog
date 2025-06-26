import 'package:flutter/material.dart';

class EditableProfileField extends StatefulWidget{
  final String label;
  final String value;
  final Function(String) onEdit;

  const EditableProfileField({
    super.key,
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  State<StatefulWidget> createState() => _EditableProfileFieldState();
}

class _EditableProfileFieldState extends State<EditableProfileField> {

  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      title: Text(widget.label, style: const TextStyle(color: Colors.black)),
      subtitle: isEditing
          ? TextField(
        controller: _controller,
        autofocus: true,
        onSubmitted: (newValue) {
          setState(() {
            isEditing = false;
            widget.onEdit(newValue);
          });
        },
      )
          : Text(
        widget.value.isNotEmpty ? widget.value : "Not Provided",
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: IconButton(
        icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.grey),
        onPressed: () {
          setState(() {
            if (isEditing) {
              widget.onEdit(_controller.text);
            }
            isEditing = !isEditing;
          });
        },
      ),
    );
  }
}