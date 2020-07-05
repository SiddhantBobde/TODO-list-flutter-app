import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskshelf/data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  QuerySnapshot task;
  final myController = TextEditingController();
  Databaseservice tasks=new Databaseservice();
  List<Widget>list = new List();

  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Your Task'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: myController,
                autofocus: true,
                decoration: InputDecoration(labelText: 'Task*'),
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Add Task'),
            onPressed: () {
              Firestore.instance.collection("tasks").add(
                {
                  "title":myController.text,
                }
              ).then((results){
              myController.clear();
              Navigator.pop(context);
              });
               
            },
          ),

          FlatButton(
            child: Text('Cancel'),
            onPressed: (){
              myController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

  deleteData(){
    try{
    Firestore.instance.collection('tasks').document().delete();
  }catch(e){
    print(e.toString());
  }
  }
  @override
  void initState() {
    tasks.getData().then((results) {
      setState(() {
       task = results;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: <Widget>[
          FlatButton(onPressed: ()
          {
            _showMyDialog();
          },
          child: Icon(Icons.add),),
        
        FlatButton(
          onPressed: (){
            tasks.getData().then((results){
              setState(() {
                task=results;
              });
            });
          },
          child: Icon(Icons.refresh),
        ),
        
          FlatButton(child: Icon(Icons.delete),
          onPressed: (){
            deleteData();
          },)
        ],
      ),
      
      body: _tasklist(
      ),
);
  }

Widget _tasklist(){
  if(task!=null){
    return ListView.builder(
      itemCount: task.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {
          return new ListTile(
            title: Text(task.documents[i].data['title']),
             );
        },
      );
    }
    else{
      return Text("loading.....");
    }
    
  }


  
}