import 'package:flutter/material.dart';

typedef void DragEndCallback(DraggableDetails details);

class TaskWidget extends StatelessWidget {
  final List<String> data;
  final VoidCallback dragStartedCallback;
  final DragEndCallback dragEndCallback;
  final double width;

  const TaskWidget(
      {Key key,
      @required this.data,
      @required this.dragStartedCallback,
      @required this.dragEndCallback,
      @required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<List<String>>(
      data: data,
      onDragStarted: dragStartedCallback,
      onDragEnd: dragEndCallback,
      feedback: Container(
        width: width + 20,
        height: 64,
        child: Card(
          elevation: 4,
          child: ListTile(
            title: Text(data[0]),
          ),
        ),
      ),
      child: Container(
        width: width,
        height: 64,
        child: Card(
          child: ListTile(
            title: Text(data[0]),
          ),
        ),
      ),
      childWhenDragging: Container(),
    );
  }
}
