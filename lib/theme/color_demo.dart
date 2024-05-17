import 'package:flutter/material.dart';
///Author: 
///Date: 5/14/24
///Description: shows colors of the theme
///Bugs: None Known
// A demo that displays all the colors in the current theme
class ColorDemo extends StatelessWidget {
  const ColorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Color Demo'),
        ),
        body: ListView(
          children: [
            ColorTile(
                name: 'primary', color: Theme.of(context).colorScheme.primary),
            ColorTile(
                name: 'onPrimary',
                color: Theme.of(context).colorScheme.onPrimary),
            ColorTile(
                name: 'primaryContainer',
                color: Theme.of(context).colorScheme.primaryContainer),
            ColorTile(
                name: 'onPrimaryContainer',
                color: Theme.of(context).colorScheme.onPrimaryContainer),
            ColorTile(
                name: 'secondary',
                color: Theme.of(context).colorScheme.secondary),
            ColorTile(
                name: 'onSecondary',
                color: Theme.of(context).colorScheme.onSecondary),
            ColorTile(
                name: 'secondaryContainer',
                color: Theme.of(context).colorScheme.secondaryContainer),
            ColorTile(
                name: 'onSecondaryContainer',
                color: Theme.of(context).colorScheme.onSecondaryContainer),
            ColorTile(
                name: 'tertiary',
                color: Theme.of(context).colorScheme.tertiary),
            ColorTile(
                name: 'onTertiary',
                color: Theme.of(context).colorScheme.onTertiary),
            ColorTile(
                name: 'tertiaryContainer',
                color: Theme.of(context).colorScheme.tertiaryContainer),
            ColorTile(
                name: 'onTertiaryContainer',
                color: Theme.of(context).colorScheme.onTertiaryContainer),
            ColorTile(
                name: 'error', color: Theme.of(context).colorScheme.error),
            ColorTile(
                name: 'onError', color: Theme.of(context).colorScheme.onError),
            ColorTile(
                name: 'errorContainer',
                color: Theme.of(context).colorScheme.errorContainer),
            ColorTile(
                name: 'onErrorContainer',
                color: Theme.of(context).colorScheme.onErrorContainer),
            ColorTile(
                name: 'outline', color: Theme.of(context).colorScheme.outline),
            ColorTile(
                name: 'outlineVariant',
                color: Theme.of(context).colorScheme.outlineVariant),
            ColorTile(
                name: 'background',
                color: Theme.of(context).colorScheme.background),
            ColorTile(
                name: 'onBackground',
                color: Theme.of(context).colorScheme.onBackground),
            ColorTile(
                name: 'surface', color: Theme.of(context).colorScheme.surface),
            ColorTile(
                name: 'onSurface',
                color: Theme.of(context).colorScheme.onSurface),
            ColorTile(
                name: 'surfaceVariant',
                color: Theme.of(context).colorScheme.surfaceVariant),
            ColorTile(
                name: 'onSurfaceVariant',
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            ColorTile(
                name: 'inverseSurface',
                color: Theme.of(context).colorScheme.inverseSurface),
            ColorTile(
                name: 'onInverseSurface',
                color: Theme.of(context).colorScheme.onInverseSurface),
            ColorTile(
                name: 'inversePrimary',
                color: Theme.of(context).colorScheme.inversePrimary),
            ColorTile(
                name: 'shadow', color: Theme.of(context).colorScheme.shadow),
            ColorTile(
                name: 'scrim', color: Theme.of(context).colorScheme.scrim),
            ColorTile(
                name: 'surfaceTint',
                color: Theme.of(context).colorScheme.surfaceTint),
          ],
        ));
  }
}

class ColorTile extends StatelessWidget {
  final String name;
  final Color color;
  final TextStyle black = const TextStyle(color: Colors.black);
  final TextStyle white = const TextStyle(color: Colors.white);
  const ColorTile({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [Text('$name ', style: white), Text(name, style: black)],
      ),
      tileColor: color,
      // Show the hex value of the color in the subtitle
      subtitle: Row(
        children: [
          Text('${color.value.toRadixString(16)} ', style: white),
          Text(color.value.toRadixString(16), style: black)
        ],
      ),
    );
  }
}
