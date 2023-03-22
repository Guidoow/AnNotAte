// ignore_for_file: overridden_fields, prefer_typing_uninitialized_variables

import 'package:drift/native.dart' as native;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as dft;
import 'package:startup_namer/dbCode.dart';
import 'package:drift/isolate.dart';
import 'package:http/http.dart' as http;

dft.DatabaseConnection _backgroundConnection() {
  final database = native.NativeDatabase.memory();
  return dft.DatabaseConnection.fromExecutor(database);
}

Future<dft.DatabaseConnection> _connectAsync() async {
  DriftIsolate isolate = await DriftIsolate.spawn(_backgroundConnection);
  return isolate.connect();
}

void main() async {
  final db =
      MyDatabase.connect(dft.DatabaseConnection.delayed(_connectAsync()));

  runApp(MyApp(db: db));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.db}) : super(key: key);

  TextEditingController controlTitle = TextEditingController();
  TextEditingController controlBody = TextEditingController();
  TextEditingController controlColor = TextEditingController();

  final MyDatabase db;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(
          db: db,
          controlBody: controlBody,
          controlTitle: controlTitle,
          controlColor: controlColor),
      routes: {
        '/home': (context) => Home(
              db: db,
              controlBody: controlBody,
              controlTitle: controlTitle,
              controlColor: controlColor,
            ),
        '/new': (context) => NotaNew(
            db: db,
            controlBody: controlBody,
            controlTitle: controlTitle,
            controlColor: controlColor),
      },
    );
  }
}

class NotaNew extends StatefulWidget {
  const NotaNew({
    Key? key,
    required this.db,
    required this.controlTitle,
    required this.controlBody,
    required this.controlColor,
  }) : super(key: key);

  final db;

  final controlBody;

  final controlTitle;

  final controlColor;

  @override
  State<NotaNew> createState() => _NotaNewState();
}

