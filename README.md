# 4360 Final Exam


Git Clone: `https://github.com/nalarkin/csc4360_final.git`

link to website: `https://github.com/nalarkin/csc4360_final`

## Goal of this project

As part of my final exam, I added additional features to the app to include a `reddit-like` message board. Parents, teachers, and students can submit posts and comment on posts. Posts and comments are sorted by the upvote/downvote net positive.

## Contributors / Authors:

* Nathan Larkin

## Video Walkthrough 

* https://youtu.be/zh6d0PKHbxk

## Video Demonstrations (part of group project)

*  [Authentication Workflow and Account Creation](https://youtu.be/qKenjBi_GVo)
*  [Event Creation](https://youtu.be/4ZOKFAq5rmY)
*  [Proof of Notifications Functionality](https://youtu.be/vr2bYco8tRM)
*  [Messaging Features](https://youtu.be/SctbDnlAuXw)

## How to run the App:

1. Run git clone https://github.com/nalarkin/school_notifier.git
2. copy dependencies in `pubspec.yaml` file.
3. In CLI, type`flutter pub get` to install required plugins that were listed in the new `pubspec.yaml file`
4. To run android, in CLI type `flutter run`

## Build ID: 

`teamjnd.school_notifier`

## Requirements:

* flutter 2.0+ is downloaded and installed
* files that were edited within `android/app/scr/main/res/  (necessary for splash screen)
* update contents in `android/app/src/AndroidManifest.xml`
* have all files in `/lib` downloaded
* Android SDK >= 21
* compatible on Android only, no web is supported.

## Areas of Improvement

If I had extra time, I would have added a couple extra bells and whistles. This includes and edit window where users can edit their posts/comments. In addition, moderation settings to allow posts to be deleted, and potentially a blacklist of people who are unable to post. Lastly, I would have added a dynamic color of the post display, based on whether the user has read the post before. I would have tried incorporating `Hive` to store the read posts on the local disk, that way I can avoid Firestore reads/writes and improve performance.

## Troubleshooting issues

* Clone the entire repository instead of copying certain files
* try `flutter clean` then `flutter pub get`
* Ensure that all packages with the `packages/*` folder have no errors, and that their dependencies have been installed with their respective `pubspec.yaml`
* install the plugins by doing `flutter get <addon>`, this was how I installed my addons. So it could have changed some config code somewhere in the project that I was unaware of.
* Ensure you are only trying to run the android version of the app, it is the only supported platform.

## Debug Page

If you want to gain access to the debug page, uncomment the commented ListTile in the `drawer.dart` file with the path `lib/widgets/drawer.dart`

