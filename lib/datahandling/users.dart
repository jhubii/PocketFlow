class Users {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String image;
  final int balance;
  final int totalIncome;
  final int totalExpense;

  Users({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.image,
    required this.balance,
    required this.totalExpense,
    required this.totalIncome,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'image': image,
        'balance': balance,
        'totalExpense': totalExpense,
        'totalIncome': totalIncome,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        email: json['email'],
        password: json['password'],
        image: json['image'],
        balance: json['balance'],
        totalExpense: json['totalExpense'],
        totalIncome: json['totalIncome'],
      );
}
