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
  return YES;
}

- (NSUInteger)seed
{
  NSUInteger hash = [_word hash];
  if (hash == 0)
    hash = 1469598103U;
  return hash;
}

- (BOOL)definitionContainsAny:(NSArray *)needles
{
  NSString *text = [_definition lowercaseString];
  NSUInteger i;

  for (i = 0; i < [needles count]; i++)
    {
      if ([text rangeOfString: [needles objectAtIndex: i]].location != NSNotFound)
        return YES;
    }
  return NO;
}

- (void)strokeOvalInRect:(NSRect)rect
{
  NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect: rect];
  [path setLineWidth: 2.0];
  [path stroke];
}

- (void)drawPlantInRect:(NSRect)rect
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  CGFloat mid = NSMidX(rect);

  [path setLineWidth: 2.0];
  [path moveToPoint: NSMakePoint(mid, NSMaxY(rect) - 18)];
  [path curveToPoint: NSMakePoint(mid + 4, NSMinY(rect) + 28)
        controlPoint1: NSMakePoint(mid - 10, NSMaxY(rect) - 55)
        controlPoint2: NSMakePoint(mid + 12, NSMinY(rect) + 60)];
  [path stroke];

  [self strokeOvalInRect: NSMakeRect(mid - 58, NSMinY(rect) + 58, 54, 28)];
  [self strokeOvalInRect: NSMakeRect(mid + 4, NSMinY(rect) + 48, 58, 30)];
  [self strokeOvalInRect: NSMakeRect(mid - 46, NSMinY(rect) + 102, 48, 24)];
  [self strokeOvalInRect: NSMakeRect(mid + 3, NSMinY(rect) + 98, 50, 24)];
}

- (void)drawAnimalInRect:(NSRect)rect
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  CGFloat y = NSMidY(rect) + 10;

  [path setLineWidth: 2.0];
  [self strokeOvalInRect: NSMakeRect(NSMinX(rect) + 44, y - 38, 124, 68)];
  [self strokeOvalInRect: NSMakeRect(NSMinX(rect) + 150, y - 28, 56, 48)];

  [path moveToPoint: NSMakePoint(NSMinX(rect) + 62, y + 22)];
  [path lineToPoint: NSMakePoint(NSMinX(rect) + 48, y + 64)];
  [path moveToPoint: NSMakePoint(NSMinX(rect) + 95, y + 28)];
  [path lineToPoint: NSMakePoint(NSMinX(rect) + 91, y + 66)];
  [path moveToPoint: NSMakePoint(NSMinX(rect) + 139, y + 25)];
  [path lineToPoint: NSMakePoint(NSMinX(rect) + 149, y + 64)];
  [path moveToPoint: NSMakePoint(NSMinX(rect) + 183, y + 15)];
  [path lineToPoint: NSMakePoint(NSMinX(rect) + 198, y + 52)];
  [path moveToPoint: NSMakePoint(NSMinX(rect) + 177, y - 24)];
  [path lineToPoint: NSMakePoint(NSMinX(rect) + 188, y - 54)];
  [path lineToPoint: NSMakePoint(NSMinX(rect) + 198, y - 24)];
  [path moveToPoint: NSMakePoint(NSMinX(rect) + 48, y - 4)];
  [path curveToPoint: NSMakePoint(NSMinX(rect) + 18, y - 24)
        controlPoint1: NSMakePoint(NSMinX(rect) + 32, y - 2)
        controlPoint2: NSMakePoint(NSMinX(rect) + 22, y - 9)];
  [path stroke];
}

- (void)drawObjectInRect:(NSRect)rect
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  CGFloat x = NSMidX(rect);
  CGFloat y = NSMidY(rect);
  NSUInteger seed = [self seed];
  NSInteger sides = 5 + (seed % 4);
  NSInteger i;

  [path setLineWidth: 2.0];
  for (i = 0; i < sides; i++)
    {
      CGFloat angle = (2.0 * M_PI * i / sides) - M_PI_2;
      CGFloat radius = (i % 2 == 0) ? 78.0 : 52.0;
      NSPoint p = NSMakePoint(x + cos(angle) * radius, y + sin(angle) * radius);
      if (i == 0)
        [path moveToPoint: p];
      else
        [path lineToPoint: p];
    }
  [path closePath];
  [path stroke];

  for (i = 0; i < 7; i++)
    {
      CGFloat offset = -52 + i * 17;
      [path moveToPoint: NSMakePoint(x - 85, y + offset)];
      [path curveToPoint: NSMakePoint(x + 85, y + offset + ((i % 2) ? 8 : -8))
            controlPoint1: NSMakePoint(x - 32, y + offset - 12)
            controlPoint2: NSMakePoint(x + 34, y + offset + 12)];
    }
  [path stroke];
}

- (void)drawLandscapeInRect:(NSRect)rect
{
  NSBezierPath *path = [NSBezierPath bezierPath];
  CGFloat base = NSMaxY(rect) - 44;

  [path setLineWidth: 2.0];
  [path moveToPoint: NSMakePoint(NSMinX(rect) + 15, base)];
  [path lineToPoint: NSMakePoint(NSMinX(rect) + 86, NSMinY(rect) + 82)];
  [path lineToPoint: NSMakePoint(NSMinX(rect) + 142, base)];
  [path lineToPoint: NSMakePoint(NSMinX(rect) + 190, NSMinY(rect) + 105)];
  [path lineToPoint: NSMakePoint(NSMaxX(rect) - 18, base)];
  [path stroke];

  [self strokeOvalInRect: NSMakeRect(NSMaxX(rect) - 82, NSMinY(rect) + 26, 38, 38)];
  [path moveToPoint: NSMakePoint(NSMinX(rect) + 24, base + 18)];
  [path curveToPoint: NSMakePoint(NSMaxX(rect) - 30, base + 12)
        controlPoint1: NSMakePoint(NSMinX(rect) + 98, base - 10)
        controlPoint2: NSMakePoint(NSMaxX(rect) - 102, base + 34)];
  [path stroke];
}

- (void)drawFallbackInRect:(NSRect)rect
{
  if ([self definitionContainsAny: [NSArray arrayWithObjects:
    @"plant", @"tree", @"flower", @"leaf", @"seed", @"bot.", @"botany", nil]])
    [self drawPlantInRect: rect];
  else if ([self definitionContainsAny: [NSArray arrayWithObjects:
    @"animal", @"bird", @"fish", @"insect", @"zool.", @"mammal", nil]])
    [self drawAnimalInRect: rect];
  else if ([self definitionContainsAny: [NSArray arrayWithObjects:
    @"mountain", @"river", @"sea", @"earth", @"weather", @"place", nil]])
    [self drawLandscapeInRect: rect];
  else
    [self drawObjectInRect: rect];
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
  else if ([_word length] > 0)
    {
      [self drawFallbackInRect: artRect];
    }

  caption = ([_word length] > 0) ? [_word uppercaseString] : @"DICTIONARY";
  attrs = [NSDictionary dictionaryWithObjectsAndKeys:
    [NSFont boldSystemFontOfSize: 13.0], NSFontAttributeName,
    [NSColor blackColor], NSForegroundColorAttributeName, nil];
  [caption drawInRect: NSMakeRect(10, NSMaxY(bounds) - 27, NSWidth(bounds) - 20, 20)
       withAttributes: attrs];
}

@end
