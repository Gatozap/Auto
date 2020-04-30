import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:autooh/Objetos/News.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BadgerController.dart';
import 'Helper.dart';
import 'NewsController.dart';

class NotificacoesHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String iconPath = 'auto';
  String largeIconPath = 'auto';

  /*sendNotification(Map<String, dynamic> body) {
    print('Enviando Push');
    String url =
        'https://us-central1-aproximamais-b84ee.cloudfunctions.net/helloWorld';
    http.post(url, body: body).then((v) {
      print('BODY DA NOTIFICAÇÃO ${v.body}');
    }).catchError((e) {
      print('Err:' + e.toString());
    });
  }*/

  final _random = new Random();

  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future showNotification(Map<String, dynamic> msg, context) async {
    if (Platform.isIOS) {
      String title = msg['title'];

      title = title.length > 55 ? title.substring(0, 54) + '...' : title;
      print(title.length);
      print('AQUI' + json.decode(msg['data']).runtimeType.toString());
      var data = json.decode(msg['data']);
      int behaiviour;
      var sender;

      if (json.decode(msg['data']).runtimeType.toString() != 'List<dynamic>') {
        sender = User.fromJson(json.decode(msg['data'])['user']);
        behaiviour = int.parse(data['behaivior'].toString());
      } else {
        sender = 'Server';
        behaiviour = int.parse(msg['behaivior'].toString());
      }

      print('behaiviour > ' + behaiviour.toString());
      bc.addBadge(behaiviour);
      switch (behaiviour) {
        case 0:
          ShowChatNotification(sender, iconPath, title, msg, data);
          break;
        case 1:
          ShowNotification(sender, iconPath, title, msg, data);
          break;
        case 2:
          ShowNotification(sender, iconPath, title, msg, data);
          break;
        case 3:
          ShowNotification(sender, iconPath, title, msg, data);
          break;
        case 4:
          ShowNotification(sender, iconPath, title, msg, data);
          break;
        case 6:
          ShowNotification(sender, iconPath, title, msg, data);
          break;
      }
    } else {
      String title = msg['data']['title'];

      title = title.length > 55 ? title.substring(0, 54) + '...' : title;
      print(title.length);
      print('AQUI' + json.decode(msg['data']['data']).runtimeType.toString());
      String senderpic = await _downloadAndSaveImage(
          'http://autooh.com/img/logo/logo.png', 'autooh');
      var data = json.decode(msg['data']['data']);
      int behaiviour;
      var sender;
      print(msg['data']);
      msg['data'].forEach((f, v) {
        print('AQUI F ${f} AQUI V ${v}');
      });
      if (json.decode(msg['data']['data']).runtimeType.toString() !=
          'List<dynamic>') {
        sender = User.fromJson(json.decode(msg['data']['data'])['user']);
        behaiviour = int.parse(data['behaivior'].toString());
        if (sender.foto != null) {
          senderpic = await _downloadAndSaveImage(sender.foto, sender.id);
        }
      } else {
        sender = 'Server';
        behaiviour = int.parse(msg['data']['behaivior'].toString());
      }

      print('behaiviour > ' + behaiviour.toString());
      print('AQUI SENDER PICK ${senderpic}');
      bc.addBadge(behaiviour);
      switch (behaiviour) {
        case 0:
          ShowChatNotification(sender, senderpic, title, msg, data);
          break;
        case 1:
          ShowNotification(sender, senderpic, title, msg, data);
          break;
        case 2:
          ShowNotification(sender, senderpic, title, msg, data);
          break;
        case 3:
          ShowNotification(sender, senderpic, title, msg, data);
          break;
        case 4:
          ShowNotification(sender, senderpic, title, msg, data);
          break;
        case 5:
          ShowNotification(sender, senderpic, title, msg, data);
          break;
      }
    }
  }

  Future ShowNotification(
      sender, String senderpic, String title, msg, data) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        icon: iconPath,
        color: Colors.black,
        largeIcon: senderpic,
        largeIconBitmapSource: BitmapSource.FilePath,
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, data['message'], platformChannelSpecifics,
        payload: json.encode(data));
  }

  Future ShowChatNotification(
      User sender, String senderpic, String title, msg, data) async {
    print(senderpic);
    //SharedPreferences.getInstance().then((sp) async {
    List<Message> messages = List<Message>();
    /*var m = sp.get(data['sala']);
      if (m != null) {
        try {
          print(m);
          List jsons = json.decode(m);
          for (var j in jsons) {
            var person = j['person'];
            Message m = new Message(
                j['text'].toString(),
                DateTime.fromMillisecondsSinceEpoch(j['timestamp']),
                Person(
                  bot: person['bot'],
                  icon: person['icon'],
                  iconSource: IconSource.FilePath,
                  important: false,
                  key: person['key'],
                  name: person['name'],
                  uri: person['uri'],
                ));
            messages.add(m);
          }
        } catch (err) {
          print('Error: ${err.toString()}');
        }
      }*/
    var lunchBot = Person(
        name: sender.nome,
        key: sender.id,
        bot: false,
        icon: senderpic,
        iconSource: IconSource.FilePath);
    messages.add(Message(
        data['title'],
        DateTime.fromMillisecondsSinceEpoch(int.parse(data['sended_at'])),
        lunchBot,
        dataMimeType: 'image/png',
        dataUri: senderpic));
    /*messages
          .sort((Message a, Message b) => a.timestamp.compareTo(b.timestamp));
      List jsons = new List();
      for (Message i in messages) {
        jsons.add(i.toMap());
      }
      ;
      if (jsons.length > 10) {
        jsons.removeAt(0);
      }
      sp.setString(data['sala'], json.encode(jsons));*/

    var messagingStyle = MessagingStyleInformation(lunchBot,
        groupConversation: true,
        conversationTitle: 'autooh',
        htmlFormatContent: true,
        htmlFormatTitle: true,
        messages: messages);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        data['sala'],
        'chat${data['salfa']}',
        'Chat Individual com ${sender.nome}',
        largeIconBitmapSource: BitmapSource.FilePath,
        importance: Importance(5),
        largeIcon: senderpic,
        icon: 'autooh',
        color: Colors.white,
        style: AndroidNotificationStyle.Messaging,
        styleInformation: messagingStyle);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0,
        '${sender.nome}: ${data['title']}',
        Helper().readTimestamp(
            DateTime.fromMillisecondsSinceEpoch(int.parse(data['sended_at']))),
        platformChannelSpecifics);
    //});
  }

  Future _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }
