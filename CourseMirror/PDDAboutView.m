#import "PDDAboutView.h"
#import "UIColor+PDD.h"
#import "UIFont+PDD.h"

@implementation PDDAboutView

- (id)initWithText:(NSString *)text {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // TextView
        UITextView *textView = [[UITextView alloc] init];
        [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        textView.backgroundColor = [UIColor clearColor];
//        textView.textColor = [UIColor pddTextColor];
        textView.font = [UIFont pddBody];
        
        textView.text = text;
        textView.editable = YES;
        [self addSubview:textView];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(textView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[textView]-15-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(textView)]];
    }
    return self;
}

@end
