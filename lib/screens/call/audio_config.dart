/// Get your own App ID at https://dashboard.agora.io/
String get appId {
  // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
  return const String.fromEnvironment('TEST_APP_ID',
      defaultValue: 'efc2a723e2c2467193738793af60d54f');
}

/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
// String get token {
//   // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
//   return const String.fromEnvironment('TEST_TOKEN',
//       defaultValue:
//           '007eJxTYPiaZOqqaZF1PvDMFI+re6wzbE7Nk8tY9mQ/t9SvkvdX/0QoMKRZAIGBUaJlapKpSZJJclKaaZqJuXmygbGJUVKygflUgdrkhkBGhnjJxQyMUAjiCzA4FpcU5Ss4lqZk5is4J+bkMDAAAByMI84=');
// }

/// Your channel ID
String get channelId {
  // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
  return const String.fromEnvironment(
    'TEST_CHANNEL_ID',
    defaultValue: 'Astro Audio Call',
  );
}

/// Your int user ID
const int uid = 0;

/// Your user ID for the screen sharing
const int screenSharingUid = 10;

/// Your string user ID
const String stringUid = '0';
