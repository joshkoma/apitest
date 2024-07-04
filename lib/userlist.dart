import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserList extends StatelessWidget {
  
  //we are using a free API known as random api
  final String apiURL = 'https://randomuser.me/api/?results=20';

  Future<List<dynamic>> fetchUsers() async {
    var result = await http.get(Uri.parse(apiURL));
    return jsonDecode(result.body)['results'];
  }

  String _name(dynamic user) {
    return user['name']['title'] +
        ' ' +
        user['name']['first'] +
        ' ' +
        user['name']['last'];
  }

  String _age(Map<dynamic, dynamic> user) {
    return 'Age: ' + user['dob']['age'].toString(); //convert return type to string
  }

  String _location(Map<dynamic, dynamic> user) {
    return user['location']['country'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('API Test'),
        ),
        body: Container(
          child: FutureBuilder(
              future: fetchUsers(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  print(_age(snapshot.data[0]));
                  return ListView.builder(
                      padding: EdgeInsets.all(8),
                    
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        
                        //use refreshindicator to pull new data if the data gets updated
                        return RefreshIndicator(
                          onRefresh: fetchUsers,
                          child: ListTile(
                            tileColor: Colors.grey[100],
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  snapshot.data[index]['picture']['large']),
                            ),
                            title: Text(_name(snapshot.data[index])),
                            subtitle: Text(_location(snapshot.data[index])),
                            trailing: Text(_age(snapshot.data[index])), 
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: Text('No data found'),
                  );
                }
              }),
        ));
  }
}
