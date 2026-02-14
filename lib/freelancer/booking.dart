import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

// -----------------------------------------------------------------------------
// MAIN ENTRY POINT
// -----------------------------------------------------------------------------

void main() {
  runApp(const booking());
}

class booking extends StatelessWidget {
  const booking({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talent Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4F46E5),
        scaffoldBackgroundColor: const Color(0xFFF8F9FC),
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          primary: const Color(0xFF4F46E5),
          surface: Colors.white,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// MODELS
// -----------------------------------------------------------------------------

enum BookingStatus { pending, accepted, rejected }

class Booking {
  final String id;
  final String clientName;
  final String? clientAvatar;
  final String serviceType;
  final DateTime dateTime;
  BookingStatus status;

  Booking({
    required this.id,
    required this.clientName,
    this.clientAvatar,
    required this.serviceType,
    required this.dateTime,
    this.status = BookingStatus.pending,
  });
}

class Slot {
  final String id;
  final DateTime dateTime;

  Slot({required this.id, required this.dateTime});
}

class CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;

  CalendarDay({required this.date, required this.isCurrentMonth});
}

// -----------------------------------------------------------------------------
// UTILS
// -----------------------------------------------------------------------------

class DateHelper {
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  static int getFirstDayOfMonth(DateTime date) {
    // 1 = Monday, 7 = Sunday in DateTime
    final weekday = DateTime(date.year, date.month, 1).weekday;
    return weekday == 7 ? 0 : weekday;
  }

  static List<CalendarDay> generateCalendarDays(DateTime focusedDate) {
    final year = focusedDate.year;
    final month = focusedDate.month;
    final daysInMonth = getDaysInMonth(focusedDate);
    final firstDayOfWeek = getFirstDayOfMonth(focusedDate); // 0=Sun

    final days = <CalendarDay>[];

    // Previous month padding
    final prevMonthDate = DateTime(year, month, 0);
    final prevMonthDays = prevMonthDate.day;
    
    for (int i = firstDayOfWeek - 1; i >= 0; i--) {
      days.add(CalendarDay(
        date: DateTime(year, month - 1, prevMonthDays - i),
        isCurrentMonth: false,
      ));
    }

    // Current month
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(CalendarDay(
        date: DateTime(year, month, i),
        isCurrentMonth: true,
      ));
    }

    // Next month padding
    final remainingCells = 42 - days.length;
    for (int i = 1; i <= remainingCells; i++) {
      days.add(CalendarDay(
        date: DateTime(year, month + 1, i),
        isCurrentMonth: false,
      ));
    }

    return days;
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d').format(date);
  }

