import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const OrdersApp());
}

class OrdersApp extends StatelessWidget {
  const OrdersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF10B981)),
        fontFamily: 'Inter',
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys =
      List.generate(5, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _TabNavigator(navigatorKey: _navigatorKeys[0], child: const OrdersFlutterPage()),
          _TabNavigator(navigatorKey: _navigatorKeys[1], child: const SalesChannelsPage()),
          _TabNavigator(navigatorKey: _navigatorKeys[2], child: const OrdersFlutterPage()),
          _TabNavigator(navigatorKey: _navigatorKeys[3], child: const _PlaceholderPage(title: 'Meals')),
          _TabNavigator(navigatorKey: _navigatorKeys[4], child: const _PlaceholderPage(title: 'Profile')),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex == index) {
            _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
            return;
          }
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  const _TabNavigator({required this.navigatorKey, required this.child});

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) => child),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = <({IconData icon, String label})>[
      (icon: Icons.home_outlined, label: 'Home'),
      (icon: Icons.storefront_outlined, label: 'Sales'),
      (icon: Icons.receipt_long_outlined, label: 'Orders'),
      (icon: Icons.restaurant_menu_outlined, label: 'Meals'),
      (icon: Icons.person_outline, label: 'Profile'),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final selected = index == currentIndex;
            final color = selected ? const Color(0xFF10B981) : const Color(0xFF94A3B8);
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 2,
                        width: 26,
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF10B981) : Colors.transparent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(items[index].icon, size: 22, color: color),
                      const SizedBox(height: 4),
                      Text(
                        items[index].label,
                        style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.w600 : FontWeight.w500, color: color),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class OrdersFlutterPage extends StatelessWidget {
  const OrdersFlutterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: const [
            _TopBar(),
            SizedBox(height: 16),
            _TimeSlotsRow(),
            SizedBox(height: 16),
            _StatusBar(),
            SizedBox(height: 24),
            _Section(
              title: 'NEW',
              count: 4,
              emphasize: true,
              items: [
                _OrderItemData(
                  title: 'Cheesecake Box',
                  meta: 'Aymen Mokhtari · #297980 · Pickup',
                  status: 'Pending confirmation',
                  time: 'In 32 min',
                  statusDot: _StatusDot.pending,
                  primaryAction: 'Confirm',
                  secondaryAction: 'Decline',
                ),
                _OrderItemData(
                  title: 'Chocolate Snacks Bundle',
                  meta: 'Lina Barakat · #297982 · Delivery',
                  status: 'Pending confirmation',
                  time: 'In 43 min',
                  statusDot: _StatusDot.pending,
                  primaryAction: 'Confirm',
                  secondaryAction: 'Decline',
                ),
                _OrderItemData(
                  title: 'Protein Lunch Bowl',
                  meta: 'Rayan Salem · #297989 · Pickup',
                  status: 'Pending confirmation',
                  time: '12:11',
                  statusDot: _StatusDot.pending,
                  primaryAction: 'Confirm',
                  secondaryAction: 'Decline',
                ),
                _OrderItemData(
                  title: 'Vegan Wrap Pack',
                  meta: 'Nada Khoury · #297991 · Delivery',
                  status: 'Pending confirmation',
                  time: '12:14',
                  statusDot: _StatusDot.pending,
                  primaryAction: 'Confirm',
                  secondaryAction: 'Decline',
                ),
              ],
            ),
            _Section(
              title: 'IN PROGRESS',
              count: 4,
              items: [
                _OrderItemData(
                  title: 'Daily Hot Meal',
                  meta: 'Nour Haddad · #297977 · Scheduled pickup',
                  status: 'Ready for pickup',
                  time: '12:45',
                  statusDot: _StatusDot.ready,
                  primaryAction: 'Confirm pickup',
                ),
                _OrderItemData(
                  title: 'Weekly Meal Plan',
                  meta: 'Sami Obaid · #297981 · Scheduled delivery',
                  status: 'Driver arriving',
                  time: '13:30',
                  statusDot: _StatusDot.preparing,
                  primaryAction: 'Confirm delivery',
                ),
                _OrderItemData(
                  title: 'Family Dinner Set',
                  meta: 'Tareq Hamdan · #297973 · Scheduled delivery',
                  status: 'Awaiting handoff',
                  time: '14:05',
                  statusDot: _StatusDot.preparing,
                  primaryAction: 'Confirm delivery',
                ),
                _OrderItemData(
                  title: 'Office Meal Tray',
                  meta: 'Mira Issa · #297969 · Scheduled pickup',
                  status: 'Preparing',
                  time: '14:20',
                  statusDot: _StatusDot.preparing,
                  primaryAction: 'Confirm pickup',
                ),
              ],
            ),
            _Section(
              title: 'COMPLETED',
              count: 4,
              items: [
                _OrderItemData(
                  title: 'Falafel Wrap Combo',
                  meta: 'Youssef Naim · #297965 · Pickup',
                  status: 'Completed',
                  time: '11:14',
                  statusDot: _StatusDot.completed,
                  isCompleted: true,
                ),
                _OrderItemData(
                  title: 'Fruit Bowl Pack',
                  meta: 'Nour Haddad · #297970 · Delivery',
                  status: 'Completed',
                  time: '11:40',
                  statusDot: _StatusDot.completed,
                  isCompleted: true,
                ),
                _OrderItemData(
                  title: 'Chicken Rice Box',
                  meta: 'Salma Jaber · #297954 · Pickup',
                  status: 'Completed',
                  time: '10:52',
                  statusDot: _StatusDot.completed,
                  isCompleted: true,
                ),
                _OrderItemData(
                  title: 'Keto Snack Kit',
                  meta: 'Hadi Nasser · #297948 · Delivery',
                  status: 'Completed',
                  time: '10:35',
                  statusDot: _StatusDot.completed,
                  isCompleted: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Orders',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF64748B),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          child: const Text('Focus mode'),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
          color: const Color(0xFF64748B),
        ),
      ],
    );
  }
}

