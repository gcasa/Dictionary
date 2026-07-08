#import <AppKit/AppKit.h>
#import "AppDelegate.h"

int
main(int argc, const char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSApplication *app = [NSApplication sharedApplication];
  AppDelegate *delegate = [AppDelegate new];

  [app setDelegate: delegate];
  [app setServicesProvider: delegate];
  [app run];

  [delegate release];
  [pool release];
  return 0;
}
