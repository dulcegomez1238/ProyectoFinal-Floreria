class Usuario {
  final String id;
  final String email;
  final String displayName;

  Usuario({
    required this.id,
    required this.email,
    required this.displayName,
  });

  factory Usuario.fromMap(Map<String, dynamic> data, String documentId) {
    return Usuario(
      id: documentId,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
    };
  }
}
