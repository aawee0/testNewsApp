
#import "NewsModel.h"



@interface NewsModel ()

@property (strong, nonatomic) NSString *status;
@property (nonatomic) NSInteger totalResults;
@property (strong, nonatomic) NSArray<ArticleModel> *articles;

@end

@implementation NewsModel

+ (NewsModel *)initWithDictionary:(NSDictionary *)dict {
    NewsModel *newsBlock = [[NewsModel alloc] init];
    
    NSString *status = dict[@"status"];
    if (status) newsBlock.status = status;
    
    NSDictionary *totalResDict = dict[@"totalResults"];
    if (totalResDict && [totalResDict isKindOfClass:[NSNumber class]]) {
        NSNumber *totalRes = (NSNumber *)totalResDict;
        newsBlock.totalResults = [totalRes integerValue];
    }

    NSMutableArray *articlesArray = [[NSMutableArray alloc] init];
    
    NSDictionary *articlesListDict = dict[@"articles"];
    if (articlesListDict && [articlesListDict isKindOfClass:[NSArray class]]) {
        for (NSDictionary *articleDict in articlesListDict) {
            [articlesArray addObject: [ArticleModel initWithDictionary: articleDict]];
        }
    }
    newsBlock.articles = [[NSArray<ArticleModel> alloc] initWithArray:articlesArray];
    
    return newsBlock;
}

@end

@interface ArticleModel ()

@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSDate *publishedAt;

@end

@implementation ArticleModel

+ (ArticleModel *)initWithDictionary:(NSDictionary *)dict {
    ArticleModel *article = [[ArticleModel alloc] init];
    
    NSString *author = dict[@"author"];
    if (author) article.author = author;
    
    NSString *title = dict[@"title"];
    if (title) article.title = title;
    
    NSString *desc = dict[@"description"];
    if (desc) article.desc = desc;
    
    NSString *dateStr = dict[@"publishedAt"];
    if (dateStr) {
        article.publishedAt = [ArticleModel dateFromCustomString:dateStr];
        
    }
    
    return article;
}

+ (NSDate*)dateFromCustomString:(NSString*)dateString {
    if (dateString) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
        return [dateFormatter dateFromString:dateString];
    } return nil;
}

@end
