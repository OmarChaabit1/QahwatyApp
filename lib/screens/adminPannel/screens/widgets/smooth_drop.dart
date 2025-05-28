import 'package:flutter/material.dart';

enum TimeRange {
  lastDay,
  last3days,
  last7Days,
  last30Days,
  thisMonth,
  all,
}

class SmoothDropdown extends StatefulWidget {
  final TimeRange selectedRange;
  final Function(TimeRange?) onTimeRangeChanged;
  const SmoothDropdown({
    super.key,
    required this.selectedRange,
    required this.onTimeRangeChanged,
  });

  @override
  State<SmoothDropdown> createState() => _SmoothDropdownState();
}

class _SmoothDropdownState extends State<SmoothDropdown>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _arrowAnimationController;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _arrowAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(
        CurvedAnimation(parent: _arrowAnimationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _arrowAnimationController.forward();
      } else {
        _arrowAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final kCardLight = const Color.fromARGB(255, 251, 241, 234);
    final kText = const Color(0xFF1E1E2C);
    final items = <DropdownMenuItem<TimeRange>>[
      DropdownMenuItem(value: TimeRange.lastDay, child: Text('Yesterday')),
      DropdownMenuItem(value: TimeRange.last3days, child: Text('Last 3 Days')),
      DropdownMenuItem(value: TimeRange.last7Days, child: Text('Last 7 Days')),
      DropdownMenuItem(value: TimeRange.last30Days, child: Text('Last 30 Days')),
      DropdownMenuItem(value: TimeRange.thisMonth, child: Text('This Month')),
      DropdownMenuItem(value: TimeRange.all, child: Text('All Time')),
    ];

    String selectedText = items
            .firstWhere((item) => item.value == widget.selectedRange)
            .child
            .toString() ??
        '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: kCardLight,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  items
                      .firstWhere((item) => item.value == widget.selectedRange)
                      .child
                      .toString()
                      .replaceAll('Text("', '')
                      .replaceAll('")', ''),
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16,
                    color: kText.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RotationTransition(
                  turns: _arrowAnimation,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: kText.withOpacity(0.8),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _isOpen
              ? Container(
                  key: ValueKey('dropdown_menu'),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: kCardLight,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Divider(
                      color: kText.withOpacity(0.15),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      bool selected = item.value == widget.selectedRange;
                      return ListTile(
                        title: Text(
                          item.child.toString().replaceAll('Text("', '').replaceAll('")', ''),
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            color: selected
                                ? Theme.of(context).primaryColor
                                : kText.withOpacity(0.85),
                          ),
                        ),
                        onTap: () {
                          widget.onTimeRangeChanged(item.value);
                          _toggleDropdown();
                        },
                      );
                    },
                  ),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
