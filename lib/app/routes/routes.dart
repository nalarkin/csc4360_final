import 'package:flutter/widgets.dart';
import 'package:school_notifier/calendar/calendar.dart';
import 'package:school_notifier/home/home.dart';
import 'package:school_notifier/login/login.dart';
import 'package:school_notifier/messages/conversations/conversations.dart';
import 'package:school_notifier/messages/directory/view/directory_page.dart';
import 'package:school_notifier/messages/message.dart';
import 'package:school_notifier/posts/posts/creation/view/post_create_form.dart';
import 'package:school_notifier/posts/posts/creation/view/post_create_page.dart';

import 'package:school_notifier/posts/posts/view/posts_page.dart';
import 'package:school_notifier/profile/profile.dart';

import 'package:school_notifier/profile/view/profile_page.dart';
import 'package:school_notifier/sign_up/sign_up.dart';
import 'package:school_notifier/subscriptions/view/add_subscription_page.dart';
import 'package:school_notifier/subscriptions/view/subscriptions_page.dart';
import 'package:school_notifier/token/token.dart';

Map<String, WidgetBuilder> allRoutes = <String, WidgetBuilder>{
  HomePage.routeName: (context) => HomePage(),
  LoginPage.routeName: (context) => LoginPage(),
  SignUpPage.routeName: (context) => SignUpPage(),
  ProfilePage.routeName: (context) => ProfilePage(),
  TokenPage.routeName: (context) => TokenPage(),
  ConversationPage.routeName: (context) => ConversationPage(),
  MessagePage.routeName: (context) => MessagePage(),
  DirectoryPage.routeName: (context) => DirectoryPage(),
  AddSubscriptionPage.routeName: (context) => AddSubscriptionPage(),
  SubscriptionPage.routeName: (context) => SubscriptionPage(),
  CalendarAddEventPage.routeName: (context) => CalendarAddEventPage(),
  CalendarPage.routeName: (context) => CalendarPage(),
  PostPage.routeName: (context) => PostPage(),
  PostCreatePage.routeName: (context) => PostCreatePage(),
  PostCreateForm.routeName: (context) => PostCreateForm(),
};
