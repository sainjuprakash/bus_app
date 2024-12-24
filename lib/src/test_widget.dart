import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DraggableSheetWithHandle extends StatelessWidget {
  const DraggableSheetWithHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Draggable Sheet with Handle"),
      ),
      body: Center(
        child: const Text(
          "Pull up from the bottom!",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      bottomSheet: DraggableScrollableSheet(
        initialChildSize: 0.05, // Initial size is small
        minChildSize: 0.05, // Minimum size (almost hidden, but draggable)
        maxChildSize: 0.6, // Max expanded size
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Column(
              children: [
                // Draggable handle (bold horizontal line)
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  height: 5,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Scrollable content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: const [
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text("Option 1"),
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Option 2"),
                      ),
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text("Option 3"),
                      ),
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text("Option 4"),
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Option 5"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