  static String getMonthName(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
}

// -----------------------------------------------------------------------------
// DASHBOARD SCREEN
// -----------------------------------------------------------------------------

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  
  // Dummy Data
  final List<Booking> _bookings = [
    Booking(
      id: '1',
      clientName: 'Ananya Sharma',
      serviceType: 'Portrait Photography',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 2)), // Tomorrow
      status: BookingStatus.pending,
    ),
    Booking(
      id: '2',
      clientName: 'Rahul Verma',
      serviceType: 'Music Video Editing',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 5)),
      status: BookingStatus.pending,
    ),
    Booking(
      id: '3',
      clientName: 'Sarah Jenkins',
      serviceType: 'Logo Design',
      dateTime: DateTime.now(),
      status: BookingStatus.accepted,
    ),
  ];

  final List<Slot> _slots = [
    Slot(id: '1', dateTime: DateTime.now().copyWith(hour: 14, minute: 0)),
    Slot(id: '2', dateTime: DateTime.now().copyWith(hour: 16, minute: 0)),
  ];

  // Actions
  void _addSlot(TimeOfDay time) {
    final newDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      time.hour,
      time.minute,
    );

    // Prevent duplicates
    if (_slots.any((s) => s.dateTime == newDate)) return;

    setState(() {
      _slots.add(Slot(id: DateTime.now().toString(), dateTime: newDate));
    });
  }

  void _deleteSlot(Slot slot) {
    setState(() {
      _slots.removeWhere((s) => s.id == slot.id);
    });
  }

  void _acceptBooking(Booking booking) {
    setState(() {
      booking.status = BookingStatus.accepted;
    });
  }

  void _rejectBooking(Booking booking) {
    setState(() {
      booking.status = BookingStatus.rejected;
    });
  }

  void _showAddSlotDialog() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      _addSlot(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final dailyBookings = _bookings.where((b) => DateHelper.isSameDay(b.dateTime, _selectedDate)).toList();
    final dailySlots = _slots.where((s) => DateHelper.isSameDay(s.dateTime, _selectedDate)).toList();

    return Scaffold(
      body: Row(
        children: [
          // Sidebar (Desktop only)
          if (isDesktop) const _Sidebar(),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                _Header(isDesktop: isDesktop),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Mobile Calendar
                        if (!isDesktop) ...[
                          CalendarWidget(
                            focusedDate: _focusedDate,
                            selectedDate: _selectedDate,
                            onDateSelect: (d) => setState(() => _selectedDate = d),
                            onMonthChange: (d) => setState(() => _focusedDate = d),
                            bookings: _bookings,
                            slots: _slots,
                          ),
                          const SizedBox(height: 24),
                        ],
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column (Desktop Calendar & Stats)
                            if (isDesktop)
                              Expanded(
                                flex: 7,
                                child: Column(
                                  children: [
                                    CalendarWidget(
                                      focusedDate: _focusedDate,
                                      selectedDate: _selectedDate,
                                      onDateSelect: (d) => setState(() => _selectedDate = d),
                                      onMonthChange: (d) => setState(() => _focusedDate = d),
                                      bookings: _bookings,
                                      slots: _slots,
                                    ),
                                    const SizedBox(height: 24),
                                    // Stats Cards
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _StatCard(
                                            title: 'Pending Requests',
                                            count: _bookings.where((b) => b.status == BookingStatus.pending).length,
                                            color: const Color(0xFF4F46E5),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _StatCard(
                                            title: 'Upcoming Jobs',
                                            count: _bookings.where((b) => b.status == BookingStatus.accepted).length,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            if (isDesktop) const SizedBox(width: 32),

                            // Right Column (Daily Overview)
                            Expanded(
                              flex: isDesktop ? 5 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Daily Header
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateHelper.formatDate(_selectedDate),
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          const Text(
                                            'Daily Overview',
                                            style: TextStyle(
                                              color: Color(0xFF64748B),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: _showAddSlotDialog,
                                        icon: const Icon(LucideIcons.plus, size: 16),
                                        label: const Text('Add Slot'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF4F46E5),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          elevation: 4,
                                          shadowColor: const Color(0xFF4F46E5).withOpacity(0.4),
                                        ),
                                      ).animate().scale(delay: 200.ms),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Slots List
                                  _SectionTitle('Available Slots'),
                                  if (dailySlots.isEmpty)
                                    _EmptyState(text: 'No slots added for this day.'),
                                  ...dailySlots.map((slot) => SlotCard(
                                    slot: slot,
                                    onDelete: _deleteSlot,
                                  )),

                                  const SizedBox(height: 24),

                                  // Bookings List
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _SectionTitle('Requests & Jobs'),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${dailyBookings.length}',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (dailyBookings.isEmpty)
                                    _EmptyState(text: 'No bookings for this date.'),
                                  ...dailyBookings.map((booking) => BookingCard(
                                    booking: booking,
                                    onAccept: _acceptBooking,
                                    onReject: _rejectBooking,
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGETS
// -----------------------------------------------------------------------------

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDate;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelect;
  final Function(DateTime) onMonthChange;
  final List<Booking> bookings;
  final List<Slot> slots;

  const CalendarWidget({
    super.key,
    required this.focusedDate,
    required this.selectedDate,
    required this.onDateSelect,
    required this.onMonthChange,
    required this.bookings,
    required this.slots,
  });

  Map<String, bool> _getDayStatus(DateTime date) {
    final hasBooking = bookings.any((b) => DateHelper.isSameDay(b.dateTime, date));
    final hasPending = bookings.any((b) => 
        DateHelper.isSameDay(b.dateTime, date) && b.status == BookingStatus.pending);
    final hasAccepted = bookings.any((b) => 
        DateHelper.isSameDay(b.dateTime, date) && b.status == BookingStatus.accepted);
    final hasSlot = slots.any((s) => DateHelper.isSameDay(s.dateTime, date));

    return {
      'hasBooking': hasBooking,
      'hasPending': hasPending,
      'hasAccepted': hasAccepted,
      'hasSlot': hasSlot,
    };
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = DateHelper.generateCalendarDays(focusedDate);
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateHelper.getMonthName(focusedDate),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => onMonthChange(DateTime(
                        focusedDate.year, focusedDate.month - 1, 1)),
                    color: Colors.grey.shade600,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () => onMonthChange(DateTime(
                        focusedDate.year, focusedDate.month + 1, 1)),
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),

          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: calendarDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final dayItem = calendarDays[index];
              final isSelected = DateHelper.isSameDay(dayItem.date, selectedDate);
              final isToday = DateHelper.isSameDay(dayItem.date, DateTime.now());
              final status = _getDayStatus(dayItem.date);

              return GestureDetector(
                onTap: () => onDateSelect(dayItem.date),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4F46E5) : 
                               isToday ? Colors.transparent : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isToday && !isSelected 
                            ? Border.all(color: const Color(0xFF4F46E5)) 
                            : null,
                        boxShadow: isSelected 
                            ? [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] 
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${dayItem.date.day}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : 
                                   !dayItem.isCurrentMonth ? Colors.grey.shade300 : Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (status['hasAccepted'] == true)
                          _buildDot(Colors.green),
                        if (status['hasPending'] == true)
                          _buildDot(Colors.amber),
                        if (status['hasSlot'] == true && status['hasBooking'] == false)
                          _buildDot(Colors.blue.shade300),
                      ],
                    ),
                  ],
                ),
              ).animate().fade(delay: (index * 10).ms).scale();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      width: 4,
      height: 4,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final Function(Booking) onAccept;
  final Function(Booking) onReject;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onAccept,
    required this.onReject,
  });

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.accepted:
        return Colors.green.shade700;
      case BookingStatus.rejected:
        return Colors.red.shade700;
      default:
        return Colors.amber.shade700;
    }
  }

  Color _getStatusBg(BookingStatus status) {
    switch (status) {
      case BookingStatus.accepted:
        return Colors.green.shade50;
      case BookingStatus.rejected:
        return Colors.red.shade50;
      default:
        return Colors.amber.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: booking.clientAvatar == null 
                      ? const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)])
                      : null,
                  image: booking.clientAvatar != null 
                      ? DecorationImage(image: NetworkImage(booking.clientAvatar!), fit: BoxFit.cover)
                      : null,
                  shape: BoxShape.circle,
                ),
                child: booking.clientAvatar == null
                    ? Center(
                        child: Text(
                          booking.clientName[0],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          booking.clientName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusBg(booking.status),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getStatusColor(booking.status).withOpacity(0.2)),
                          ),
                          child: Text(
                            booking.status.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(booking.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(LucideIcons.briefcase, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
                        Text(
                          booking.serviceType,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(LucideIcons.clock, size: 14, color: Color(0xFF4F46E5)),
                        const SizedBox(width: 4),
                        Text(
                          DateHelper.formatTime(booking.dateTime),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (booking.status == BookingStatus.pending) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActionButton(
                  icon: LucideIcons.check,
                  color: Colors.green,
                  onTap: () => onAccept(booking),
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: LucideIcons.x,
                  color: Colors.red,
                  onTap: () => onReject(booking),
                ),
              ],
            ),
          ]
        ],
      ),
    ).animate().fadeIn().slideX();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}