/*new News(Helpers.user.id.toString(), 'Teste Noticia',
                DateTime.now(), 0, Helpers.user*/

  Future saveNotification(News n) async {
    print('Iniciou User NOTIFICATION');
    NewsController nc = new NewsController();
    nc.increment(n);
  }

  /*Future<String> _downloadAndSaveImage(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }*/

  var platform = MethodChannel('crossingthestreams.io/resourceResolver');

  Future<void> _showMessagingNotification() async {
    // use a platform channel to resolve an Android drawable resource to a URI.
    // This is NOT part of the notifications plugin. Calls made over this channel is handled by the app
    String imageUri = await platform.invokeMethod('drawableToUri', 'food');
    print(imageUri);
    var messages = List<Message>();
    // First two person objects will use icons that part of the Android app's drawable resources
    var me = Person(
        name: 'Me',
        key: '1',
        uri: 'tel:1234567890',
        icon: 'ic_launcher',
        iconSource: IconSource.Drawable);
    var coworker = Person(
        name: 'Coworker',
        key: '2',
        uri: 'tel:9876543210',
        icon: 'ic_launcher',
        iconSource: IconSource.Drawable);
    // download the icon that would be use for the lunch bot person
    var lunchBot = Person(
        name: 'Lunch bot',
        key: 'bot',
        bot: true,
        icon: 'ic_launcher',
        iconSource: IconSource.FilePath);
    messages.add(Message('Hi', DateTime.now(), me));
    messages.add(Message(
        'What\'s up?', DateTime.now().add(Duration(minutes: 5)), coworker));
    messages.add(Message(
        'Lunch?', DateTime.now().add(Duration(minutes: 10)), null,
        dataMimeType: 'image/png', dataUri: imageUri));
    messages.add(Message('What kind of food would you prefer?',
        DateTime.now().add(Duration(minutes: 10)), lunchBot));
    var messagingStyle = MessagingStyleInformation(me,
        groupConversation: true,
        conversationTitle: 'Team lunch',
        htmlFormatContent: true,
        htmlFormatTitle: true,
        messages: messages);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'message channel id',
        'message channel name',
        'message channel description',
        style: AndroidNotificationStyle.Messaging,
        styleInformation: messagingStyle);
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'message title', 'message body', platformChannelSpecifics);

    // wait 10 seconds and add another message to simulate another response
    await Future.delayed(Duration(seconds: 10), () async {
      messages.add(
          Message('Thai', DateTime.now().add(Duration(minutes: 11)), null));
      await flutterLocalNotificationsPlugin.show(
        0,
        'message title',
        'message body',
        platformChannelSpecifics,
      );
    });
  }

  Future showBigTextNotification() async {
    var bigTextStyleInformation = new BigTextStyleInformation(
        'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        htmlFormatBigText: true,
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        style: AndroidNotificationStyle.BigText,
        styleInformation: bigTextStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);

    //TODO ARRUMAR A NEWS DE ACORDO COM A DATA;
  }

  Future showInboxNotification() async {
    var lines = new List<String>();
    lines.add('line <b>1</b>');
    lines.add('line <i>2</i>');
    var inboxStyleInformation = new InboxStyleInformation(lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'inbox channel id', 'inboxchannel name', 'inbox channel description',
        style: AndroidNotificationStyle.Inbox,
        styleInformation: inboxStyleInformation);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        0, 'inbox title', 'inbox body', platformChannelSpecifics);
  }

  Future showGroupedNotifications() async {
    var groupKey = 'com.android.example.WORK_EMAIL';
    var groupChannelId = 'grouped channel id';
    var groupChannelName = 'grouped channel name';
    var groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html
    var firstNotificationAndroidSpecifics = new AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.Max,
        priority: Priority.High,
        groupKey: groupKey);
    var firstNotificationPlatformSpecifics =
        new NotificationDetails(firstNotificationAndroidSpecifics, null);
    await flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
        'You will not believe...', firstNotificationPlatformSpecifics);
    var secondNotificationAndroidSpecifics = new AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.Max,
        priority: Priority.High,
        groupKey: groupKey);
    var secondNotificationPlatformSpecifics =
        new NotificationDetails(secondNotificationAndroidSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    // create the summary notification required for older devices that pre-date Android 7.0 (API level 24)
    var lines = new List<String>();
    lines.add('Alex Faarborg  Check this out');
    lines.add('Jeff Chang    Launch Party');
    var inboxStyleInformation = new InboxStyleInformation(lines,
        contentTitle: '2 new messages', summaryText: 'janedoe@example.com');
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        style: AndroidNotificationStyle.Inbox,
        styleInformation: inboxStyleInformation,
        groupKey: groupKey,
        setAsGroupSummary: true);
    var platformChannelSpecifics =
        new NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(
        3, 'Attention', 'Two new messages', platformChannelSpecifics);
  }

  Future cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future showOngoingNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ongoing: true,
        autoCancel: false);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'ongoing notification title',
        'ongoing notification body', platformChannelSpecifics);
  }

  Future repeatNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'repeating channel id',
      'repeating channel name',
      'repeating description',
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
  }

  int next(int min, int max) => min + _random.nextInt(max - min);

  Future showDailyAtTime() async {
    SharedPreferences.getInstance().then((sp) async {
      if (sp.getBool(
              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}') ==
          null) {
        var horarios = [
          Time(next(11, 12), next(0, 30)),
          Time(next(18, 19), next(0, 60))
        ];

        var time = horarios[next(0, 1)];
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
          'repeatDailyAtTime channel id',
          'repeatDailyAtTime channel name',
          'repeatDailyAtTime description',
          icon: iconPath,
          color: Colors.white,
          largeIcon: largeIconPath,
        );
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        //News n = new News('0', '', DateTime.now(), 4, Helper.nutrannoUser, '');
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            0,
            'Reporte um problema',
            'Encontrou algum problema hoje?',
            time,
            platformChannelSpecifics,
            payload: '');
        print('Saiu AQUI AQUI');
        sp.setBool(
            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
            true);
      }
    });
  }

  Future showWeeklyAtDayAndTime() async {
    var time = new Time(10, 0, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'show weekly channel id',
        'show weekly channel name',
        'show weekly description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'show weekly title',
        'Weekly notification shown on Monday at approximately ${toTwoDigitString(time.hour)}:${toTwoDigitString(time.minute)}:${toTwoDigitString(time.second)}',
        Day.Monday,
        time,
        platformChannelSpecifics);
  }

  Future showNotificationWithNoBadge() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'no badge channel', 'no badge name', 'no badge description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'no badge title', 'no badge body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future showProgressNotification() async {
    var maxProgress = 5;
    for (var i = 0; i <= maxProgress; i++) {
      await Future.delayed(Duration(seconds: 1), () async {
        var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
            'progress channel',
            'progress channel',
            'progress channel description',
            channelShowBadge: false,
            importance: Importance.Max,
            priority: Priority.High,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
        var platformChannelSpecifics = new NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  Future showIndeterminateProgressNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'indeterminate progress channel',
        'indeterminate progress channel',
        'indeterminate progress channel description',
        channelShowBadge: false,
        importance: Importance.Max,
        priority: Priority.High,
        onlyAlertOnce: true,
        showProgress: true,
        indeterminate: true);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'indeterminate progress notification title',
        'indeterminate progress notification body',
        platformChannelSpecifics,
        payload: 'item x');
  }

  String toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

/*
  Future getDL(Protocolo post, bool short) async {
    final DynamicLinkParameters parameters = new DynamicLinkParameters(
      domain: 'aproxima.page.link',
      link:
          Uri.parse('http://www.aproximamais.net/relato/' + post.id.toString()),
      androidParameters: new AndroidParameters(
        packageName: 'com.brunoeleodoro.org.aproxima',
        minimumVersion: 0,
      ),
      iosParameters: new IosParameters(
        bundleId: 'com.brunoeleodoro.org.aproxima',
        minimumVersion: '1.0.1',
        appStoreId: '123456789',
      ),
      navigationInfoParameters:
          new NavigationInfoParameters(forcedRedirectEnabled: true),
      dynamicLinkParametersOptions: new DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
    );

    Uri url;
    if (short) {
      try {
        final ShortDynamicLink shortLink = await parameters.buildShortLink();
        url = shortLink.shortUrl;
        print(url);
      } catch (e) {
        print('Erro:' + e.toString());
        url = await parameters.buildUrl();
      }
    } else {
      url = await parameters.buildUrl();
    }
    print(url);

    var _linkMessage = url.toString();
    post.dlink = _linkMessage;
    //print('Entrou aqui' + d.toString());
    print('CHEGOU AQUI');
    return _linkMessage;
  }*/
}
