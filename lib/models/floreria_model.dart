import 'package:cloud_firestore/cloud_firestore.dart';

class Floreria {
  final String? id;
  final String nombre;
  final String direccion;
  final String telefono;
  final DateTime? createdAt;
  final String userId;

  Floreria({
    this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    this.createdAt,
    required this.userId,
  });

  factory Floreria.fromMap(Map<String, dynamic> data, String documentId) {
    return Floreria(
      id: documentId,
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'userId': userId,
    };
  }
}
