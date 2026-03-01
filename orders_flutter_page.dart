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
  late final List<SalesDashboardChannel> _channels = [
    SalesDashboardChannel(
      id: 'weekly_plan',
      name: 'Weekly Plan',
      subtitle: 'Subscription · Weekly delivery',
      icon: Icons.calendar_month_outlined,
      iconTint: const Color(0xFF10B981),
      iconBg: const Color(0x1410B981),
      isAccepting: true,
      kpis: const [
        SalesKpi(icon: Icons.group_outlined, label: 'Active subscribers (this week)', value: '42'),
        SalesKpi(icon: Icons.receipt_long_outlined, label: 'Total orders', value: '68'),
        SalesKpi(icon: Icons.euro_outlined, label: 'Revenue (this week)', value: '€3,240'),
        SalesKpi(icon: Icons.grid_view_outlined, label: 'Reserved', value: '—', subtle: true),
      ],
    ),
    SalesDashboardChannel(
      id: 'tiffin',
      name: 'Tiffin',
      subtitle: 'Hot meals · Daily/Weekdays',
      icon: Icons.rice_bowl_outlined,
      iconTint: const Color(0xFFB7791F),
      iconBg: const Color(0x14B7791F),
      isAccepting: true,
      kpis: const [
        SalesKpi(icon: Icons.shopping_bag_outlined, label: 'Orders today', value: '16'),
        SalesKpi(icon: Icons.paid_outlined, label: 'Revenue today', value: '€184'),
        SalesKpi(icon: Icons.groups_outlined, label: 'Active customers (30 days)', value: '102'),
        SalesKpi(icon: Icons.event_note_outlined, label: 'Meals scheduled (this week)', value: '87'),
      ],
    ),
    SalesDashboardChannel(
      id: 'shop',
      name: 'Shop',
      subtitle: 'Sweets · Beverages · Cakes · Catering',
      icon: Icons.storefront_outlined,
      iconTint: const Color(0xFF0F766E),
      iconBg: const Color(0x140F766E),
      isAccepting: true,
      kpis: const [
        SalesKpi(icon: Icons.shopping_bag_outlined, label: 'Orders today', value: '24'),
        SalesKpi(icon: Icons.paid_outlined, label: 'Revenue today', value: '€312'),
        SalesKpi(icon: Icons.schedule_outlined, label: 'Upcoming scheduled (7 days)', value: '19'),
        SalesKpi(icon: Icons.timer_outlined, label: 'Avg fulfillment time (today)', value: '32 min'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const Text(
              'Sales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
            ),
            const SizedBox(height: 16),
            ..._channels.map((channel) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _SalesDashboardCard(
                  channel: channel,
                  onOpen: () => _openChannel(channel),
                  onToggle: (value) => _handleToggle(channel, value),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _openChannel(SalesDashboardChannel channel) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => SalesChannelDetailPage(channel: channel)));
  }

  void _handleToggle(SalesDashboardChannel channel, bool nextValue) {
    if (nextValue) {
      setState(() => channel.isAccepting = true);
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pause ${channel.name} orders?',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Existing orders stay active; new orders will be blocked until you resume.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => channel.isAccepting = false);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Pause orders'),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Keep accepting',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SalesDashboardCard extends StatelessWidget {
  const _SalesDashboardCard({
    required this.channel,
    required this.onOpen,
    required this.onToggle,
  });

  final SalesDashboardChannel channel;
  final VoidCallback onOpen;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Ink(
          height: 204,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 72,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: channel.iconBg, shape: BoxShape.circle),
                        child: Icon(channel.icon, size: 24, color: channel.iconTint),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              channel.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF111827)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              channel.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            channel.isAccepting ? 'Accepting' : 'Paused',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: channel.isAccepting ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Switch(
                                value: channel.isAccepting,
                                onChanged: onToggle,
                                activeColor: const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, size: 18, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _KpiCell(kpi: channel.kpis[0])),
                          const VerticalDivider(width: 1, color: Color(0xFFF1F5F9), thickness: 1),
                          Expanded(child: _KpiCell(kpi: channel.kpis[1])),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _KpiCell(kpi: channel.kpis[2])),
                          const VerticalDivider(width: 1, color: Color(0xFFF1F5F9), thickness: 1),
                          Expanded(child: _KpiCell(kpi: channel.kpis[3])),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiCell extends StatelessWidget {
  const _KpiCell({required this.kpi});

  final SalesKpi kpi;

  @override
  Widget build(BuildContext context) {
    final valueColor = kpi.subtle ? const Color(0xFF9CA3AF) : const Color(0xFF111827);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(kpi.icon, size: 18, color: const Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  kpi.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            kpi.value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }
}

class SalesChannelDetailPage extends StatelessWidget {
  const SalesChannelDetailPage({super.key, required this.channel});

  final SalesDashboardChannel channel;

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

class SalesDashboardChannel {
  SalesDashboardChannel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.iconTint,
    required this.iconBg,
    required this.kpis,
    required this.isAccepting,
  });

  final String id;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color iconTint;
  final Color iconBg;
  final List<SalesKpi> kpis;
  bool isAccepting;
}

class SalesKpi {
  const SalesKpi({
    required this.icon,
    required this.label,
    required this.value,
    this.subtle = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool subtle;
}
