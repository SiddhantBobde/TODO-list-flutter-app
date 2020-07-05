import 'package:cloud_firestore/cloud_firestore.dart';

class Databaseservice
{
  getData() async {
    return await Firestore.instance.collection('tasks').getDocuments();
  }
}