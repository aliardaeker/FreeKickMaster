//
//  ViewController.m
//  Free Kick Master
//
//  Created by ali arda eker on 3/20/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Animation link is set here
    _displayLink = [CADisplayLink displayLinkWithTarget:_gameView selector:@selector(arrange:)];
    [_displayLink setPreferredFramesPerSecond:30];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void) viewDidAppear:(BOOL)animated
{
    // Insert the background image
    UIImageView *iView;
    UIImage *image = [UIImage imageNamed:@"grass"];
    CGRect bounds = [_gameView bounds];
    
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    iView = [[UIImageView alloc] initWithImage:destImage];
    [_gameView addSubview:iView];
    iView.layer.zPosition = -1;
    
    // Game starts here
    [_gameView fixSize];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// When new view controller is created after game is done, labels are set and
// when created view controller is exited, they are destroyed.
- (IBAction) done:(UIStoryboardSegue *) segue
{
    [[_gameView missLabel] setText:@"Miss: 0"];
    [[_gameView goalLabel] setText:@"Goal: 0"];
}

@end
