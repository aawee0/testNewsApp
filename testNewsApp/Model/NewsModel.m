
#import "NewsModel.h"



@interface NewsModel ()

@property (strong, nonatomic) NSString *status;
@property (nonatomic) NSInteger totalResults;
@property (strong, nonatomic) NSArray<ArticleModel> *articles;

@end

@implementation NewsModel

+ (NewsModel *)initWithDictionary:(NSDictionary *)dict {
    NewsModel *newsBlock = [[NewsModel alloc] init];
    
    NSDictionary *status = dict[@"status"];
    if (status && [status isKindOfClass:[NSString class]]) newsBlock.status = (NSString *)status;
    else newsBlock.status = @"";
    
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
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSDate *publishedAt;

@end

@implementation ArticleModel

+ (ArticleModel *)initWithDictionary:(NSDictionary *)dict {
    ArticleModel *article = [[ArticleModel alloc] init];
    
    NSDictionary *author = dict[@"author"];
    if (author && [author isKindOfClass:[NSString class]]) article.author = (NSString *)author;
    else article.author = @"";
    
    NSDictionary *title = dict[@"title"];
    if (title && [title isKindOfClass:[NSString class]]) article.title = (NSString *)title;
    else article.title = @"";
    
    NSDictionary *desc = dict[@"description"];
    if (desc && [desc isKindOfClass:[NSString class]]) article.desc = (NSString *)desc;
    else article.desc = @"";
    
    NSDictionary *url = dict[@"url"];
    if (url && [url isKindOfClass:[NSString class]]) article.url = (NSString *)url;
    else article.url = @"";
    
    NSDictionary *dateStr = dict[@"publishedAt"];
    if (dateStr && [dateStr isKindOfClass:[NSString class]]) {
        article.publishedAt = [ArticleModel dateFromCustomString:(NSString *)dateStr];
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
