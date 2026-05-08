import 'package:cloud_firestore/cloud_firestore.dart';

class Empleado {
  final String? id;
  final String nombre;
  final String puesto;
  final String sueldo;
  final String fecha;
  final DateTime? createdAt;
  final String userId;

  Empleado({
    this.id,
    required this.nombre,
    required this.puesto,
    required this.sueldo,
    required this.fecha,
    this.createdAt,
    required this.userId,
  });

  factory Empleado.fromMap(Map<String, dynamic> data, String documentId) {
    return Empleado(
      id: documentId,
      nombre: data['nombre'] ?? '',
      puesto: data['puesto'] ?? '',
      sueldo: data['sueldo'] ?? '',
      fecha: data['fecha'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'puesto': puesto,
      'sueldo': sueldo,
      'fecha': fecha,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'userId': userId,
    };
  }
}
