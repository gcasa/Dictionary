#import <AppKit/AppKit.h>

@interface IllustrationView : NSView
{
  NSString *_word;
  NSString *_definition;
  NSImage *_image;
}

- (void)setWord:(NSString *)word definition:(NSString *)definition image:(NSImage *)image;

@end
