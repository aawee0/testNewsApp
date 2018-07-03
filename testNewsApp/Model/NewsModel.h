
#import <Foundation/Foundation.h>

@protocol ArticleModel;

@interface NewsModel : NSObject

@property (strong, nonatomic, readonly) NSString *status;
@property (nonatomic, readonly) NSInteger totalResults;
@property (strong, nonatomic, readonly) NSArray<ArticleModel> *articles;

// initialization
+ (NewsModel *)initWithDictionary:(NSDictionary *)dict;

@end


@interface ArticleModel : NSObject

@property (strong, nonatomic, readonly) NSString *author;
@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *desc;
@property (strong, nonatomic, readonly) NSString *url;
@property (strong, nonatomic, readonly) NSDate *publishedAt;

// initialization
+ (ArticleModel *)initWithDictionary:(NSDictionary *)dict;

@end
