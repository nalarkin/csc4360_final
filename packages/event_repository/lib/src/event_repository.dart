import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:event_repository/event_repository.dart';
import './notification_service.dart';
import 'package:rxdart/rxdart.dart';

class EventRepository {
  final eventCollection = FirebaseFirestore.instance
      .collection('exampleSchool')
      .doc('events')
      .collection('events');
  final _notificationService = NotificationService();

  Future<void> addNewEvent(FirestoreEvent event) async {
    final docRef = eventCollection.doc();
    await eventCollection
        .add(event.copyWith(eventUID: docRef.id).toEntity().toDocument());
  }

  Future<void> initializeNotifications() async {
    await _notificationService.init();
  }

  Future<void> deleteEvent(FirestoreEvent event) async {
    final possibleEvent = await eventCollection.doc(event.eventUID).get();
    if (possibleEvent.exists) {
      await eventCollection.doc(event.eventUID).delete();
    } else {
      print('Document does not exist. Event is from deleteEvent');
    }
  }

  Future<void> updateEvent(FirestoreEvent event) async {
    final possibleEvent = await eventCollection.doc(event.eventUID).get();
    if (possibleEvent.exists) {
      await eventCollection
          .doc(event.eventUID)
          .update(event.toEntity().toDocument());
    } else {
      print('Document does not exist. Event is from updateEvent');
    }
  }

  Stream<List<FirestoreEvent>> _individualSubscriptionList(
      String subscriptionID) {
    return eventCollection
        .where('eventSubscriptionID', isEqualTo: subscriptionID)
        .snapshots()
        .map((event) => event.docs
            .map((snap) =>
                FirestoreEvent.fromEntity(EventEntity.fromSnapshot(snap)))
            .toList());
  }

  Stream<List<FirestoreEvent>> getAllSubscribedEvents(
      List<String> subscriptionIDList) {
    return MergeStream(<Stream<List<FirestoreEvent>>>[
      for (var subID in subscriptionIDList) _individualSubscriptionList(subID)
    ]);
  }

  Stream<List<FirestoreEvent>> getSingleStream(String subID) {
    return eventCollection
        .where('eventSubscriptionID', isEqualTo: subID)
        .where('eventEndTime',
            isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .snapshots()
        .map(_convertToEventList);
  }

  Future<void> storeListOfEvents(List<FirestoreEvent> events) async {
    assert(events.length > 0);

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (FirestoreEvent event in events) {
      final docRef = eventCollection.doc();

      batch.set(
          docRef, event.copyWith(eventUID: docRef.id).toEntity().toDocument());
    }
    batch.commit();
  }

  List<FirestoreEvent> _convertToEventList(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    var _eventList = <FirestoreEvent>[];
    snapshot.docs.forEach((snap) {
      _eventList.add(FirestoreEvent.fromEntity(EventEntity.fromSnapshot(snap)));
    });

    return _eventList;
  }

  Stream<List<FirestoreEvent>> combineAllStreams(List<String> subIds) {
    return Rx.combineLatest([for (final id in subIds) getSingleStream(id)],
        (List<List<FirestoreEvent>> values) {
      var _res = <FirestoreEvent>[];
      for (List<FirestoreEvent> val in values) {
        _res.addAll(val);
      }
      return _res;
    });
  }

  Stream<LinkedHashMap<DateTime, List<FirestoreEvent>>> combineAllStreamsToMap(
      List<String> subIds) {
    return Rx.combineLatest([for (final id in subIds) getSingleStream(id)],
        (List<List<FirestoreEvent>> values) {
      LinkedHashMap<DateTime, List<FirestoreEvent>> _res =
          LinkedHashMap<DateTime, List<FirestoreEvent>>(
        equals: isSameDay,
        hashCode: getHashCode,
      );
      for (List<FirestoreEvent> val in values) {
        for (final event in val) {
          if (_res.containsKey(event.eventStartTime)) {
            _res[event.eventStartTime]!.add(event);
          } else {
            _res[event.eventStartTime] = [event];
          }
        }
      }
      return _res;
    });
  }

  Future<void> scheduleSingleNotification(FirestoreEvent event) async {
    await _notificationService.scheduleEventNotification(event);
  }

  Future<void> scheduleMultipleNotifications(
      List<FirestoreEvent> events) async {
    await _notificationService.scheduleMultipleEventNotification(events);
  }

  Future<void> deleteAllScheduledNotifications() async {
    await _notificationService.cancelAllNotifications();
  }

  Future<int> countScheduledNotifications() async {
    return await _notificationService.countAllScheduledNotifications();
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
