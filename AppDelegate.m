#import "AppDelegate.h"
#import "DictionaryClient.h"
#import "IllustrationView.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
  [self buildInterface];
  _client = [DictionaryClient new];
  _history = [NSMutableArray new];
  _historyIndex = -1;
  [_window makeKeyAndOrderFront: self];
}

- (void)dealloc
{
  [_window release];
  [_client release];
  [_history release];
  [super dealloc];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
  return YES;
}

- (void)buildInterface
{
  NSRect frame = NSMakeRect(120, 120, 760, 500);
  NSView *content;
  NSButton *button;
  NSScrollView *scroll;
  NSBox *divider;
  NSTextField *label;

  _window = [[NSWindow alloc] initWithContentRect: frame
                                        styleMask: (NSTitledWindowMask
                                                    | NSClosableWindowMask
                                                    | NSMiniaturizableWindowMask
                                                    | NSResizableWindowMask)
                                          backing: NSBackingStoreBuffered
                                            defer: NO];
  [_window setTitle: @"Dictionary"];
  [_window setMinSize: NSMakeSize(620, 390)];

  content = [_window contentView];

  label = [[[NSTextField alloc] initWithFrame: NSMakeRect(18, 456, 48, 22)] autorelease];
  [label setStringValue: @"Word:"];
  [label setBezeled: NO];
  [label setDrawsBackground: NO];
  [label setEditable: NO];
  [label setSelectable: NO];
  [content addSubview: label];

  _searchField = [[NSTextField alloc] initWithFrame: NSMakeRect(68, 454, 486, 26)];
  [_searchField setTarget: self];
  [_searchField setAction: @selector(lookup:)];
  [_searchField setAutoresizingMask: NSViewWidthSizable];
  [content addSubview: _searchField];

  button = [[[NSButton alloc] initWithFrame: NSMakeRect(566, 454, 82, 26)] autorelease];
  [button setTitle: @"Look Up"];
  [button setBezelStyle: NSRoundedBezelStyle];
  [button setTarget: self];
  [button setAction: @selector(lookup:)];
  [button setAutoresizingMask: NSViewMinXMargin];
  [content addSubview: button];

  _statusField = [[NSTextField alloc] initWithFrame: NSMakeRect(18, 426, 730, 20)];
  [_statusField setStringValue: @"Enter a word, or use Services > Look Up in Dictionary from another application."];
  [_statusField setBezeled: NO];
  [_statusField setDrawsBackground: NO];
  [_statusField setEditable: NO];
  [_statusField setSelectable: NO];
  [_statusField setFont: [NSFont systemFontOfSize: 11.0]];
  [_statusField setAutoresizingMask: NSViewWidthSizable];
  [content addSubview: _statusField];

  _illustrationView = [[IllustrationView alloc] initWithFrame: NSMakeRect(18, 58, 250, 350)];
  [_illustrationView setAutoresizingMask: NSViewMaxXMargin | NSViewHeightSizable];
  [content addSubview: _illustrationView];

  divider = [[[NSBox alloc] initWithFrame: NSMakeRect(282, 58, 1, 350)] autorelease];
  [divider setBoxType: NSBoxSeparator];
  [divider setAutoresizingMask: NSViewMaxXMargin | NSViewHeightSizable];
  [content addSubview: divider];

  scroll = [[[NSScrollView alloc] initWithFrame: NSMakeRect(296, 58, 446, 350)] autorelease];
  [scroll setHasVerticalScroller: YES];
  [scroll setHasHorizontalScroller: NO];
  [scroll setBorderType: NSBezelBorder];
  [scroll setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];

  _definitionView = [[NSTextView alloc] initWithFrame: NSMakeRect(0, 0, 430, 350)];
  [_definitionView setEditable: NO];
  [_definitionView setSelectable: YES];
  [_definitionView setFont: [NSFont userFixedPitchFontOfSize: 12.0]];
  [_definitionView setString: @"No word looked up yet."];
  [scroll setDocumentView: _definitionView];
  [content addSubview: scroll];
}

- (void)lookup:(id)sender
{
  [self lookupWord: [_searchField stringValue]];
}

- (NSImage *)imageForCandidates:(NSArray *)candidates
{
  NSBundle *bundle = [NSBundle mainBundle];
  NSArray *extensions = [NSArray arrayWithObjects:
    @"tiff", @"tif", @"png", @"jpg", @"jpeg", @"gif", nil];
  NSUInteger i;
  NSUInteger j;

  for (i = 0; i < [candidates count]; i++)
    {
      NSString *name = [candidates objectAtIndex: i];
      for (j = 0; j < [extensions count]; j++)
        {
          NSString *path = [bundle pathForResource: name
                                            ofType: [extensions objectAtIndex: j]
                                       inDirectory: @"Drawings"];
          if (path != nil)
            return [[[NSImage alloc] initWithContentsOfFile: path] autorelease];
        }
    }

  return nil;
}

- (void)addWordToHistory:(NSString *)word
{
  if ([word length] == 0)
    return;

  if ([_history count] == 0 || ![[_history lastObject] isEqualToString: word])
    {
      [_history addObject: word];
      _historyIndex = [_history count] - 1;
    }
}

- (void)lookupWord:(NSString *)word
{
  NSString *trimmed = [word stringByTrimmingCharactersInSet:
    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *error = nil;
  NSString *definition;
  NSArray *candidates;
  NSImage *image;

  [_statusField setStringValue: @"Looking up..."];
  [_statusField displayIfNeeded];

  definition = [_client definitionForWord: trimmed error: &error];
  if (definition == nil)
    {
      [_statusField setStringValue: error == nil ? @"Lookup failed." : error];
      NSBeep();
      return;
    }

  candidates = [_client candidateDrawingNamesForWord: trimmed definition: definition];
  image = [self imageForCandidates: candidates];

  [_searchField setStringValue: trimmed];
  [_definitionView setString: definition];
  [_illustrationView setWord: trimmed definition: definition image: image];
  [_statusField setStringValue: image == nil
    ? @"Definition from dict. No bundled drawing found; showing generated line art."
    : @"Definition from dict. Bundled drawing found."];
  [self addWordToHistory: trimmed];
}

- (void)lookupSelection:(NSPasteboard *)pboard
              userData:(NSString *)userData
                 error:(NSString **)error
{
  NSString *word;
  NSArray *types = [pboard types];

  if (![types containsObject: NSStringPboardType])
    {
      if (error != NULL)
        *error = @"Dictionary needs plain text.";
      return;
    }

  word = [pboard stringForType: NSStringPboardType];
  if ([word length] == 0)
    {
      if (error != NULL)
        *error = @"No text was selected.";
      return;
    }

  [NSApp activateIgnoringOtherApps: YES];
  [_window makeKeyAndOrderFront: self];
  [self lookupWord: word];
}

@end
