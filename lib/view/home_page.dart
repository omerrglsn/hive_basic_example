import 'package:flutter/material.dart';
import 'package:hive_example/model/item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box<Item> box = Hive.box('item');

    TextEditingController titleController = TextEditingController();
    TextEditingController countController = TextEditingController();

    // CRUD
    Future<void> add(Item value) async {
      await box.add(value);
    }

    Future<void> remove(int index) async {
      await box.deleteAt(index);
    }
    // CRUD

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (BuildContext context, dynamic value, Widget? child) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (BuildContext context, int index) {
              final items = box.getAt(index) as Item;
              return Card(
                child: ListTile(
                  title: Text('${items.title} ${items.count.toString()}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_outlined),
                    onPressed: () {
                      _showDialog(context, items, remove, index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _modalBottomSheet(context, titleController, countController, add);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, Item items, Future<void> Function(int index) remove, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(items.title),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close')),
            TextButton(
              onPressed: () {
                remove(index);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _modalBottomSheet(BuildContext context, TextEditingController titleController,
      TextEditingController countController, Future<void> Function(Item value) add) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  keyboardType: TextInputType.name,
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: countController,
                  decoration: const InputDecoration(hintText: 'Count', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        titleController.clear();
                        countController.clear();
                      },
                      child: const Text('Close'),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (countController.text.isNotEmpty && titleController.text.isNotEmpty) {
                          add(Item(title: titleController.text, count: int.tryParse(countController.text)!));
                        }

                        titleController.clear();
                        countController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
