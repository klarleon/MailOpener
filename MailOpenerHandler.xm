#import "MailOpener.h"

@implementation MailOpenerHandler

- (instancetype)init {
	self = [super init];

	if (self) {
		self.name = @"MailOpener";
		self.identifier = @"com.klarleon.mailopener";
	}

	return self;
}

- (id)openURL:(NSURL *)url sender:(NSString *)sender {
	if ([url.scheme isEqualToString:@"mailto"]) {
		NSDictionary *parameterDictionary = [self parameterDictionaryFromURL:url];
		NSString *recipient = [parameterDictionary objectForKey:@"recipient"];
		NSString *subject = [parameterDictionary objectForKey:@"subject"];
		NSString *body = [parameterDictionary objectForKey:@"body"];
		
		return [NSURL URLWithString:[NSString stringWithFormat:@"airmail://compose?subject=%@&to=%@&plainBody=%@", subject, recipient, body]];
	}

	return nil;
}


- (NSDictionary *) parameterDictionaryFromURL:(NSURL *)url {
    NSMutableDictionary *parameterDictionary = [[NSMutableDictionary alloc] init];
    
    if ([[url scheme] isEqualToString:@"mailto"]) {
        NSString *mailtoParameterString = [[url absoluteString] substringFromIndex:[@"mailto:" length]];
        NSUInteger questionMarkLocation = [mailtoParameterString rangeOfString:@"?"].location;
        [parameterDictionary setObject:[mailtoParameterString substringToIndex:questionMarkLocation] forKey:@"recipient"];

        if (questionMarkLocation != NSNotFound) {
            NSString *parameterString = [mailtoParameterString substringFromIndex:questionMarkLocation + 1];
            NSArray *keyValuePairs = [parameterString componentsSeparatedByString:@"&"];
            for (NSString *queryString in keyValuePairs) {
                NSArray *keyValuePair = [queryString componentsSeparatedByString:@"="];
                if (keyValuePair.count == 2)
                    [parameterDictionary setObject:[[keyValuePair objectAtIndex:1] URLDecodedString] forKey:[[keyValuePair objectAtIndex:0] URLDecodedString]];
            }
        }
    }
    
    else { // URL scheme is not "mailto"
        NSString *parameterString = [url parameterString];
        NSArray *keyValuePairs = [parameterString componentsSeparatedByString:@"&"];
        for (NSString *queryString in keyValuePairs) {
            NSArray *keyValuePair = [queryString componentsSeparatedByString:@"="];
            if (keyValuePair.count == 2)
                [parameterDictionary setObject:[[keyValuePair objectAtIndex:1] URLDecodedString] forKey:[[keyValuePair objectAtIndex:0] URLDecodedString]];
        }
    }

    return [parameterDictionary copy];
}

@end

@implementation NSString (URLDecoding)

- (NSString *) URLDecodedString {
    NSString *result = [(NSString *)self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end



/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
