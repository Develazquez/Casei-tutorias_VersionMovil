import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({
    required this.profiles,
    required this.programs,
    required this.selectedProfile,
    required this.selectedProgram,
    required this.onProfileChanged,
    required this.onProgramChanged,
    super.key,
  });

  final List<String> profiles;
  final List<String> programs;
  final String selectedProfile;
  final String selectedProgram;
  final ValueChanged<String> onProfileChanged;
  final ValueChanged<String> onProgramChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: DropdownButtonFormField<String>(
                initialValue: selectedProfile,
                decoration: const InputDecoration(
                  labelText: 'Perfil académico',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.filter_alt_outlined),
                ),
                items: profiles
                    .map(
                      (profile) => DropdownMenuItem(
                        value: profile,
                        child: Text(profile, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) onProfileChanged(value);
                },
              ),
            ),
            SizedBox(
              width: 320,
              child: DropdownButtonFormField<String>(
                initialValue: selectedProgram,
                decoration: const InputDecoration(
                  labelText: 'Programa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.apartment_outlined),
                ),
                items: programs
                    .map(
                      (program) => DropdownMenuItem(
                        value: program,
                        child: Text(program, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) onProgramChanged(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