class _NotaNewState extends State<NotaNew> {
  // ignore: prefer_final_fields
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _selectedColor = Colors.white;
  }

  var _selectedColor;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.black),
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Note creation"),
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: const Color.fromARGB(255, 70, 70, 70),
                iconSize: 30.0,
                onPressed: () async {
                  await Navigator.pushNamed(context, '/home').then((value) => {
                        setState(() {
                          widget.controlTitle.text = "";
                          widget.controlBody.text = "";
                          widget.controlColor.text = "";
                        })
                      });
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  color: const Color.fromARGB(255, 70, 70, 70),
                  iconSize: 37.0,
                  onPressed: () async {
                    final entity = NottCompanion(
                      title: dft.Value(widget.controlTitle.text as String),
                      body: dft.Value(widget.controlBody.text as String),
                      color: dft.Value(widget.controlColor.text as String),
                    );
                    await widget.db.insertNott(entity).then((value) => {
                          widget.controlTitle.text = "",
                          widget.controlBody.text = "",
                          widget.controlColor.text = "",
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  width: 150,
                                  content: Text(
                                    'Created!',
                                    textAlign: TextAlign.center,
                                  ),
                                  duration: Duration(seconds: 2))),
                          Navigator.pushNamed(context, '/home'),
                        });
                  },
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                color: _selectedColor,
              ),
              child: Column(children: [
                Container(
                  key: UniqueKey(),
                  child: TextField(
                    maxLines: 1,
                    decoration: const InputDecoration(
                        hintText: "Title",
                        hintStyle: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w400),
                        icon: Icon(Icons.arrow_right),
                        border: InputBorder.none),
                    controller: widget.controlTitle,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  height: 15.0,
                  color: Color.fromARGB(255, 150, 150, 150),
                  thickness: 3.0,
                ),
                Container(
                  key: UniqueKey(),
                  child: TextField(
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: "Body",
                          prefixIcon: Icon(Icons.arrow_right),
                          border: InputBorder.none),
                      controller: widget.controlBody),
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 190, 190, 190),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(255, 190, 190, 190),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(255, 190, 190, 190),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(255, 190, 190, 190);
                                }),
                                widget.controlColor.text = "grey"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 255, 105, 97),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(150, 255, 105, 97),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(150, 255, 105, 97),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(150, 255, 105, 97);
                                }),
                                widget.controlColor.text = "red"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 189, 236, 182),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(255, 189, 236, 182),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(255, 189, 236, 182),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(255, 189, 236, 182);
                                }),
                                widget.controlColor.text = "green"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 119, 158, 203),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(211, 119, 158, 203),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(211, 119, 158, 203),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(211, 119, 158, 203);
                                }),
                                widget.controlColor.text = "blue"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 253, 253, 150),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(255, 253, 253, 150),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(255, 253, 253, 150),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(255, 253, 253, 150);
                                }),
                                widget.controlColor.text = "yellow"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 204, 169, 221),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(255, 204, 169, 221),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(255, 204, 169, 221),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(255, 204, 169, 221);
                                }),
                                widget.controlColor.text = "violet"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                      ],
                    )),
              ]),
            )));
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.db,
    required this.controlTitle,
    required this.controlBody,
    required this.controlColor,
  }) : super(key: key);
  final db;

  final controlTitle;

  final controlBody;

  final controlColor;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.add_rounded,
            color: Color.fromARGB(255, 70, 70, 70),
          ),
          onPressed: () async {
            await Navigator.pushNamed(context, '/new');
          },
          tooltip: 'Add Note',
          iconSize: 40.0,
        ),
        title: Container(
          alignment: Alignment.center,
          child: const Text("Notes"),
        ),
      ),
      body: Scaffold(
        body: Nota(
          db: widget.db,
          controlBody: widget.controlBody,
          controlTitle: widget.controlTitle,
          controlColor: widget.controlColor,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}

class Nota extends StatefulWidget {
  Nota({
    Key? key,
    required this.db,
    required this.controlTitle,
    required this.controlBody,
    required this.controlColor,
  }) : super(key: key);

  final List notex = [];
  final db;
  final controlBody;
  final controlTitle;
  final controlColor;
  @override
  State<Nota> createState() => _NotaState();
}

class _NotaState extends State<Nota> {
  List notex = [];

  _rip(index) {
    var col = notex.elementAt(index)["color"].toString();
    if (col == "red") {
      return const Color.fromARGB(150, 255, 105, 97);
    } else if (col == "violet") {
      return const Color.fromARGB(255, 204, 169, 221);
    } else if (col == "yellow") {
      return const Color.fromARGB(255, 253, 253, 150);
    } else if (col == "blue") {
      return const Color.fromARGB(211, 119, 158, 203);
    } else if (col == "green") {
      return const Color.fromARGB(255, 189, 236, 182);
    } else if (col == "grey") {
      return const Color.fromARGB(255, 190, 190, 190);
    } else {
      return const Color.fromARGB(255, 250, 250, 250);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.db.readAllNott().then((value) => {
          setState(() {
            for (var element in value) {
              Map<String, String> actual = {
                "id": element.id.toString(),
                "title": element.title.toString(),
                "body": element.body.toString(),
                "color": element.color.toString()
              };
              notex.add(actual);
            }
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: UniqueKey(),
        itemCount: notex.length,
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                    spreadRadius: 6,
                    blurRadius: 8,
                  ),
                ],
              ),
              key: UniqueKey(),
              margin: const EdgeInsets.all(10.0),
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  key: UniqueKey(),
                  contentPadding: const EdgeInsets.all(10.0),
                  mouseCursor: SystemMouseCursors.precise,
                  tileColor: _rip(index),
                  // hoverColor: const Color.fromARGB(255, 195, 195, 195),
                  subtitle: (notex.elementAt(index)["body"].toString()).length >
                          75
                      ? Text(
                          "${notex.elementAt(index)["body"].toString().substring(0, 75)}...")
                      : Text(notex.elementAt(index)["body"].toString()),
                  title: (notex.elementAt(index)["title"].toString()).length >
                          25
                      ? Text(
                          maxLines: 1,
                          "${(notex.elementAt(index)["title"].toString()).substring(0, 20)}...",
                          style: const TextStyle(fontSize: 22))
                      : Text(notex[index]["title"].toString(),
                          style: const TextStyle(fontSize: 22)),
                  trailing: const Icon(
                    Icons.list,
                    size: 35.0,
                  ),
                  onLongPress: () => {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              const Text("Are you sure you want to delete?"),
                          action: SnackBarAction(
                              label: "yes",
                              onPressed: () async {
                                int intIndexDB = int.parse(notex[index]["id"]);
                                await widget.db
                                    .deleteNott(intIndexDB)
                                    .then((value) => {
                                          if (value == 1)
                                            {
                                              setState(() {
                                                notex.removeAt(index);
                                              })
                                            }
                                        });
                              }),
                        )),
                      },
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute<void>(builder: (context) {
                      return notaViewer(
                        db: widget.db,
                        notex: notex,
                        index: index,
                        controlBody: widget.controlBody,
                        controlTitle: widget.controlTitle,
                        controlColor: widget.controlColor,
                      );
                    }));
                  }));
        });
  }
}

