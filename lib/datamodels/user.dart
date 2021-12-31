// Here will be user model
class User {
  final String userName;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String role;
  final Map<String, List<int>>
      moviesIDs; // List of movies IDs and corrosponding seats reverved

  User(this.userName, this.email, this.password, this.firstName, this.lastName,
      this.role, this.moviesIDs);
}
