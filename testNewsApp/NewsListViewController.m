
#import "NewsListViewController.h"
#import "NewsDetailViewController.h"
#import "NewsTableViewCell.h"

#import "ApiManager.h"

#import "NewsModel.h"

@interface NewsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property (strong, nonatomic) NSMutableArray *articlesArray;
@property (strong, nonatomic) NSTimer *updateTimer;

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

    // set news update timer
    if (_updateTimer == nil) {
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self
                                                      selector:@selector(refreshTableInBackground)
                                                      userInfo:nil repeats:YES];
    }
    
    // fetch news
    [self refreshTableWithProgressView:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // stop timer
    [_updateTimer invalidate];
    _updateTimer = nil;
}

#pragma mark - Init methods

- (void)initTableView {
    _refreshControl = [[UIRefreshControl alloc] init];
    [_tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTableOnPull) forControlEvents:UIControlEventValueChanged];
    
    UINib *nib = [UINib nibWithNibName:@"NewsTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"newsTableViewCell"];
}

- (void)prepareNavBar {
    [[self navigationItem] setTitle:@"Новости"];
    [[self navigationItem] setBackBarButtonItem:
     [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain
                                     target:nil action:nil]]; // rename back button
}

#pragma mark - Update methods

- (void)refreshTableOnPull {
    [_refreshControl endRefreshing];
    [self refreshTableWithProgressView:YES];
}

- (void)refreshTableInBackground {
    NSLog(@" (!) Updating news in background...");
    [self refreshTableWithProgressView:NO];
}

- (void)refreshTableWithProgressView:(BOOL)progressView {
    [self fetchNewsByCountry:COUNTRY withProgressView:progressView];
}

#pragma mark - API related

- (void)fetchNewsByCountry:(NSString *)countryName withProgressView:(BOOL)progressView {
    if (progressView) [self showProgressView:YES];
    
    [ApiManager fetchNewsForCountryApi:countryName withCompletion:^(NSData *data,
                                                                         NSURLResponse *response,
                                                                         NSError *error) {
        if (progressView) [self showProgressView:NO];
        
        if (data) {
            if (progressView) NSLog(@"(!) Response: %@ ", response);
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingAllowFragments error:nil];
            
            if (progressView) NSLog(@"(!) Serialized data: %@ ", dict);
            
            if (dict) {
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

- (void)showProgressView:(BOOL)show {
    dispatch_async(dispatch_get_main_queue(), ^(){
        self.progressView.hidden = !show;
    });
}

@end
