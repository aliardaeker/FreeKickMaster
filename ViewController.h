//
//  ViewController.h
//  Free Kick Master
//
//  Created by ali arda eker on 3/20/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"

@interface ViewController : UIViewController

// Game View object to access methods of the game logic
@property (nonatomic, strong) IBOutlet GameView *gameView;

@end

