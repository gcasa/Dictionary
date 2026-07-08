#import "DictionaryClient.h"

@implementation DictionaryClient

- (NSString *)normalizedToken:(NSString *)string
{
  NSMutableString *result = [NSMutableString string];
  NSUInteger i;

  for (i = 0; i < [string length]; i++)
    {
      unichar c = [string characterAtIndex: i];
      if ([[NSCharacterSet alphanumericCharacterSet] characterIsMember: c])
        {
          [result appendFormat: @"%C", (unichar)tolower(c)];
        }
      else if ([result length] > 0
               && ![[result substringFromIndex: [result length] - 1] isEqualToString: @"-"])
        {
          [result appendString: @"-"];
        }
    }

  while ([result hasSuffix: @"-"])
    {
      [result deleteCharactersInRange: NSMakeRange([result length] - 1, 1)];
    }

  return result;
}

- (NSString *)definitionForWord:(NSString *)word error:(NSString **)error
{
  NSString *trimmed = [word stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSTask *task;
  NSPipe *output;
  NSPipe *errors;
  NSData *data;
  NSString *definition;

  if ([trimmed length] == 0)
    {
      if (error != NULL)
        *error = @"Enter a word to look up.";
      return nil;
    }

  task = [NSTask new];
  output = [NSPipe pipe];
  errors = [NSPipe pipe];

  [task setLaunchPath: @"/usr/bin/dict"];
  [task setArguments: [NSArray arrayWithObject: trimmed]];
  [task setStandardOutput: output];
  [task setStandardError: errors];

  NS_DURING
    [task launch];
    [task waitUntilExit];
  NS_HANDLER
    if (error != NULL)
      *error = @"Could not run /usr/bin/dict. Install dictd/dict or adjust DictionaryClient.m.";
    [task release];
    return nil;
  NS_ENDHANDLER

  data = [[output fileHandleForReading] readDataToEndOfFile];
  definition = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
  if (definition == nil)
    definition = [[[NSString alloc] initWithData: data encoding: NSISOLatin1StringEncoding] autorelease];

  if ([task terminationStatus] != 0 || [definition length] == 0)
    {
      NSData *errorData = [[errors fileHandleForReading] readDataToEndOfFile];
      NSString *message = [[[NSString alloc] initWithData: errorData
                                                 encoding: NSUTF8StringEncoding] autorelease];
      if ([message length] == 0)
        message = [NSString stringWithFormat: @"No definition found for \"%@\".", trimmed];
      if (error != NULL)
        *error = message;
      [task release];
      return nil;
    }

  [task release];
  return definition;
}

- (void)addCandidate:(NSString *)candidate toArray:(NSMutableArray *)array
{
  NSString *normalized;

  normalized = [self normalizedToken: candidate];
  if ([normalized length] > 0 && ![array containsObject: normalized])
    [array addObject: normalized];
}

- (NSArray *)candidateDrawingNamesForWord:(NSString *)word
                               definition:(NSString *)definition
{
  NSMutableArray *names = [NSMutableArray array];
  NSArray *lines = [definition componentsSeparatedByCharactersInSet:
    [NSCharacterSet newlineCharacterSet]];
  NSUInteger i;

  [self addCandidate: word toArray: names];

  for (i = 0; i < [lines count] && [names count] < 16; i++)
    {
      NSString *line = [lines objectAtIndex: i];
      NSRange brace = [line rangeOfString: @"{"];
      while (brace.location != NSNotFound)
        {
          NSRange tail = NSMakeRange(NSMaxRange(brace),
                                     [line length] - NSMaxRange(brace));
          NSRange close = [line rangeOfString: @"}" options: 0 range: tail];
          if (close.location == NSNotFound)
            break;

          [self addCandidate: [line substringWithRange:
            NSMakeRange(NSMaxRange(brace), close.location - NSMaxRange(brace))]
                     toArray: names];
          tail = NSMakeRange(NSMaxRange(close), [line length] - NSMaxRange(close));
          brace = [line rangeOfString: @"{" options: 0 range: tail];
        }
    }

  return names;
}

@end
