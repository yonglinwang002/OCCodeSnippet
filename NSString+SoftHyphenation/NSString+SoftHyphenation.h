//
//  NSString+SoftHyphenation.h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    NSStringSoftHyphenationErrorNotAvailableForLocale
} NSStringSoftHyphenationError;

extern NSString * const NSStringSoftHyphenationErrorDomain;

@interface NSString (SoftHyphenation)

- (NSString *)softHyphenatedStringWithLocale:(NSLocale *)locale error:(out NSError **)error;

- (NSString *)softHyphenatedString;

@end

NS_ASSUME_NONNULL_END
