// Here will be user model
class User {
  final String id;
  final String userName;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String role;
  final bool wannaBeManager;
  final Map<String, List<int>>
      moviesIDs; // List of movies IDs and corrosponding seats reverved

  User(this.id, this.userName, this.email, this.password, this.firstName,
      this.lastName, this.role, this.wannaBeManager, this.moviesIDs);

  static User fromMap(String id, Map<String, dynamic> data) {
    // Map<String, List<int>> userMoviesIDs = {};
    // for (String key in data['moviesIDs'].keys) {
    //   userMoviesIDs[key] = [];
    //   for (int i in data['moviesIDs'][key]) {
    //     userMoviesIDs[key]?.add(i);
    //   }
    // }

    return User(
      id,
      data['userName'],
      data['email'],
      data['password'],
      data['firstName'],
      data['lastName'],
      data['role'],
      data['wannaBeManager'] as bool,
      {}, //data['moviesIDs'] as Map<String, List<int>>,
    );
  }
}
