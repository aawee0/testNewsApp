
#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *articleDescLabel;

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
    // add link
}


@end
