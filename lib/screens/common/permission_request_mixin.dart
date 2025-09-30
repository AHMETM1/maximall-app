import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';

mixin PermissionRequestMixin<T extends StatefulWidget> on State<T> {
  String get permissionRequestTitle;

  String get permissionRequestSubtitle;

  IconData get permissionIcon;

  Future<void> onAcceptPermission();

  Future<void> onDeclinePermission();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: onAcceptPermission,
              child: Text(
                // Apple reject

                // We noticed your app encourages or directs users to allow the
                // app to access the camera. Specifically, your app directs the
                // user to grant permission in the following way(s):

                // - A custom message appears before the permission request, and
                //   to proceed users press an “ALLOW” button. Use words like
                //   "Continue", "Next" or "Got it" on the button instead.

                // Permission requests give users control of their personal
                // information. It is important to respect their decision about
                // how their data is used.
                S.of(context).continues.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            // Apple reject

            // The app encourages or directs users to allow the app to access
            // the camera. Specifically, the app directs the user to grant
            // permission in the following way(s):

            // - A custom message appears before the permission request, and the
            //   user can close the message and delay the permission request
            //   with the "decline" button. The user should always proceed to
            //   the permission request after the message.

            // Permission requests give users control of their personal
            // information. It is important to respect their decision about how
            // their data is used.

            // To resolve this issue, please revise the permission request
            // process in the app to not include an exit button on the message
            // before the permission request.

            // If necessary, you may provide more information about why you are
            // requesting permission before the request appears. If the user is
            // trying to use a feature in the app that won't function without
            // access to the camera, you may include a notification to inform
            // the user and provide a link to the Settings app.

            // OutlinedButton(
            //   onPressed: onDeclinePermission,
            //   child: Text(S.of(context).decline.toUpperCase()),
            // ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: Icon(permissionIcon, size: 120),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    permissionRequestTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Text(permissionRequestSubtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
