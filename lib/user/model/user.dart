import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String userName;
  final String firstName;
  final String lastName;

  const User({
    required this.id,
    required this.userName,
    required this.firstName,
    required this.lastName,
  });

  User.fromFPMap(Map fpMap)
      : this(
          id: fpMap['id'].toString(),
          userName: fpMap['user_name'],
          firstName: fpMap['first_name'],
          lastName: fpMap['last_name'],
        );

  User.fromMap(Map userMap)
      : this(
          id: userMap['id'].toString(),
          userName: userMap['userName'],
          firstName: userMap['firstName'],
          lastName: userMap['lastName'],
        );

  Map toMap() => {
        'id': id,
        'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
      };

  @override
  List<Object> get props => [id, userName, firstName, lastName];
}
