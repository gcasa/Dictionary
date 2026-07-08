#import <Foundation/Foundation.h>

@interface DictionaryClient : NSObject

- (NSString *)definitionForWord:(NSString *)word error:(NSString **)error;
- (NSArray *)candidateDrawingNamesForWord:(NSString *)word
                               definition:(NSString *)definition;
- (NSString *)normalizedToken:(NSString *)string;

@end
