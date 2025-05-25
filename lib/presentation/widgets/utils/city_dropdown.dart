// ignore_for_file: inference_failure_on_function_return_type

import 'package:flutter/material.dart';
import '../../../data/repositories/cities_data.dart';

/// A dropdown widget that displays a list of cities and allows selection.
class CityDropdown extends StatelessWidget {
  final List<City> cities;
  final City? selectedCity;
  final Function(City) onSelected;
  final Function() onDismissed;

  const CityDropdown({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onSelected,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cities.length,
        itemBuilder: (BuildContext context, int index) {
          final City city = cities[index];
          return ListTile(
            title: Text(city.name),
            enabled: city.enabled,
            onTap: () {
              if (city.enabled) {
                onSelected(city);
                onDismissed();
              }
            },
          );
        },
      ),
    );
  }
}