class _TimeSlotsRow extends StatelessWidget {
  const _TimeSlotsRow();

  static const _slots = ['All day', '08–10', '10–12', '12–14', '14–16', '16–18', '18–20', '20–22'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _slots
            .map(
              (slot) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  height: 34,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: slot == 'All day' ? const Color(0x1A16A34A) : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    slot,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: slot == 'All day' ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Store online · Auto refresh 20s',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
          ),
        ),
        const Text(
          'Open',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF16A34A)),
        ),
        const SizedBox(width: 8),
        Switch(value: true, onChanged: null),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.count,
    required this.items,
    this.emphasize = false,
  });

  final String title;
  final int count;
  final List<_OrderItemData> items;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                    color: emphasize ? const Color(0xFF374151) : const Color(0xFF6B7280),
                  ),
                ),
              ),
              Text(
                '$count',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
              ),
              const SizedBox(width: 8),
              const Text('⌄', style: TextStyle(fontSize: 18, color: Color(0xFF6B7280))),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < items.length; i++) ...[
            _OrderRow(data: items[i]),
            if (i != items.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 44),
                child: Divider(height: 1, thickness: 1, color: Color.fromRGBO(15, 23, 42, 0.06)),
              ),
          ],
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.data});

  final _OrderItemData data;

  @override
  Widget build(BuildContext context) {
    final textColor = data.isCompleted ? const Color(0xE60F172A) : const Color(0xFF0F172A);
    final metaColor = data.isCompleted ? const Color(0xB364748B) : const Color(0xFF6B7280);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.topCenter,
            child: Icon(
              data.icon,
              size: 20,
              color: data.isCompleted ? const Color(0x806B7280) : const Color(0xE66B7280),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      data.time,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: data.timeColor,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(data.meta, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: metaColor)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(color: data.statusColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        data.status,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: metaColor),
                      ),
                    ),
                  ],
                ),
                if (data.primaryAction != null) ...[
                  const SizedBox(height: 12),
                  if (data.secondaryAction != null)
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 38,
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFF3F4F6),
                                foregroundColor: const Color(0xFF6B7280),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
                              ),
                              child: Text(data.secondaryAction!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PrimaryButton(label: data.primaryAction!),
                        ),
                      ],
                    )
                  else
                    Align(
                      alignment: Alignment.centerRight,
                      child: _PrimaryButton(label: data.primaryAction!),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF10B981),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Text(label),
      ),
    );
  }
}

