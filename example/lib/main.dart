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
      theme: ThemeData(useMaterial3: true),
      home: const DemoPage(),
      builder: (context, child) {
        return BeholderManager(
          items: const [
            LogJsonView(),
            LogAddressView(),
            LogColorView(),
          ],
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = BeholderScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beholder'),
        actions: [
          IconButton(
            onPressed: scope.controller.clearAll,
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
            stream: scope.controller.availableTags,
            builder: (context, snap) {
              if (!snap.hasData) {
                return const SliverToBoxAdapter();
              }

              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 4,
                    children: snap.data!.map(
                      (e) {
                        return FilterChip(
                          label: Text(e),
                          selected: scope.controller.tags.contains(e),
                          onSelected: _onSelected(context, e),
                        );
                      },
                    ).toList(growable: false),
                  ),
                ),
              );
            },
          ),
          StreamBuilder<List<LogEntry>>(
            stream: scope.controller.logs,
            builder: (context, snap) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = snap.data!.elementAt(index);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(entry.logger),
                          trailing: _Tags(tags: entry.tags),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LogEntryView(entry: entry),
                        ),
                      ],
                    );
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

    Logger('Test').logWithExtra(
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

  ValueChanged<bool> _onSelected(BuildContext context, String tag) {
    return (value) {
      final scope = BeholderScope.of(context);
      scope.controller.toggleTag(tag);
    };
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
  Widget builder(BuildContext context, Color value) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: value,
        );
    return Row(
      children: [
        Text(
            'Color (r:${value.red}, g: ${value.green}, b: ${value.blue}, a: ${value.alpha})',
            style: style),
        const Spacer(),
        IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value.toString()));
            },
            icon: const Icon(Icons.copy_all_outlined))
      ],
    );
  }
}

class _Tags extends StatelessWidget {
  final List<String>? tags;
  const _Tags({this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags == null) {
      return const SizedBox.shrink();
    }
    final scope = BeholderScope.of(context);
    return Wrap(
      spacing: 2,
      children: tags!.map(
        (e) {
          return ChoiceChip(
            label: Text(e),
            selected: scope.controller.tags.contains(e),
            onSelected: (bool value) {
              scope.controller.toggleTag(e);
            },
          );
        },
      ).toList(growable: false),
    );
  }
}
