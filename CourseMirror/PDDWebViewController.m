#import "PDDWebViewController.h"
#import "UIColor+PDD.h"

@interface PDDWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *webURL;
@end

@implementation PDDWebViewController

#pragma mark - Initialization methods
- (id)initWithURL:(NSString *)webURL title:(NSString *)title {
    self = [super init];
    if (self) {
        // Custom initialization
        _webURL = webURL;
        self.title = title;
    }
    return self;
}

#pragma mark - View lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    webView.backgroundColor = [UIColor pddContentBackgroundColor];
    webView.scalesPageToFit = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    webView.delegate = self;
    self.webView = webView;
    [self.view addSubview:webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.webView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - UIWebView delegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
