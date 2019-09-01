import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kanban_flutter/task_widget.dart';

import 'bar_target.dart';

/// This widget displays the actual
/// boards. It is passed which boards exist
/// and which tasks they contain.
class Boards extends StatefulWidget {
  final Map<String, List<String>> boards;

  const Boards({Key key, this.boards}) : super(key: key);
  @override
  _BoardsState createState() => _BoardsState();
}

class _BoardsState extends State<Boards> {
  var dragging = false;

  @override
  Widget build(BuildContext context) {
    /// On mobile devices, the boards will scroll horizontally
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            children: widget.boards.keys

                /// Each board is a DragTarget, so that tasks can be moved
                .map((name) => DragTarget<List<String>>(
                      onWillAccept: (data) => true,

                      /// Actually moving tasks happens here. The payload of a task is a List<String> which contains
                      /// the task's contents and its category
                      onAccept: (data) {
                        setState(() {
                          widget.boards[data[1]].remove(data[0]);
                          widget.boards[name].add(data[0]);
                        });
                      },
                      builder: (context, candidateData, rejectedData) =>
                          Container(
                        decoration:
                            BoxDecoration(border: Border(right: BorderSide())),

                        /// A board's with is at least 200 logical pixels
                        /// or 1/number of boards of the entire screen width
                        width: max(
                            MediaQuery.of(context).size.width /
                                widget.boards.keys.length,
                            200),
                        child: ListView(
                          children: <Widget>[
                            ListTile(title: Text(name)),
                            Divider(
                              color: Colors.black,
                            ),
                            ...widget.boards[name].map(
                              /// The callbacks are used to determine if the Delete Space should be shown
                              (t) => TaskWidget(
                                data: [t, name],
                                dragStartedCallback: () =>
                                    setState(() => dragging = true),
                                dragEndCallback: (details) =>
                                    setState(() => dragging = false),
                                width: max(
                                    (MediaQuery.of(context).size.width /
                                            widget.boards.keys.length) +
                                        20,
                                    220),
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
          if (dragging)
            BarTarget<List<String>>(
              width: max(MediaQuery.of(context).size.width,
                  widget.boards.keys.length * 200.0),
              height: 64,
              color: Colors.red,
              child: Icon(Icons.delete),
              onAccept: (data) {
                widget.boards[data[1]].remove(data[0]);
              },
            ),
        ],
      ),
    );
  }
}
