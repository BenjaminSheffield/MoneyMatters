import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Money Matters',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }

  var favourites = <WordPair>[];

  void toggleFavourite(){
    if(favourites.contains(current)){
      favourites.remove(current);
    }
    else{
      favourites.add(current);
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              // SafeArea(
              //   child: NavigationRail(
              //     extended: constraints.maxWidth >= 600,
              //     destinations: [
              //       NavigationRailDestination(
              //         icon: Icon(Icons.home),
              //         label: Text('Home'),
              //       ),
              //       NavigationRailDestination(
              //         icon: Icon(Icons.favorite),
              //         label: Text('Favorites'),
              //       ),
              //     ],
              //     selectedIndex: selectedIndex,
              //     onDestinationSelected: (selectedNavigationIndex) {
              //       setState(() {
              //         selectedIndex = selectedNavigationIndex;
              //       });
              //     },
              //   ),
              // ),
              // ElevatedCard(),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: ElevatedCard(),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class ElevatedCard extends StatelessWidget {
  const ElevatedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: FittedBox(
          fit: BoxFit.contain,
          child: DataTableCurrentAccount(),
        ),
      ),
    );
  }
}

class DataTableCurrentAccount extends StatelessWidget {
  const DataTableCurrentAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Date',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Item',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Debit',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Credit',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Balance',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Week 1')),
            DataCell(Text('Income (Salary)')),
            DataCell(Text('')),
            DataCell(Text('\$863.70')),
            DataCell(Text('\$863.70')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
             DataCell(Text('')),
            DataCell(Text('Tax')),
            DataCell(Text('259.11')),
            DataCell(Text('')),
            DataCell(Text('\$605.59')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
             DataCell(Text('')),
            DataCell(Text('Mortgage/Rent')),
            DataCell(Text('\$250.00')),
            DataCell(Text('')),
            DataCell(Text('\$355.59')),
          ],
        ),
         DataRow(
          cells: <DataCell>[
             DataCell(Text('')),
            DataCell(Text('Groceries card#')),
            DataCell(Text('\$167.15')),
            DataCell(Text('')),
            DataCell(Text('\$188.44')),
          ],
        ),
         DataRow(
          cells: <DataCell>[
             DataCell(Text('')),
            DataCell(Text('Fortune: New Shoes')),
            DataCell(Text('\$139.00')),
            DataCell(Text('')),
            DataCell(Text('\$49.44')),
          ],
        ),
      ],
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavourite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onSecondary
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asCamelCase, 
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}"),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favourites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favourites.length} favorites:'),
        ),
        for (var pair in appState.favourites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }}