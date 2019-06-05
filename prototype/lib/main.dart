import 'package:flutter/material.dart';
import 'package:prototype/models/item.dart';
import 'package:unicorndial/unicorndial.dart';

void main() => runApp(new MyApp());
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final TextEditingController _textEditingController =
    new TextEditingController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MultiTask',
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var indexer = 0;
  List<Item> items1 = [
    Item('Take a shower'),
    Item('Go shopping'),
    Item('Feed the cat'),
  ];
  List<Item> items2 = [
    Item('ProtoType Assignment'),
    Item('Programming Assignment'),
    Item('Database Assignments'),
  ];
  List<List<Item>> itemLists = [];

  bool asc = false;
  _sortList() {
    asc = !asc;
    if (asc) {
      print('Ascending thingy');
      setState(() {
        itemLists[indexer].sort((a, b) => b.title.compareTo(a.title));
        return;
      });
    } else {
      print('Descending thingy');
      setState(() {
        itemLists[indexer].sort((a, b) => a.title.compareTo(b.title));
        return;
      });
    }
  }
  _testAlert(){
    return new Container(
       child: AlertDialog(
              title: Text('Not in stock'),
              content: const Text('This item is no longer available'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
    );
  }
  _onAddItemPressed() {
    _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
      return new Container(
        decoration: new BoxDecoration(color: Colors.blueGrey),
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 50.0, 32.0, 32.0),
          child: new TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Please enter a task',
            ),
            onSubmitted: _onSubmit,
          ),
        ),
      );
    });
  }

  _bodyMaker() {
    var body = new Container(
      child: new ListView.builder(
        itemCount: itemLists[indexer].length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              '${itemLists[indexer][index].title}',
            ),
            trailing: new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                _onDeleteItem(index);
              },
            ),
          );
        },
      ),
    );
    return body;
  }

  _drawerMaker() {
    var drawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Lithial'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home Tasks'),
            onTap: () {
              setState(() {
                _setListIndex(0);
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('School Tasks'),
            onTap: () {
              setState(() {
                _setListIndex(1);
              });
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
    return drawer;
  }

  _setListIndex(int counter) {
    indexer = counter;
  }

  _onDeleteItem(item) {
    itemLists[indexer].removeAt(item);
    setState(() {});
  }

  _onSubmit(String s) {
    if (s.isNotEmpty) {
      itemLists[indexer].add(Item(s));
      _textEditingController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Add",
        currentButton: FloatingActionButton(
          heroTag: "Add",
          backgroundColor: Colors.blue,
          mini: true,
          child: Icon(Icons.add),
          onPressed: () {
          _testAlert();
        
            //_onAddItemPressed();
          },
        )));
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Sort",
        currentButton: FloatingActionButton(
          heroTag: "Sort",
          backgroundColor: Colors.blue,
          mini: true,
          child: Icon(Icons.sort),
          onPressed: () {
            _sortList();
          },
        )));

    itemLists.add(items1);
    itemLists.add(items2);

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('MultiTask'),
      ),
      drawer: _drawerMaker(),
      body: _bodyMaker(),
      floatingActionButton: new UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.redAccent,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: childButtons),
    );
  }
}
