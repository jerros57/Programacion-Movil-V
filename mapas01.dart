void main() {
  // Mapas
  Map<String, String> estudiante = {
    'nombre': 'Carlos',
    'carrera': 'Sistemas',
    'ciudad': 'Guayaquil',
  };

  print(estudiante);

  // Acceder a un valor en especifico
  print('****************************');
  print(estudiante['nombre']);

  // Errores comunes
  print(estudiante['Nombre']);

  // Agregue un elemento al mapa
  print(estudiante['ciudad']);

  // Agrego un elemento al mapa
  estudiante['promedio'] = '10';

  // Errores comunes, agregar un tipo de dato diferente al declarado
  // estudiante['promedio'] = 1;

  // Analice el siguiente mapa e indique que se obtiene en consola
  Map<dynamic, dynamic> clientes = {
    'nombre': 'Jorge',
    'estado': true,
    'credito': 1000.10,
    1: true,
    true: 100,
  };

  print(clientes);

  // Eliminar un elemento del mapa
  print('*************ELIMINAR ELEMENTO DEL MAPA***************');
  clientes.remove('credito');
  print(clientes);

  // Saber si existe una clave
  if (clientes.containsKey('nombre')) {
    print('El cliente contiene un nombre registrado');
  }
  print(clientes.containsKey('Nombre'));

  // Recorrer un mapa
  estudiante.forEach((clave, valor) {
    print('$clave : $valor');
  });

  // Propiedades utiles con mapas
  // Saber el tamaño del mapa
  print(estudiante.length);

  // Saber si esta vacio
  print(estudiante.isEmpty);

  // Saber si no esta vacio
  print(estudiante.isNotEmpty);

  // Conocer las llaves o key
  print(estudiante.keys);

  // Conocer los values o valores
  print(estudiante.values);

  // Podemos buscar un valor
  print(estudiante.containsKey('nombre'));
}
