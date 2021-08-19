import 'package:flutter/material.dart';
import 'package:movielist_app/Database/dbconn.dart';
import 'package:movielist_app/models/constants.dart';
import 'package:movielist_app/login.dart';
import 'package:movielist_app/authentication.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _movielist = [];

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshmovielist() async {
    final data = await DbConn.getItems();
    setState(() {
      _movielist = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshmovielist();
  }

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _directorController = new TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _movielist.firstWhere((element) => element['id'] == id);
      _nameController.text = existingJournal['name'];
      _directorController.text = existingJournal['director'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        builder: (_) =>
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _directorController,
                      decoration: InputDecoration(hintText: 'Director'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Save new journal
                        if (id == null) {
                          await _addItem();
                        }

                        if (id != null) {
                          await _updateItem(id);
                        }

                        // Clear the text fields
                        _nameController.text = '';
                        _directorController.text = '';

                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Create New' : 'Update'),
                    )
                  ],
                ),
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await DbConn.createItem(
        _nameController.text, _directorController.text);
    _refreshmovielist();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await DbConn.updateItem(
        id, _nameController.text, _directorController.text);
    _refreshmovielist();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await DbConn.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully deleted a movie!'),
    ));
    _refreshmovielist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF819BFA),
        title: Text('Movie List'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _movielist.length,
        itemBuilder: (context, index) =>
            Card(
              color: Colors.orange[200],
              margin: EdgeInsets.all(15),
              child: ListTile(
                  title: Text(_movielist[index]['name']),
                  subtitle: Text(_movielist[index]['director']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showForm(_movielist[index]['id']),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              _deleteItem(_movielist[index]['id']),
                        ),
                      ],
                    ),
                  )),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF819BFA),
        child: Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
  void choiceAction(String choice) {
    if (choice == Constants.Profile) {
      print('My Profile');
    } else if (choice == Constants.SignOut) {
      context.read<AuthenticationHelper>().signOut().then((_) =>  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (contex) => Login()),
      ));
    }
  }
}
