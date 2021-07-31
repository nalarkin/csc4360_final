import 'dart:async';
import 'dart:collection';

import 'package:event_repository/event_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_notifier/calendar/view/calendar_create_event_page.dart';
import 'package:school_notifier/messages/message.dart';
import 'package:school_notifier/profile/profile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:school_notifier/authentication/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util.dart';

class CalendarPage extends StatefulWidget {
  static const String routeName = '/calendar_page';

  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  LinkedHashMap<DateTime, List<FirestoreEvent>> eventBuilder =
      LinkedHashMap<DateTime, List<FirestoreEvent>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  late StreamSubscription _eventStreamMap;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDay;
  FirestoreEvent newEvent = FirestoreEvent(
      title: 'Teacher Event',
      posterID: 'posterID',
      eventStartTime: DateTime.now(),
      eventEndTime: DateTime.now(),
      eventType: 'Teacher Event',
      eventSubscriptionID: 'eventSubscriptionID');

  TextEditingController _eventController = TextEditingController();
  @override
  void initState() {
    _selectedDay = _focusedDate;
    _eventStreamMap = context
        .read<EventRepository>()
        .combineAllStreamsToMap(
            context.read<ProfileBloc>().state.user.classes?.keys.toList() ?? [])
        .listen(updateTheState);

    super.initState();
  }

  void updateTheState(LinkedHashMap<DateTime, List<FirestoreEvent>> events) {
    setState(() {
      eventBuilder = events;
    });
  }

  @override
  void dispose() {
    _eventController.dispose();
    _eventStreamMap.cancel();

    super.dispose();
  }

  List<FirestoreEvent> _getEventsForDay(DateTime day) {
    return eventBuilder[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _currDateTime = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher's Calendar"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context
                .read<AuthenticationBloc>()
                .add(AuthenticationLogoutRequested()),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(
                  _currDateTime.year, _currDateTime.month, _currDateTime.day),
              lastDay: DateTime.utc(2030, 10, 30),
              focusedDay: _focusedDate,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDate = focusedDay;
                  });
                }
              },
              eventLoader: _getEventsForDay,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDate = focusedDay;
              },
            ),
            ..._getEventsForDay(_focusedDate).map(
              (FirestoreEvent event) => ListTile(
                title: Row(
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.bodyText1,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      formatDateEventStartToEndTime(
                          event.eventStartTime, event.eventEndTime),
                      style: theme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text("Add Event"),
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, CalendarAddEventPage.routeName,
                arguments: _focusedDate);
          }),
    );
  }
}
