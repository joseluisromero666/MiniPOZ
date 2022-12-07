class CommerceModel {
  final String nombre;
  final String logo;
  final String correo;
  final String paginaWeb;
  final String descripcion;
  final List<Sucursal> sucursales;

  CommerceModel(
      {this.nombre,
      this.logo,
      this.correo,
      this.paginaWeb,
      this.descripcion,
      this.sucursales});
}

class Sucursal {
  final String nombre;
  final Ubicacion ubicacion;
  final String telefono;

  Sucursal({this.nombre, this.ubicacion, this.telefono});
}

class Ubicacion {
  final String direccion;
  final String ciudad;
  final String departamento;

  Ubicacion({this.direccion, this.ciudad, this.departamento});
}

List<CommerceModel> shops = [
  new CommerceModel(
      nombre: 'Tienda Sasha',
      logo:
          'https://images.unsplash.com/photo-1613843738583-419017252494?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit',
      correo: 'contacto@tiendasasha.com.co',
      paginaWeb: 'tiendasasha.com.co',
      descripcion:
          'Somos una marca 100% Colombiana con diseños unicos e innovadores reconocidos mundialmente.',
      sucursales: [
        Sucursal(
            nombre: 'Sede Principal',
            ubicacion: Ubicacion(
                direccion: 'Carrera 7 # 12-23',
                ciudad: 'Bogotá',
                departamento: 'Distrito Capital'),
            telefono: '210654343'),
        Sucursal(
            nombre: 'Sede Chapinero',
            ubicacion: Ubicacion(
                direccion: 'Calle 53 # 7-23',
                ciudad: 'Bogotá',
                departamento: 'Distrito Capital'),
            telefono: '2152343')
      ]),
  new CommerceModel(
      nombre: 'Pastleles',
      logo:
          'https://images.unsplash.com/photo-1613916243315-0aa7f235d81c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit ',
      correo: 'fernanda@pastleles.com.co',
      paginaWeb: 'ricospastleles.com.co',
      descripcion: 'Panaderia y dulceria Pastleles, desayuna como un Rey',
      sucursales: [
        Sucursal(
            nombre: 'Sede Medellin',
            ubicacion: Ubicacion(
                direccion: 'Av 12 # 13 - 12, La Colina',
                ciudad: 'Medellin',
                departamento: 'Antioquia'),
            telefono: '3124567634'),
      ]),
  new CommerceModel(
      nombre: 'Chinos de la China',
      logo:
          'https://images.unsplash.com/photo-1613950684833-69a359eda9b0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxfDB8MXxyYW5kb218fHx8fHx8fA&ixlib=rb-1.2.1&q=80&w=1080&utm_source=unsplash_source&utm_medium=referral&utm_campaign=api-credit',
      correo: 'contacto@chinos.com.co',
      paginaWeb: 'chinosdelachina.com.co',
      descripcion: 'Comida China en la puerta de su casa, 24 horas.',
      sucursales: [
        Sucursal(
            nombre: 'Sede Calle 93',
            ubicacion: Ubicacion(
                direccion: 'Calle 93 # 2-4',
                ciudad: 'Bogotá',
                departamento: 'Distrito Capital'),
            telefono: '2101534'),
        Sucursal(
            nombre: 'Sede Salitre',
            ubicacion: Ubicacion(
                direccion: 'Carrera 100 # 15-15',
                ciudad: 'Bogotá',
                departamento: 'Distrito Capital'),
            telefono: '4156523')
      ]),
];
