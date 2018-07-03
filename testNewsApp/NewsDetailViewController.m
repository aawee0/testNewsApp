
#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *articleUrlNoticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleUrlLabel;

@property (strong, nonatomic) ArticleModel *article;

@end

@implementation NewsDetailViewController

- (void)updateWithArticle:(ArticleModel *)articleModel {
    _article = articleModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _articleTitleLabel.text = _article.title ? _article.title : @"";
    _articleDescLabel.text = _article.desc ? _article.desc : @"";
    
    // link handling
    if (_article.url && ![_article.url isEqualToString:@""]) {
        // add underline
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_article.url];
        [attributedString addAttribute:NSUnderlineStyleAttributeName
                                value:[NSNumber numberWithInt:1]
                                range:(NSRange){0,[attributedString length]}];
        // color
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor blueColor]
                                 range:(NSRange){0,[attributedString length]}];
        [_articleUrlLabel setAttributedText:attributedString];
        
        // add gesture on tap
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLink)];
        [_articleUrlLabel addGestureRecognizer:gesture];
    }
    else {
        _articleUrlLabel.text = @"";
        _articleUrlNoticeLabel.hidden = YES;
    }
}

- (void)openLink {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _article.url]];
}


@end
