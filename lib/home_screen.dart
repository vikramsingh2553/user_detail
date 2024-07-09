import 'package:flutter/material.dart';
import 'package:user_detail/user_api_service.dart';
import 'package:user_detail/user_detail_screen.dart';
import 'package:user_detail/user_model.dart';

import 'add_user_screen.dart';
import 'edit_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<UserModel>> futureUserList;
  final UserApiService userService = UserApiService();

  @override
  void initState() {
    super.initState();
    futureUserList = userService.fetchUsers();
  }

  void addUser(UserModel user) async {
    await userService.addUser(user);
    setState(() {
      futureUserList = userService.fetchUsers();
    });
  }

  void updateUser(UserModel user) async {
    await userService.updateUser(user);
    setState(() {
      futureUserList = userService.fetchUsers();
    });
  }

  void deleteUser(int id) async {
    await userService.deleteUser(id);
    setState(() {
      futureUserList = userService.fetchUsers();
    });
  }

  void confirmDeleteUser(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteUser(id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Users List',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<UserModel>>(
          future: futureUserList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              final users = snapshot.data!;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            user.imageUrl != null && user.imageUrl!.isNotEmpty
                                ? NetworkImage(user.imageUrl!)
                                : null,
                        child: user.imageUrl == null || user.imageUrl!.isEmpty
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        '${user.firstName ?? ''} ${user.lastName ?? ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(user.email ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetailsScreen(user: user),
                          ),
                        );
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final updatedUser = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditUserScreen(
                                    user: user,
                                    onUpdateUser: updateUser,
                                  ),
                                ),
                              );
                              if (updatedUser != null) {
                                updateUser(updatedUser);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              confirmDeleteUser(user.id as int);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newUser = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUserScreen(onAddUser: addUser),
            ),
          );
          if (newUser != null) {
            addUser(newUser);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
