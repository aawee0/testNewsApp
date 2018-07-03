
#import "ApiManager.h"

@implementation ApiManager


+ (void)fetchNewsForCountryApi:(NSString *)countryName
                withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    
    NSString *safeCountryName = [countryName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *paramsString = [[NSString alloc] initWithFormat:@"%@top-headlines?country=%@",
                              NEWSAPI_APIURL, safeCountryName];
    
    [ApiManager sendGETRequestWithParams:paramsString withCompletion:completionHandler];
}

+ (void)sendGETRequestWithParams:(NSString *)paramsString
                  withCompletion:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:paramsString]];
    [request setHTTPMethod:@"GET"];
    [request addValue:APIKEY forHTTPHeaderField:@"X-Api-Key"] ;
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:completionHandler] resume];
}

@end
