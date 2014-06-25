#import "ViewController.h"

@interface ViewController () <UIAlertViewDelegate, UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"default" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]
                         baseURL:nil];
    self.webView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    // [self promptForURL];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self promptForURL];
    }
}

- (void)promptForURL {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter a URL"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Go", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;

    UITextField *textView = [alertView textFieldAtIndex:0];
    [textView setText:self.webView.request.URL.absoluteString];
    if ([textView.text isEqualToString:@"about:blank"]) {
        textView.text = @"";
    }

    NSString *pasteBoardString = [[UIPasteboard generalPasteboard] string];
    if (pasteBoardString) {
        textView.text = pasteBoardString;
    }

    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[alertView textFieldAtIndex:0] text]]];
        [request setValue:@"iPhone" forHTTPHeaderField:@"User-Agent"];
        [self.webView loadRequest:request];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.indicatorView startAnimating];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Web View Fail."
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
