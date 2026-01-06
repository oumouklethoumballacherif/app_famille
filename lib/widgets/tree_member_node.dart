import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/family_member_model.dart';
import '../providers/family_provider.dart';
import '../screens/tree/member_detail_screen.dart';

class TreeMemberNode extends StatefulWidget {
  final FamilyMember member;
  final int depth;
  final bool isLastChild;
  final bool parentHasNext;
  final List<bool> parentLastParams;

  const TreeMemberNode({
    super.key,
    required this.member,
    required this.depth,
    required this.isLastChild,
    required this.parentHasNext,
    this.parentLastParams = const [],
  });

  @override
  State<TreeMemberNode> createState() => _TreeMemberNodeState();
}

class _TreeMemberNodeState extends State<TreeMemberNode>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _iconTurns = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _heightFactor = _controller.view;
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeIn),
      ),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _showMemberDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MemberDetailScreen(member: widget.member),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final familyProvider = context.watch<FamilyProvider>();
    final children = familyProvider.getChildren(widget.member.id);
    final hasChildren = children.isNotEmpty;

    // Organic Palette - Gender-based colors with deceased handling
    final isDeceased = widget.member.status == VitalStatus.deceased;
    final isMale = widget.member.gender == Gender.male;
    final genderColor = isMale
        ? const Color(0xFF5E81AC) // Nordic Blue for male
        : const Color(0xFFD08770); // Soft Orange for female
    final primaryColor = isDeceased
        ? genderColor.withValues(alpha: 0.5)
        : genderColor;
    final cardColor = isDeceased ? Colors.grey[100]! : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Spacers for depth (Invisible structure)
              for (int i = 0; i < widget.depth; i++)
                SizedBox(
                  width: 32, // Indentation unit
                  child: CustomPaint(
                    painter: _VerticalLinePainter(
                      // Only draw vertical line if this depth corresponds to a parent that continues
                      draw:
                          widget.parentLastParams.length > i &&
                          !widget.parentLastParams[i],
                      color: const Color(0xFFE5E9F0), // Very subtle grey
                    ),
                  ),
                ),

              // 2. Connector Curve (The "Organic Thread")
              if (widget.depth > 0)
                SizedBox(
                  width: 32,
                  child: CustomPaint(
                    painter: _OrganicCurvePainter(
                      isLast: widget.isLastChild,
                      color: const Color(0xFFE5E9F0),
                      accentColor: primaryColor,
                    ),
                  ),
                ),

              // 3. Floating Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 16),
                  child: GestureDetector(
                    onTap: () => _showMemberDetail(context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showMemberDetail(context),
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Avatar Group
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Glow behind avatar
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                    Hero(
                                      tag: 'node_${widget.member.id}',
                                      child: CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Colors.white,
                                        backgroundImage:
                                            widget.member.photoUrl != null
                                            ? NetworkImage(
                                                widget.member.photoUrl!,
                                              )
                                            : null,
                                        child: widget.member.photoUrl == null
                                            ? Icon(
                                                Icons.person,
                                                color: primaryColor.withValues(
                                                  alpha: 0.5,
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                    // Status/Gender indicator dot
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: isDeceased
                                              ? Colors.grey[600]
                                              : genderColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          isDeceased
                                              ? Icons.brightness_2
                                              : (isMale
                                                    ? Icons.male
                                                    : Icons.female),
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),

                                // Text Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.member.firstName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: isDeceased
                                              ? const Color(0xFF6B7280)
                                              : const Color(0xFF2E3440),
                                          letterSpacing: 0.2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        widget.member.birthDate.year.toString(),
                                        style: TextStyle(
                                          color: const Color(0xFFAEBACD),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Expand Button (Floating Bubble)
                                if (hasChildren)
                                  InkWell(
                                    onTap: _handleExpand,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _isExpanded
                                            ? primaryColor.withValues(
                                                alpha: 0.1,
                                              )
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          RotationTransition(
                                            turns: _iconTurns,
                                            child: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: _isExpanded
                                                  ? primaryColor
                                                  : const Color(0xFFAEBACD),
                                              size: 20,
                                            ),
                                          ),
                                          if (!_isExpanded) ...[
                                            const SizedBox(width: 4),
                                            Text(
                                              children.length.toString(),
                                              style: const TextStyle(
                                                color: Color(0xFFAEBACD),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 4. Children (Animated)
        if (hasChildren)
          SizeTransition(
            sizeFactor: _heightFactor,
            axisAlignment: -1.0,
            child: FadeTransition(
              opacity: _opacity,
              child: Column(
                children: children.asMap().entries.map((entry) {
                  final index = entry.key;
                  final child = entry.value;
                  final isLast = index == children.length - 1;
                  final newParentLastParams = List<bool>.from(
                    widget.parentLastParams,
                  )..add(widget.isLastChild);

                  return TreeMemberNode(
                    key: ValueKey(child.id),
                    member: child,
                    depth: widget.depth + 1,
                    isLastChild: isLast,
                    parentHasNext: !isLast,
                    parentLastParams: newParentLastParams,
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

// Draws the continuous lineage lines far to the left
class _VerticalLinePainter extends CustomPainter {
  final bool draw;
  final Color color;

  _VerticalLinePainter({required this.draw, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (!draw) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw full vertical line centered in the slot
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _VerticalLinePainter oldDelegate) => false;
}

// Draws the beautiful S-Curve connection
class _OrganicCurvePainter extends CustomPainter {
  final bool isLast;
  final Color color;
  final Color accentColor;

  _OrganicCurvePainter({
    required this.isLast,
    required this.color,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final centerX = w / 2;
    // The curve end point (middle right)
    final endY =
        40.0; // Approximate center of the card height (visual alignment)

    final path = Path();
    path.moveTo(centerX, 0);

    if (isLast) {
      // 1. Line down to just before curve
      // 2. Smooth cubic curve to the right
      path.lineTo(centerX, endY - 15);
      path.cubicTo(
        centerX,
        endY, // Handle 1
        centerX,
        endY, // Handle 2
        w,
        endY, // End
      );
    } else {
      // Line continues down
      path.lineTo(centerX, h);

      // Branch off
      final branch = Path();
      branch.moveTo(centerX, 0);
      branch.lineTo(centerX, endY - 15);
      branch.cubicTo(
        centerX,
        endY, // Handle 1
        centerX,
        endY, // Handle 2
        w,
        endY, // End
      );
      canvas.drawPath(branch, paint);
    }

    canvas.drawPath(path, paint);

    // Draw a small dot at the intersection to mask the joint and add polish
    final dotPaint = Paint()
      ..color = isLast ? accentColor : color
      ..style = PaintingStyle.fill;

    // Small connector dot at the card entry
    canvas.drawCircle(Offset(w, endY), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
