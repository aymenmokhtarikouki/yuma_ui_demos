import 'dart:ui';

import 'package:flutter/material.dart';

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
