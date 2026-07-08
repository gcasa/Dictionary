#import "IllustrationView.h"

@implementation IllustrationView

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame: frame];
  return self;
}

- (void)dealloc
{
  [_word release];
  [_definition release];
  [_image release];
  [super dealloc];
}

- (void)setWord:(NSString *)word definition:(NSString *)definition image:(NSImage *)image
{
  ASSIGN(_word, word);
  ASSIGN(_definition, definition);
  ASSIGN(_image, image);
  [self setNeedsDisplay: YES];
}

- (BOOL)isFlipped
{
  return NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
  NSRect bounds = [self bounds];
  NSRect artRect = NSInsetRect(bounds, 18, 36);
  NSDictionary *attrs;
  NSString *caption;
  NSBezierPath *frame;

  [[NSColor whiteColor] set];
  NSRectFill(bounds);
  [[NSColor blackColor] set];

  frame = [NSBezierPath bezierPathWithRect: NSInsetRect(bounds, 0.5, 0.5)];
  [frame setLineWidth: 1.0];
  [frame stroke];

  if (_image != nil)
    {
      [_image drawInRect: artRect
                fromRect: NSZeroRect
               operation: NSCompositeSourceOver
                fraction: 1.0];
    }
  caption = ([_word length] > 0) ? [_word uppercaseString] : @"DICTIONARY";
  attrs = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSFont boldSystemFontOfSize: 13.0], NSFontAttributeName,
    [NSColor blackColor], NSForegroundColorAttributeName, nil];
  [caption drawInRect: NSMakeRect(10, NSMaxY(bounds) - 27, NSWidth(bounds) - 20, 20)
       withAttributes: attrs];
}

@end
