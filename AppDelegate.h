#import <AppKit/AppKit.h>

@class DictionaryClient;
@class IllustrationView;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
  NSWindow *_window;
  NSTextField *_searchField;
  NSTextView *_definitionView;
  NSTextField *_statusField;
  IllustrationView *_illustrationView;
  DictionaryClient *_client;
  NSMutableArray *_history;
  NSInteger _historyIndex;
}

- (void)lookup:(id)sender;
- (void)lookupWord:(NSString *)word;
- (void)lookupSelection:(NSPasteboard *)pboard
              userData:(NSString *)userData
                 error:(NSString **)error;

@end