enum _StatusDot { pending, preparing, ready, completed }

class _OrderItemData {
  const _OrderItemData({
    required this.title,
    required this.meta,
    required this.status,
    required this.time,
    required this.statusDot,
    this.primaryAction,
    this.secondaryAction,
    this.isCompleted = false,
  });

  final String title;
  final String meta;
  final String status;
  final String time;
  final _StatusDot statusDot;
  final String? primaryAction;
  final String? secondaryAction;
  final bool isCompleted;

  Color get statusColor {
    switch (statusDot) {
      case _StatusDot.pending:
        return const Color(0xFFF59E0B);
      case _StatusDot.preparing:
        return const Color(0xFF22C55E);
      case _StatusDot.ready:
        return const Color(0xFF0EA5E9);
      case _StatusDot.completed:
        return const Color(0xFF9CA3AF);
    }
  }

  Color get timeColor {
    if (time.startsWith('Late')) return const Color(0xFFEF4444);
    if (time.startsWith('In ')) return const Color(0xFFF59E0B);
    return const Color(0xFF6B7280);
  }

  IconData get icon {
    if (meta.contains('Delivery')) return Icons.local_shipping_outlined;
    if (meta.contains('pickup')) return Icons.storefront_outlined;
    return Icons.lunch_dining_outlined;
  }
}

class SalesChannelsPage extends StatefulWidget {
  const SalesChannelsPage({super.key});

  @override
  State<SalesChannelsPage> createState() => _SalesChannelsPageState();
}

class _SalesChannelsPageState extends State<SalesChannelsPage> {
  SalesFilter _filter = SalesFilter.all;

  List<SalesChannel> get _filtered {
    if (_filter == SalesFilter.all) return salesChannels;
    return salesChannels.where((item) => item.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sales', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                        SizedBox(height: 4),
                        Text(
                          'Manage what customers can order',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const _PlaceholderPage(title: 'Create Channel')),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Ink(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.add, color: Color(0xFF0F172A)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: SalesFilter.values.map((filter) {
                  final selected = _filter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter.label),
                      selected: selected,
                      onSelected: (_) => setState(() => _filter = filter),
                      backgroundColor: const Color(0xFFF5F6F7),
                      selectedColor: const Color(0xFFEAF8F1),
                      shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                        color: selected ? const Color(0xFF166534) : const Color(0xFF475569),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemBuilder: (context, index) {
                  final channel = _filtered[index];
                  return _SalesChannelTile(
                    channel: channel,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => SalesChannelDetailPage(channel: channel)),
                      );
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemCount: _filtered.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesChannelTile extends StatelessWidget {
  const _SalesChannelTile({required this.channel, required this.onTap});

  final SalesChannel channel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x0F000000), blurRadius: 2, offset: Offset(0, 1)),
            BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: Color(0xFFF3F4F6), shape: BoxShape.circle),
              child: Icon(channel.type.icon, size: 19, color: const Color(0xFF64748B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channel.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                        ),
                      ),
                      _Tag(text: channel.type.label, bg: const Color(0xFFF1F5F9), fg: const Color(0xFF334155)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Tag(text: channel.status.label, bg: channel.status.bgColor, fg: channel.status.textColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          channel.ruleText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${channel.kpiValue}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                ),
                Text(
                  channel.kpiLabel,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.bg, required this.fg});

  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class SalesChannelDetailPage extends StatelessWidget {
  const SalesChannelDetailPage({super.key, required this.channel});

  final SalesChannel channel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(channel.name)),
      body: Center(
        child: Text(
          '${channel.name} details placeholder',
          style: const TextStyle(fontSize: 16, color: Color(0xFF334155)),
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title page',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
        ),
      ),
    );
  }
}

