
#import "NewsListViewController.h"
#import "NewsDetailViewController.h"
#import "NewsTableViewCell.h"

#import "ApiManager.h"

#import "NewsModel.h"

@interface NewsListViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *articlesArray;

@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _articlesArray = [[NSMutableArray alloc] init];
    
    [self prepareNavBar];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchNewsByCountry:COUNTRY];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init methods

- (void)initTableView {
    UINib *nib = [UINib nibWithNibName:@"NewsTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"newsTableViewCell"];
}

- (void)prepareNavBar {
    [[self navigationItem] setTitle:@"Новости"];
    [[self navigationItem] setBackBarButtonItem:
     [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain
                                     target:nil action:nil]]; // rename back button
}

- (void)fetchNewsByCountry:(NSString *)countryName {
    [ApiManager fetchNewsForCountryApi:countryName withCompletion:^(NSData *data,
                                                                         NSURLResponse *response,
                                                                         NSError *error) {
        if (data) {
            NSLog(@"(!) Response: %@ ", response);
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments error:nil];
            
            if (dict) {
                NSLog(@"(!) Serialized data: %@ ", dict);
                
                NewsModel *newsBlock = [NewsModel initWithDictionary:dict];
                
                // UI changes
                if (error) { // REQUEST error
                    [self showAlertWithTitle:@"Error" andText:error.description andButtonNamed:@"Ok"];
                    NSLog(@"(!) Error %ld: %@ ", error.code, error.description);
                }
                else {
                    NSString *responseStatus = dict[@"status"];
                    if (responseStatus && [responseStatus isEqualToString:@"ok"]) { // SUCCESS
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [self addArticlesFromArray:newsBlock.articles];
                        });
                    } // ELSE
                    else if (responseStatus && [responseStatus isEqualToString:@"error"]) {
                        NSString *errorMessage = dict[@"message"];
                        if (errorMessage && ![errorMessage isEqualToString:@""]) {
                            [self showAlertWithTitle:@"Error" andText:errorMessage andButtonNamed:@"Ok"];
                        }
                        else [self showUnknownError];
                    }
                    else [self showUnknownError];
                }
            }
            else [self showUnknownError];
        }
        else [self showUnknownError];
        // BLOCK END
    }];
}

#pragma mark - Data array methods

- (void)addArticlesFromArray:(NSArray *)articles {
    [_articlesArray removeAllObjects];
    [_articlesArray addObjectsFromArray:articles];
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _articlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"newsTableViewCell"];
    ArticleModel *article = [_articlesArray objectAtIndex:indexPath.row];
    [cell updateWithTitle:article.title andDescription:article.desc];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] init];
    ArticleModel *article = [_articlesArray objectAtIndex:indexPath.row];
    [detailVC updateWithArticle:article];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Misc methods

- (void)showAlertWithTitle:(NSString *)title andText:(NSString *)text andButtonNamed:(NSString *)buttonName {
    dispatch_async(dispatch_get_main_queue(), ^(){
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:text
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:buttonName
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)showUnknownError {
    [self showAlertWithTitle:@"Oops!" andText:@"Something went wrong... please check your connection and try again." andButtonNamed:@"Ok"];
}

@end
