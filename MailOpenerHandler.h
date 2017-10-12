#import <Opener/HBLOHandler.h>

@interface MailOpenerHandler : HBLOHandler

- (NSDictionary *) parameterDictionaryFromURL:(NSURL *)url;

@end

@interface NSString (URLDecoding)  

- (NSString *) URLDecodedString;

@end