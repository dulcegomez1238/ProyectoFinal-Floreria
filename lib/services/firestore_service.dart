import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/floreria_model.dart';
import '../models/empleado_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'florerias';

  // Get stream of florerias for a specific user
  Stream<List<Floreria>> getFlorerias(String userId) {
    return _db
        .collection(_collectionPath)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Floreria.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get stream of all florerias (if admin) or just generally
  Stream<List<Floreria>> getAllFlorerias() {
    return _db
        .collection(_collectionPath)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Floreria.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Add new floreria
  Future<void> addFloreria(Floreria floreria) async {
    await _db.collection(_collectionPath).add(floreria.toMap());
  }

  // Update floreria
  Future<void> updateFloreria(Floreria floreria) async {
    if (floreria.id != null) {
      await _db
          .collection(_collectionPath)
          .doc(floreria.id)
          .update(floreria.toMap());
    }
  }

  // Delete floreria
  Future<void> deleteFloreria(String id) async {
    await _db.collection(_collectionPath).doc(id).delete();
  }

  // ---------------- EMPLEADOS ----------------
  final String _empleadosCollection = 'empleados';

  Stream<List<Empleado>> getEmpleados(String userId) {
    return _db
        .collection(_empleadosCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Empleado.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addEmpleado(Empleado empleado) async {
    await _db.collection(_empleadosCollection).add(empleado.toMap());
  }

  Future<void> updateEmpleado(Empleado empleado) async {
    if (empleado.id != null) {
      await _db
          .collection(_empleadosCollection)
          .doc(empleado.id)
          .update(empleado.toMap());
    }
  }

  Future<void> deleteEmpleado(String id) async {
    await _db.collection(_empleadosCollection).doc(id).delete();
  }
}
