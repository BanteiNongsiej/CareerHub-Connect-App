import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skeletonizer/skeletonizer.dart';

class ListUsers extends StatefulWidget {
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: 3));
    final url = 'http://10.0.3.2:8000/api/dashboard/ViewAllUsers';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          users = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load users');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Future<void> deleteUser(String userId) async {
    final url = 'http://10.0.3.2:8000/api/dashboard/user/deleteUser/$userId';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          users.removeWhere((user) => user['id'] == userId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  void showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('Email: ${user['email']}'),
              Text('ID: ${user['id']}'),
              if (user['mobile_number'] != null &&
                  user['mobile_number'].isNotEmpty)
                Text('Mobile Number: ${user['mobile_number']}'),
              if (user['address'] != null && user['address'].isNotEmpty)
                Text('Address: ${user['address']}'),
              if (user['dob'] != null && user['dob'].isNotEmpty)
                Text('Date of Birth: ${user['dob']}'),
              if (user['gender'] != null && user['gender'].isNotEmpty)
                Text('Gender: ${user['gender']}'),
              if (user['resume'] != null && user['resume'].isNotEmpty)
                Text('Resume: ${user['resume']}'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Color.fromARGB(255, 142, 233, 237),
      ),
      body: isLoading
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Skeletonizer(
                    child: ListTile(
                      title: Container(
                        height: 16.0,
                        color: Colors.grey[300],
                      ),
                      trailing: Icon(Icons.more_vert, color: Colors.grey[300]),
                    ),
                  );
                },
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['email']),
                    trailing: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.only(top: 0.0),
                              content: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 160,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top:
                                              40.0), // Adjust the padding to leave space for the close button
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${user['email']}",
                                            style: TextStyle(fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 16.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  showUserDetails(
                                                      context, user);
                                                },
                                                child: Text("View details"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Implement block user
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Block User"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await deleteUser(
                                                      user['id'].toString());
                                                  Navigator.pushNamed(
                                                      context, '/listusers');
                                                },
                                                child: Text("Delete User"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 0.0,
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