class SlotCard extends StatelessWidget {
  final Slot slot;
  final Function(Slot) onDelete;

  const SlotCard({super.key, required this.slot, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(LucideIcons.clock, size: 16, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(width: 12),
              Text(
                DateHelper.formatTime(slot.dateTime),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(LucideIcons.trash2, size: 18),
            color: Colors.grey.shade400,
            hoverColor: Colors.red.shade50,
            onPressed: () => onDelete(slot),
          ),
        ],
      ),
    ).animate().fadeIn().slideY();
  }
}

class _Header extends StatelessWidget {
  final bool isDesktop;
  const _Header({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (!isDesktop) 
            IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
          Text(
            'Booking Manager',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Stack(
              children: [
                const Icon(LucideIcons.bell, size: 22, color: Colors.grey),
                Positioned(
                  top: 0, right: 0,
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            backgroundImage: NetworkImage('https://picsum.photos/200'),
            radius: 20,
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
      color: Colors.white,
     border: Border(
      right: BorderSide(color:
       Colors.grey[200]!,
       width: 1,
      ),
     ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.briefcase, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                    children: [
                      TextSpan(text: 'Talent'),
                      TextSpan(text: 'Connect', style: TextStyle(color: Color(0xFF1E293B))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _NavItem(icon: LucideIcons.layoutDashboard, label: 'Overview'),
                _NavItem(icon: LucideIcons.calendar, label: 'Bookings', isActive: true),
                _NavItem(icon: LucideIcons.messageSquare, label: 'Messages', badge: 3),
                _NavItem(icon: LucideIcons.search, label: 'Find Gigs'),
                _NavItem(icon: LucideIcons.settings, label: 'Settings'),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pro Member', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Boost your visibility by 50%', style: TextStyle(color: Colors.indigo.shade100, fontSize: 12)),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('Upgrade Now', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final int? badge;

  const _NavItem({required this.icon, required this.label, this.isActive = false, this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEEF2FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFF4F46E5) : Colors.grey.shade400,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF4F46E5) : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            : null,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade400,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _StatCard({required this.title, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8))),
          const SizedBox(height: 8),
          Text('$count', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    ).animate().fadeIn().slideY();
  }
}
