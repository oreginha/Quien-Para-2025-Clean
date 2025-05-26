// lib/data/cities_data.dart

class City {
  final String name;
  final bool enabled;

  const City({required this.name, this.enabled = false});
}

class CitiesData {
  static const List<City> argentinaCities = <City>[
    // Ciudades habilitadas
    City(name: 'Ciudad Autónoma de Buenos Aires', enabled: true),
    City(name: 'La Plata', enabled: true),
    City(name: 'Rosario', enabled: true),
    City(name: 'Córdoba', enabled: true),

    // Otras capitales (deshabilitadas por ahora)
    City(name: 'San Miguel de Tucumán'),
    City(name: 'Mendoza'),
    City(name: 'San Salvador de Jujuy'),
    City(name: 'San Fernando del Valle de Catamarca'),
    City(name: 'Salta'),
    City(name: 'La Rioja'),
    City(name: 'San Juan'),
    City(name: 'Santa Fe'),
    City(name: 'Santiago del Estero'),
    City(name: 'Paraná'),
    City(name: 'Corrientes'),
    City(name: 'Posadas'),
    City(name: 'Resistencia'),
    City(name: 'Formosa'),
    City(name: 'Neuquén'),
    City(name: 'Viedma'),
    City(name: 'Rawson'),
    City(name: 'Santa Rosa'),
    City(name: 'Río Gallegos'),
    City(name: 'Ushuaia'),
  ];
}
