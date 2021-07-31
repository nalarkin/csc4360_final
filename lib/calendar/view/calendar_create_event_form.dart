import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_notifier/calendar/calendar.dart';
import 'package:formz/formz.dart';
import 'package:school_notifier/messages/message.dart';
import 'package:school_notifier/profile/bloc/profile_bloc.dart';
import 'package:users_repository/users_repository.dart';

class CalendarCreateEventForm extends StatelessWidget {
  const CalendarCreateEventForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarCubit, CalendarState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.pop(context);
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign Up Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              Text('Select the classes that the event is for.'),
              _SubscriptionList(),
              _TitleInput(),
              const SizedBox(height: 8.0),
              _DatePicker(),
              const SizedBox(height: 8.0),
              _TimePicker(),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              _DurationInput(),
              const SizedBox(height: 8.0),
              _DescriptionInput(),
              const SizedBox(height: 8.0),
              _SubmitEventButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (previous, current) =>
          previous.eventTitle != current.eventTitle,
      builder: (context, state) {
        return TextField(
          key: const Key('eventCreation_eventTitleInput_textField'),
          onChanged: (eventTitle) =>
              context.read<CalendarCubit>().eventTitleChanged(eventTitle),
          decoration: InputDecoration(
            labelText: 'Title',
            helperText: '',
            errorText: state.eventTitle.invalid ? 'invalid title' : null,
          ),
        );
      },
    );
  }
}

class _TimePicker extends StatelessWidget {
  const _TimePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text('Event Start Time'),
        BlocBuilder<CalendarCubit, CalendarState>(
          buildWhen: (previous, current) =>
              previous.eventTimeStart != current.eventTimeStart,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      primary: const Color(0xFFFFD600),
                    ),
                    onPressed: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      context
                          .read<CalendarCubit>()
                          .timeDialogueChanged(selectedTime);
                    },
                    child: state.eventTimeStart.value.isEmpty
                        ? Text('Select a Time', style: theme.textTheme.button)
                        : Text(
                            '${state.eventTimeStart.value}',
                            style: theme.textTheme.button,
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text('Event Date Picker'),
        BlocBuilder<CalendarCubit, CalendarState>(
          buildWhen: (previous, current) =>
              previous.eventSelectedDay != current.eventSelectedDay,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      primary: const Color(0xFFFFD600),
                    ),
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.utc(2030, 1, 1));
                      print(selectedDate.toString());
                      context
                          .read<CalendarCubit>()
                          .eventSelectedDateChanged(selectedDate);

                      print(formatCalendarDate(selectedDate ?? DateTime.now()));
                    },
                    child: state.eventSelectedDay != null
                        ? Text(
                            '${formatCalendarDate(state.eventSelectedDay!)}',
                            style: theme.textTheme.button,
                          )
                        : Text(
                            'Select a Date',
                            style: theme.textTheme.button,
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (previous, current) =>
          previous.eventDescription != current.eventDescription,
      builder: (context, state) {
        return TextField(
          key: const Key('eventCreation_eventTitleInput_textField'),
          onChanged: (description) => context
              .read<CalendarCubit>()
              .eventDescriptionChanged(description),
          decoration: InputDecoration(
            labelText: 'Description (optional)',
            helperText: '',
            errorText: state.eventTitle.invalid ? 'invalid Description' : null,
          ),
        );
      },
    );
  }
}

class _DurationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (previous, current) =>
          previous.eventDuration != current.eventDuration,
      builder: (context, state) {
        return TextField(
          key: const Key('eventCreation_eventTitleInput_textField'),
          onChanged: (duration) =>
              context.read<CalendarCubit>().eventDurationChanged(duration),
          decoration: InputDecoration(
            labelText: 'Duration (minutes)',
            helperText: '',
            errorText: state.eventTitle.invalid ? 'invalid Duration' : null,
          ),
        );
      },
    );
  }
}

class _SubscriptionList extends StatelessWidget {
  const _SubscriptionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> classes =
        context.watch<ProfileBloc>().state.user.classes ?? {};
    final List<String> keyList = classes.keys.toList();
    final List<String> valueList = List.from(classes.values.toList());
    return Container(
      child: Column(
        children: [
          for (final key in keyList)
            BlocBuilder<CalendarCubit, CalendarState>(
              buildWhen: (previous, current) =>
                  previous.eventSubscriptionList !=
                  current.eventSubscriptionList,
              builder: (context, state) {
                bool value = state.eventSubscriptionList.contains(key);
                return InkWell(
                  onTap: () {
                    context.read<CalendarCubit>().toggleSubscription(key);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text('${classes[key]}')),
                        Checkbox(
                          value: value,
                          onChanged: (bool? newValue) {
                            context
                                .read<CalendarCubit>()
                                .toggleSubscription(key);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}

class _SubscriptionIdInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> classes =
        context.watch<ProfileBloc>().state.user.classes ?? {};
    print('${classes}');
    print('${classes.keys}');
    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (previous, current) =>
          previous.eventSubscriptionList != current.eventSubscriptionList,
      builder: (context, state) {
        bool value =
            state.eventSubscriptionList.contains('test3GGiv2Bv3LpUr8qb');
        return InkWell(
          onTap: () {
            print('you pressed the inkwell!');
            context
                .read<CalendarCubit>()
                .toggleSubscription('test3GGiv2Bv3LpUr8qb');
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(child: Text('select this class')),
                Checkbox(
                  value: value,
                  onChanged: (bool? newValue) {
                    print('you pressed the checkbox!');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SubmitEventButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.eventSubscriptionList != current.eventSubscriptionList,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  primary: Colors.orangeAccent,
                ),
                onPressed: state.status.isValidated &&
                        state.eventSubscriptionList.isNotEmpty
                    ? () => context.read<CalendarCubit>().submitNewEvent()
                    : null,
                child: const Text('Submit Event'),
              );
      },
    );
  }
}
