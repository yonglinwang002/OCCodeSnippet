//
//  NSString+SoftHyphenation.m


#import "NSString+SoftHyphenation.h"
unichar const kTextDrawingSoftHyphenUniChar = 0x00AD;
NSString * const kTextDrawingSoftHyphenToken = @"\u00ad"; // NOTE: UTF-8 soft hyphen!

NSString * const NSStringSoftHyphenationErrorDomain = @"NSStringSoftHyphenationErrorDomain";

@implementation NSString (SoftHyphenation)

- (NSError *)hyphen_createOnlyError
{
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: @"Hyphenation is not available for given locale",
                               NSLocalizedFailureReasonErrorKey: @"Hyphenation is not available for given locale",
                               NSLocalizedRecoverySuggestionErrorKey: @"You could try using a different locale even though it might not be 100% correct"
                               };
    return [NSError errorWithDomain:NSStringSoftHyphenationErrorDomain code:NSStringSoftHyphenationErrorNotAvailableForLocale userInfo:userInfo];
}

- (NSString *)softHyphenatedStringWithLocale:(NSLocale *)locale error:(out NSError **)error
{
    CFLocaleRef localeRef = (__bridge CFLocaleRef)(locale);
    if(!CFStringIsHyphenationAvailableForLocale(localeRef))
    {
        if(error != NULL)
        {
            *error = [self hyphen_createOnlyError];
        }
        return [self copy];
    }
    else
    {
        NSMutableString *string = [self mutableCopy];
        unsigned char hyphenationLocations[string.length];
        memset(hyphenationLocations, 0, string.length);
        CFRange range = CFRangeMake(0, string.length);
        
        for(int i = 0; i < string.length; i++)
        {
            CFIndex location = CFStringGetHyphenationLocationBeforeIndex((CFStringRef)string,
                                                                         i,
                                                                         range,
                                                                         0,
                                                                         localeRef,
                                                                         NULL);
            
            if(location >= 0 && location < string.length)
            {
                hyphenationLocations[location] = 1;
            }
        }
        
        for(unsigned long i = string.length - 1; i > 0; i--)
        {
            if(hyphenationLocations[i])
            {
                [string insertString:kTextDrawingSoftHyphenToken atIndex:i];
            }
        }
        
        if(error != NULL) { *error = nil;}
        
        return string;
    }
}


- (NSString *)softHyphenatedString
{
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    return [self softHyphenatedStringWithLocale:locale error:nil];
}


@end
