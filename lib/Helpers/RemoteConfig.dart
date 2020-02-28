import 'package:firebase_remote_config/firebase_remote_config.dart';

getConfig(v) async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  await remoteConfig.fetch();
  await remoteConfig.activateFetched();
  return remoteConfig.getString(v);
}