enum SalesFilter {
  all('All'),
  active('Active'),
  draft('Draft'),
  paused('Paused');

  const SalesFilter(this.label);
  final String label;
}

enum SalesChannelType {
  tiffin('Tiffin', Icons.lunch_dining_outlined),
  weeklyPlan('Weekly Plan', Icons.calendar_today_outlined),
  shop('Shop', Icons.shopping_bag_outlined);

  const SalesChannelType(this.label, this.icon);
  final String label;
  final IconData icon;
}

extension SalesFilterStyle on SalesFilter {
  Color get bgColor {
    switch (this) {
      case SalesFilter.active:
        return const Color(0xFFEAF8F1);
      case SalesFilter.draft:
        return const Color(0xFFFFF7E6);
      case SalesFilter.paused:
        return const Color(0xFFF3F4F6);
      case SalesFilter.all:
        return const Color(0xFFF3F4F6);
    }
  }

  Color get textColor {
    switch (this) {
      case SalesFilter.active:
        return const Color(0xFF166534);
      case SalesFilter.draft:
        return const Color(0xFF9A6700);
      case SalesFilter.paused:
        return const Color(0xFF6B7280);
      case SalesFilter.all:
        return const Color(0xFF475569);
    }
  }
}

class SalesChannel {
  const SalesChannel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.ruleText,
    required this.kpiValue,
    required this.kpiLabel,
    this.shopItemsCount,
  });

  final String id;
  final String name;
  final SalesChannelType type;
  final SalesFilter status;
  final String ruleText;
  final int kpiValue;
  final String kpiLabel;
  final int? shopItemsCount;
}

const List<SalesChannel> salesChannels = [
  SalesChannel(
    id: 'ch_001',
    name: 'Indian Food',
    type: SalesChannelType.tiffin,
    status: SalesFilter.active,
    ruleText: 'Weekdays • Preorder 24h',
    kpiValue: 34,
    kpiLabel: 'Orders today',
  ),
  SalesChannel(
    id: 'ch_002',
    name: 'Office Tiffin',
    type: SalesChannelType.tiffin,
    status: SalesFilter.paused,
    ruleText: 'Every day • Preorder 24h',
    kpiValue: 0,
    kpiLabel: 'Orders today',
  ),
  SalesChannel(
    id: 'ch_003',
    name: 'Weekly Lunch Plan',
    type: SalesChannelType.weeklyPlan,
    status: SalesFilter.active,
    ruleText: '5 meals/week • Mon–Fri',
    kpiValue: 52,
    kpiLabel: 'Subscribers',
  ),
  SalesChannel(
    id: 'ch_004',
    name: 'Family Meal Plan',
    type: SalesChannelType.weeklyPlan,
    status: SalesFilter.draft,
    ruleText: '7 meals/week • Mon–Sun',
    kpiValue: 12,
    kpiLabel: 'Subscribers',
  ),
  SalesChannel(
    id: 'ch_005',
    name: 'Yuma Shop',
    type: SalesChannelType.shop,
    status: SalesFilter.active,
    ruleText: 'Order anytime • 48 items',
    kpiValue: 18,
    kpiLabel: 'Orders today',
    shopItemsCount: 48,
  ),
  SalesChannel(
    id: 'ch_006',
    name: 'Healthy Snacks Shop',
    type: SalesChannelType.shop,
    status: SalesFilter.active,
    ruleText: 'Order anytime • 31 items',
    kpiValue: 11,
    kpiLabel: 'Orders today',
    shopItemsCount: 31,
  ),
];
