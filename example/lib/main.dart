import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:beholder/beholder.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
      builder: (context, child) {
        return BeholderManager(
          items: const [
            LogJsonView(),
            LogColorView(),
          ],
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beholder demo'),
        actions: [LogSpawn(onSpawn: _onGenerate)],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DemoPage(),
              ),
            );
          },
          child: Text('Log view'),
        ),
      ),
    );
  }

  void _onGenerate() {
    final colors = List.unmodifiable([
      Colors.red,
      Colors.indigo,
      Colors.green,
      Colors.teal,
    ]);

    final randomObject = List.unmodifiable([
      // faker.address,
      colors.elementAt(Random().nextInt(colors.length)),
      {
        'animal': faker.animal.name(),
      },
    ]);

    Logger('LOGGER NAME').logWithExtra(
      Level.INFO,
      randomObject.elementAt(Random().nextInt(randomObject.length)),
      tags: _genTags(),
    );
  }

  List<String>? _genTags() {
    final tags = ['network', 'ui', 'logic', 'di'];

    final items = <List<String>?>[
      null,
      {
        tags.elementAt(Random().nextInt(tags.length)),
        if (Random().nextBool()) tags.elementAt(Random().nextInt(tags.length)),
      }.toList(growable: false)
    ];
    return items.elementAt(Random().nextInt(items.length));
  }
}

class DemoPage extends Beholder {
  const DemoPage({super.key});

  @override
  Widget builder(BuildContext context, controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beholder'),
        actions: [
          IconButton(
            onPressed: controller.clearAll,
            icon: const Icon(Icons.restore_from_trash_outlined),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // const SliverAppBar(
          //   pinned: true,
          //   title: TextField(
          //     decoration: InputDecoration.collapsed(hintText: 'Search...'),
          //   ),
          // ),
          StreamBuilder(
            stream: controller.availableTags,
            builder: (context, snap) {
              if (!snap.hasData) {
                return const SliverToBoxAdapter();
              }

              return SliverAppBar(
                leadingWidth: 0,
                leading: const SizedBox.shrink(),
                pinned: true,
                centerTitle: false,
                title: Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()..scale(0.8),
                  child: Wrap(
                    spacing: 4,
                    children: snap.data!.map(
                      (e) {
                        return FilterChip(
                          label: Text(e),
                          selected: controller.tags.contains(e),
                          onSelected: (_) => controller.toggleTag(e),
                        );
                      },
                    ).toList(growable: false),
                  ),
                ),
              );
            },
          ),
          StreamBuilder<List<LogEntry>>(
            key: ValueKey(DateTime.now()),
            stream: controller.logs,
            builder: (context, snap) {
              if (controller.isFiltered && snap.data?.isEmpty == true) {
                return SliverToBoxAdapter(
                  child: ListTile(
                    title: const Text('No results'),
                    subtitle: const Text('Try change criteria for filters'),
                    trailing: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: controller.filterClear,
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = snap.data!.elementAt(index);
                    return LogEntryBox(entry: entry, controller: controller);
                  },
                  childCount: snap.data?.length ?? 0,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onGenerate,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onGenerate() {
    final colors = List.unmodifiable([
      Colors.red,
      Colors.indigo,
      Colors.green,
      Colors.teal,
    ]);

    final randomObject = List.unmodifiable([
      // faker.address,
      colors.elementAt(Random().nextInt(colors.length)),
      {
        'animal': faker.animal.name(),
      },
    ]);

    Logger('LOGGER NAME').logWithExtra(
      Level.INFO,
      randomObject.elementAt(Random().nextInt(randomObject.length)),
      tags: _genTags(),
    );
  }

  List<String>? _genTags() {
    final tags = ['network', 'ui', 'logic', 'di'];

    final items = <List<String>?>[
      null,
      {
        tags.elementAt(Random().nextInt(tags.length)),
        if (Random().nextBool()) tags.elementAt(Random().nextInt(tags.length)),
      }.toList(growable: false)
    ];
    return items.elementAt(Random().nextInt(items.length));
  }
}

typedef Json = Map<String, dynamic>;

final class LogJsonView extends LogViewWidget<Map> {
  const LogJsonView({super.key});

  @override
  bool hasApply(Object error) {
    return error is Map;
  }

  @override
  Widget builder(BuildContext context, Map value) {
    const encoder = JsonEncoder.withIndent('  ');
    return Text(encoder.convert(value));
  }
}

final class LogAddressView extends LogViewWidget<Address> {
  const LogAddressView({super.key});

  @override
  Widget builder(BuildContext context, Address value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(value.city()),
      subtitle: Text(value.country()),
      trailing: Text(value.zipCode()),
    );
  }
}

final class LogColorView extends LogViewWidget<MaterialColor> {
  const LogColorView({super.key});

  @override
  Widget builder(BuildContext context, MaterialColor value) {
    final style = Theme.of(context).textTheme.bodyMedium;
    final Color(:red, :green, :blue, :alpha) = value;
    final str = 'Color (r:$red, g: $green, b: $blue, a: $alpha)';

    return Text(
      str,
      style: style?.copyWith(color: value),
    );
  }

  @override
  List<LogEntryAction> actions() {
    return [
      LogEntryAction(
        label: 'Copy to clipboard',
        action: (value) {
          Clipboard.setData(ClipboardData(text: value.toString()));
        },
      ),
      LogEntryAction(
        label: 'Copy as CURL',
        action: (value) {
          Clipboard.setData(ClipboardData(text: value.toString()));
        },
      ),
    ];
  }
}

class LogEntryBox extends StatelessWidget {
  final LogEntryController controller;
  final LogEntry entry;
  const LogEntryBox({super.key, required this.entry, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(entry.logger),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Tags(entry: entry, controller: controller),
                  _Actions(entry: entry),
                ],
              ),
            ],
          ),
          Text(entry.message),
          LogEntryView(
            entry: entry,
            renderType: LogRenderType.presentation,
          ),
        ],
      ),
    );
  }
}

class _Tags extends StatelessWidget {
  final LogEntryController controller;
  final LogEntry entry;
  const _Tags({required this.entry, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!entry.hasTags) {
      return const SizedBox.shrink();
    }
    // final scope = BeholderScope.of(context);
    final widgetTags = entry.tags!.map(
      (e) {
        return ChoiceChip(
          label: Text(e),
          selected: controller.tags.contains(e),
          onSelected: (bool value) => controller.toggleTag(e),
        );
      },
    ).toList(growable: false);

    return Wrap(spacing: 2, children: widgetTags);
  }
}

class _Actions extends StatelessWidget {
  final LogEntry entry;

  const _Actions({required this.entry});

  @override
  Widget build(BuildContext context) {
    if (!entry.hasActions) {
      return const SizedBox.shrink();
    }

    final items = entry.actions!.map((e) {
      return MenuItemButton(
        onPressed: () => e.action(entry.data),
        child: Text(e.label),
      );
    }).toList(growable: false);

    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () => controller.open(),
          icon: const Icon(Icons.more_vert_outlined),
        );
      },
      menuChildren: items,
    );
  }
}

class LogSpawn extends StatefulWidget {
  final VoidCallback onSpawn;
  const LogSpawn({super.key, required this.onSpawn});

  @override
  State<LogSpawn> createState() => _LogSpawnState();
}

class _LogSpawnState extends State<LogSpawn> {
  Timer? timer;

  bool enable = false;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (enable) {
        widget.onSpawn();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => setState(() => enable = !enable),
      icon: Icon(
        enable ? Icons.timer_off_outlined : Icons.timer_outlined,
      ),
    );
  }
}
