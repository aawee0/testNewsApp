
#import <Foundation/Foundation.h>

@interface ApiManager : NSObject

+ (void)fetchNewsForCountryApi:(NSString *)countryName
                withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;

@end
