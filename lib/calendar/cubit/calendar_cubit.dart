import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:school_notifier/messages/utils/utilis.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit(this._eventRepository, this._posterId, DateTime _selectedDate)
      : super(const CalendarState()) {
    eventSelectedDateChanged(_selectedDate);
  }
  EventRepository _eventRepository;
  String _posterId;

  void eventTitleChanged(String value) {
    final eventTitle = EventTitle.dirty(value);
    emit(state.copyWith(
      eventTitle: eventTitle,
      status: Formz.validate([
        eventTitle,
        state.eventDay,
        state.eventDuration,
        state.eventDescription,
        state.eventMonth,
        state.eventTimeStart,
        state.eventYear,
      ]),
    ));
  }

  void eventTimeStartChanged(String value) {
    final eventTimeStart = EventTimeStart.dirty(value);

    emit(state.copyWith(
      eventTimeStart: eventTimeStart,
      status: Formz.validate([
        eventTimeStart,
        state.eventTitle,
        state.eventDay,
        state.eventDuration,
        state.eventDescription,
        state.eventMonth,
        state.eventYear,
      ]),
    ));
  }

  void eventDurationChanged(String value) {
    final eventDuration = EventDuration.dirty(value);

    emit(state.copyWith(
      eventDuration: eventDuration,
      status: Formz.validate([
        eventDuration,
        state.eventDay,
        state.eventTitle,
        state.eventDescription,
        state.eventMonth,
        state.eventTimeStart,
        state.eventYear,
      ]),
    ));
  }

  void eventMonthChanged(String value) {
    final eventMonth = EventMonth.dirty(value);
    emit(state.copyWith(
      eventMonth: eventMonth,
      status: Formz.validate([
        eventMonth,
        state.eventDay,
        state.eventTitle,
        state.eventDescription,
        state.eventTitle,
        state.eventYear,
        state.eventTimeStart,
      ]),
    ));
  }

  void eventYearChanged(String value) {
    final eventYear = EventYear.dirty(value);
    emit(state.copyWith(
      eventYear: eventYear,
      status: Formz.validate([
        eventYear,
        state.eventDay,
        state.eventDescription,
        state.eventTitle,
        state.eventMonth,
        state.eventTimeStart,
        state.eventTitle,
      ]),
    ));
  }

  void eventSelectedDateChanged(DateTime? value) {
    final eventYear =
        value == null ? EventYear.dirty('') : EventYear.dirty('${value.year}');
    final eventMonth = value == null
        ? EventMonth.dirty('')
        : EventMonth.dirty('${value.month}');
    final eventDay =
        value == null ? EventDay.dirty('') : EventDay.dirty('${value.day}');
    emit(state.copyWith(
      eventYear: eventYear,
      eventMonth: eventMonth,
      eventDay: eventDay,
      eventSelectedDay: value,
      status: Formz.validate([
        eventYear,
        state.eventDay,
        state.eventDescription,
        state.eventTitle,
        state.eventMonth,
        state.eventTimeStart,
        state.eventTitle,
      ]),
    ));
  }

  void eventDayChanged(String value) {
    final eventDay = EventDay.dirty(value);
    emit(state.copyWith(
      eventDay: eventDay,
      status: Formz.validate([
        eventDay,
        state.eventTitle,
        state.eventDescription,
        state.eventTitle,
        state.eventMonth,
        state.eventTimeStart,
        state.eventYear,
      ]),
    ));
  }

  void timeDialogueChanged(TimeOfDay? value) {
    final timeStart = value == null
        ? EventTimeStart.dirty('')
        : EventTimeStart.dirty('${formatTimeOfDay(value)}');

    emit(state.copyWith(
      eventTimeStart: timeStart,
      status: Formz.validate([
        timeStart,
        state.eventTitle,
        state.eventDescription,
        state.eventTitle,
        state.eventDuration,
        state.eventMonth,
        state.eventYear,
      ]),
    ));
  }

  void eventDescriptionChanged(String value) {
    final eventDescription = EventDescription.dirty(value);
    emit(state.copyWith(
      eventDescription: eventDescription,
      status: Formz.validate([
        eventDescription,
        state.eventDuration,
        state.eventDay,
        state.eventTitle,
        state.eventMonth,
        state.eventTimeStart,
        state.eventYear,
      ]),
    ));
  }

  void toggleSubscription(String value) {
    var _newList = state.eventSubscriptionList.toList();

    if (_newList.contains(value)) {
      _newList.remove(value);
    } else {
      _newList.add(value);
    }

    emit(state.copyWith(
      eventSubscriptionList: _newList,
      status: Formz.validate([
        state.eventDuration,
        state.eventDescription,
        state.eventDay,
        state.eventTitle,
        state.eventMonth,
        state.eventTimeStart,
        state.eventYear,
      ]),
    ));
  }

  Future<void> submitNewEvent() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final startTime = convertStringToDateTime(
          state.eventDay.value,
          state.eventMonth.value,
          state.eventYear.value,
          state.eventTimeStart.value);
      final duration = int.tryParse(state.eventDuration.value);
      if (startTime != null && duration != null) {
        final endTime = startTime.add(Duration(minutes: duration));
        FirestoreEvent newEvent = FirestoreEvent(
          eventEndTime: endTime,
          eventStartTime: startTime,
          eventSubscriptionID: '',
          title: state.eventTitle.value,
          description: state.eventDescription.value,
          posterID: _posterId,
        );
        final _listOfEvents = <FirestoreEvent>[
          for (final subId in state.eventSubscriptionList)
            newEvent.copyWith(eventSubscriptionID: subId)
        ];
        await _eventRepository.storeListOfEvents(_listOfEvents);

        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}

DateTime? convertStringToDateTime(
    String day, String month, String year, String time) {
  final _month = (month.length == 1) ? '0$month' : month;
  final _day = (day.length == 1) ? '0$day' : day;
  return DateTime.tryParse('$year-$_month-$_day $time');
}