// ignore: must_be_immutable, camel_case_types
class notaViewer extends Nota {
  notaViewer({
    Key? key,
    required this.db,
    required this.notex,
    required this.index,
    required this.controlTitle,
    required this.controlBody,
    required this.controlColor,
  }) : super(
            key: key,
            db: db,
            controlBody: controlBody,
            controlTitle: controlTitle,
            controlColor: controlColor);
  // ignore: annotate_overrides
  final db;
  // ignore: annotate_overrides
  final notex;
  // ignore:
  final index;
  // ignore: annotate_overrides
  final controlTitle;
  // ignore: annotate_overrides
  final controlBody;
  // ignore: annotate_overrides
  final controlColor;

  @override
  State<notaViewer> createState() => _notaViewerState();
}

// ignore: camel_case_types
class _notaViewerState extends State<notaViewer> {
  _rip(index) {
    var col = widget.notex.elementAt(index)["color"].toString();
    if (col == "red") {
      return const Color.fromARGB(150, 255, 105, 97);
    } else if (col == "violet") {
      return const Color.fromARGB(255, 204, 169, 221);
    } else if (col == "yellow") {
      return const Color.fromARGB(255, 253, 253, 150);
    } else if (col == "blue") {
      return const Color.fromARGB(211, 119, 158, 203);
    } else if (col == "green") {
      return const Color.fromARGB(255, 189, 236, 182);
    } else if (col == "grey") {
      return const Color.fromARGB(255, 190, 190, 190);
    } else {
      return const Color.fromARGB(255, 250, 250, 250);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () async => {
            Navigator.pop(context),
            await Navigator.pushNamed(context, '/home'),
          },
        ),
        title: const Text("Note"),
        foregroundColor: const Color.fromARGB(255, 70, 70, 70),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 450.0,
          ),
          decoration: BoxDecoration(
              color: _rip(widget.index),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                  topRight: Radius.circular(40.0))),
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            onLongPress: () => {
              widget.controlTitle.text =
                  widget.notex[widget.index]["title"].toUpperCase(),
              widget.controlBody.text =
                  widget.notex[widget.index]["body"].toUpperCase(),
              widget.controlColor.text = widget.notex[widget.index]["color"],
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) {
                    return notaEditor(
                        db: widget.db,
                        index: widget.index,
                        notex: widget.notex,
                        controlBody: widget.controlBody,
                        controlColor: widget.controlColor,
                        controlTitle: widget.controlTitle);
                  },
                ),
              ),
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  key: UniqueKey(),
                  child: Text(
                    widget.notex[widget.index]["title"].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(
                  height: 15.0,
                  color: Color.fromARGB(255, 150, 150, 150),
                  thickness: 3.0,
                ),
                Container(
                  key: UniqueKey(),
                  child: Text(widget.notex[widget.index]["body"]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class notaEditor extends notaViewer {
  notaEditor({
    Key? key,
    required this.db,
    required this.index,
    required this.notex,
    required this.controlBody,
    required this.controlColor,
    required this.controlTitle,
  }) : super(
            key: key,
            db: db,
            index: index,
            notex: notex,
            controlBody: controlBody,
            controlColor: controlColor,
            controlTitle: controlTitle);

  // ignore: annotate_overrides
  final db;
  // ignore: annotate_overrides
  final index;
  // ignore: annotate_overrides
  final notex;
  // ignore: annotate_overrides
  final controlBody;
  // ignore: annotate_overrides
  final controlColor;
  // ignore: annotate_overrides
  final controlTitle;

  @override
  State<notaEditor> createState() => _notaEditorState();
}

// ignore: camel_case_types
class _notaEditorState extends State<notaEditor> {
  _rip(index) {
    var col = widget.notex.elementAt(index)["color"].toString();
    if (col == "red") {
      return const Color.fromARGB(150, 255, 105, 97);
    } else if (col == "violet") {
      return const Color.fromARGB(255, 204, 169, 221);
    } else if (col == "yellow") {
      return const Color.fromARGB(255, 253, 253, 150);
    } else if (col == "blue") {
      return const Color.fromARGB(211, 119, 158, 203);
    } else if (col == "green") {
      return const Color.fromARGB(255, 189, 236, 182);
    } else if (col == "grey") {
      return const Color.fromARGB(255, 190, 190, 190);
    } else {
      return const Color.fromARGB(255, 250, 250, 250);
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = _rip(widget.index);
  }

  var _selectedColor;
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Edit your note."),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: const Color.fromARGB(255, 70, 70, 70),
            iconSize: 30.0,
            onPressed: () async {
              widget.controlTitle.text = "";
              widget.controlBody.text = "";
              widget.controlColor.text = "";
              await Navigator.pushNamed(context, '/home');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              color: const Color.fromARGB(255, 70, 70, 70),
              iconSize: 37.0,
              onPressed: () async {
                var entrada = NottCompanion(
                  id: dft.Value(int.parse(widget.notex[widget.index]["id"])),
                  title: dft.Value(widget.controlTitle.text as String),
                  body: dft.Value(widget.controlBody.text as String),
                  color: dft.Value(widget.controlColor.text as String),
                );
                await widget.db.updateNott(entrada).then((value) => {
                      widget.notex[widget.index]["title"] =
                          widget.controlTitle.text,
                      widget.notex[widget.index]["body"] =
                          widget.controlBody.text,
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          width: 150,
                          content: Text(
                            'Saved!',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 2))),
                      widget.controlTitle.text = "",
                      widget.controlBody.text = "",
                      widget.controlColor.text = "",
                      Navigator.pushNamed(context, '/home'),
                    });
              },
            )
          ],
          foregroundColor: const Color.fromARGB(255, 70, 70, 70),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 450.0,
                      minWidth: 10.0,
                    ),
                    decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                            topRight: Radius.circular(40.0))),
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      // onLongPress: () => {
                      //   Navigator.pop(context, widget.notex),
                      // },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            key: UniqueKey(),
                            child: TextField(
                              maxLines: 1,
                              decoration: const InputDecoration(
                                  icon: Icon(Icons.arrow_right),
                                  border: InputBorder.none),
                              controller: widget.controlTitle,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(
                            height: 15.0,
                            color: _selectedColor,
                            thickness: 3.0,
                          ),
                          Container(
                            key: UniqueKey(),
                            child: TextField(
                                maxLines: null,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.arrow_right),
                                    border: InputBorder.none),
                                controller: widget.controlBody),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 190, 190, 190),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(255, 190, 190, 190),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(255, 190, 190, 190),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(255, 190, 190, 190);
                                }),
                                widget.controlColor.text = "grey"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 255, 105, 97),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(150, 255, 105, 97),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(150, 255, 105, 97),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(150, 255, 105, 97);
                                }),
                                widget.controlColor.text = "red"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 189, 236, 182),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(255, 189, 236, 182),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(255, 189, 236, 182),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(255, 189, 236, 182);
                                }),
                                widget.controlColor.text = "green"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 119, 158, 203),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(211, 119, 158, 203),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(211, 119, 158, 203),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(211, 119, 158, 203);
                                }),
                                widget.controlColor.text = "blue"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 253, 253, 150),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(255, 253, 253, 150),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(255, 253, 253, 150),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(255, 253, 253, 150);
                                }),
                                widget.controlColor.text = "yellow"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(60, 204, 169, 221),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.all(15.0),
                            child: IconButton(
                              splashColor:
                                  const Color.fromARGB(255, 204, 169, 221),
                              splashRadius: 16.0,
                              color: const Color.fromARGB(255, 204, 169, 221),
                              onPressed: () => {
                                setState(() {
                                  _selectedColor =
                                      const Color.fromARGB(255, 204, 169, 221);
                                }),
                                widget.controlColor.text = "violet"
                              },
                              icon: const Icon(Icons.water_drop_outlined),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
