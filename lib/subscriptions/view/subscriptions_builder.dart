import 'package:authentication_repository/authentication_repository.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:message_repository/message_repository.dart';
import 'package:school_notifier/messages/message.dart';
import 'package:school_notifier/profile/profile.dart';
import 'package:school_notifier/subscriptions/subscriptions.dart';
import 'package:school_notifier/util.dart';
import 'package:school_notifier/widgets/loading_indicator.dart';
import 'package:school_notifier/messages/message.dart';
import 'package:grouped_list/grouped_list.dart';

class SubscriptionBuilder extends StatelessWidget {
  const SubscriptionBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subNames = context.read<ProfileBloc>().state.user.subscriptions;
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionInitial) {
          return LoadingIndicator();
        } else if (state is SubscriptionSuccess &&
            state.subscriptions.isEmpty) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 200,
            ),
            child: const Text('you have no subscriptions'),
          );
        } else if (state is SubscriptionSuccess) {
          final _subscriptions = state.subscriptions;

          final _viewerUid =
              context.read<AuthenticationRepository>().currentUser.id;

          return GroupedListView<dynamic, String>(
              elements: _subscriptions,
              order: GroupedListOrder.ASC,
              itemComparator: (a, b) =>
                  a.eventStartTime.compareTo(b.eventStartTime),
              groupComparator: (a, b) => a.compareTo(b),
              groupSeparatorBuilder: (String groupByValue) =>
                  _BuildGroupSeparator(groupByValue: groupByValue),
              indexedItemBuilder: (context, event, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: _buildSubscriptionTile(context, event, index,
                      subNames![_subscriptions[index].eventSubscriptionID]),
                );
              },
              groupBy: (element) =>
                  getHashCodeForGroupedList(element.eventStartTime));
        }
        return Container();
      },
    );
  }
}

class _BuildGroupSeparator extends StatelessWidget {
  const _BuildGroupSeparator({Key? key, required this.groupByValue})
      : super(key: key);
  final String groupByValue;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateTime parsedTime = DateTime.tryParse(groupByValue)!;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: theme.accentColor),
          color: theme.canvasColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '${formatDateEventWeekday(parsedTime)}',
                  style: theme.textTheme.headline6,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

GestureDetector _buildSubscriptionTile(
    context, FirestoreEvent subscription, int index, String className) {
  final theme = Theme.of(context);

  return GestureDetector(
    onTap: () {},
    child: Container(
      decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      height: 70,
      child: Row(
        children: [
          Container(
            width: 100,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  className,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText2
                      ?.copyWith(color: theme.hintColor, fontSize: 10),
                ),
                Text(
                  formatDateEventStartToEndTime(
                      subscription.eventStartTime, subscription.eventEndTime),
                  style: theme.textTheme.bodyText2
                      ?.copyWith(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      subscription.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText1
                          ?.copyWith(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  if (subscription.description.isNotEmpty)
                    Text(
                      subscription.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText2
                          ?.copyWith(color: Colors.black, fontSize: 12),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          )
        ],
      ),
    ),
  );
}
