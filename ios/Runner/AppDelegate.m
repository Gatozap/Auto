#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"
@import UIKit;
@import Firebase;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
  [GMSServices provideAPIKey:@"AIzaSyCbXnPT3n-bTsDmTYPfNAk4zWCn88SlnF4"];
    int flutter_native_splash = 1;
    UIApplication.sharedApplication.statusBarHidden = false;

  [GeneratedPluginRegistrant registerWithRegistry:self];

     if(![[NSUserDefaults standardUserDefaults]objectForKey:@"Notification"]){
          [[UIApplication sharedApplication] cancelAllLocalNotifications];
          [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Notification"];
      }
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
