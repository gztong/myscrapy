#import "PDDAboutViewController.h"
#import "PDDAboutView.h"

@interface PDDAboutViewController ()
@property (strong, nonatomic) NSString *aboutText;
@property (weak, nonatomic) PDDAboutView *aboutView;
@end

@implementation PDDAboutViewController

#pragma mark - Initialization methods
- (id)init {
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CourseMIRRORNotices" ofType:@"txt"];
        _aboutText = [[NSString alloc] initWithContentsOfFile:filePath
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
        
    }
    return self;
}

#pragma mark - View lifecycle methods
- (void)loadView {
    UIView *view = [[UIView alloc] init];
    
    PDDAboutView *aboutView = [[PDDAboutView alloc] initWithText:self.aboutText];
    [view addSubview:aboutView];
    self.aboutView = aboutView;
    
    self.view = view;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
