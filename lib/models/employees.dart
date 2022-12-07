class EmployeeModel {
  String nombre;
  String foto;
  String documento;
  String correo;
  String telefono;
  String role;
  String token;

  Map<String, dynamic> toMap() {
    return {
      'name': nombre,
      'urlImg': foto,
      'document': documento,
      'phone': telefono,
      'email': correo,
      'role': role,
      'token':token
    };
  }

  EmployeeModel(
      {this.nombre,
      this.foto,
      this.documento,
      this.telefono,
      this.correo,
      this.role,
      this.token});
}
