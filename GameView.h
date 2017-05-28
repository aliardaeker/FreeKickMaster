//
//  GameView.h
//  Free Kick Master
//
//  Created by ali arda eker on 3/20/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#ifndef GameView_h
#define GameView_h

#import <UIKit/UIKit.h>

@interface GameView : UIView {}

// Array to hold balls at the bottom of screen to indicate how many chances the user have
@property (nonatomic, strong) NSMutableArray *balls;

// Objects in the game field, such as ball, wall, goal, the red rectangle to indicate the
// borders of the ball to be stretched and a red shadowy ball to indicate where user
// stretched the ball.
@property (nonatomic, strong) UIImageView * ball;
@property (nonatomic, strong) UIImageView * shadowBall;
@property (nonatomic, strong) UIImageView * rect;
@property (nonatomic, strong) UIImageView * goal;
@property (nonatomic, strong) UIImageView * wall;

// Labels to show number of scores and misses
@property (nonatomic, strong) UILabel * goalLabel;
@property (nonatomic, strong) UILabel * missLabel;

// Animation code takes place here
- (void) arrange: (CADisplayLink *) sender;

// The objects which are set just once is implemented here
- (void) fixSize;

// Necessary functions for game to be played
- (void) gameOver;
- (void) refreshBall;
- (void) moveTheGoal;
- (void) moveTheWall;
- (void) hitTheWall;
- (void) missed;
- (void) scored;

// Instance variables to calculate the launch vector
@property (nonatomic) bool dragCompleted, rightFlag, rightFlagW;
@property (nonatomic) int prevDragX, prevDragY, ballCounter;
@property (nonatomic) float ySpeed, xSpeed;

// Instance variables of the objects to hold dimensions and origins
@property (nonatomic) int width, height, goals, missings;
@property (nonatomic) int ballW, ballH, ballx, bally;
@property (nonatomic) int rectW, rectH, rectx, recty;
@property (nonatomic) int goalW, goalH, goalx, goaly;

// Pan recognizer is the feature for selecting and draging an object
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

// Ball and red shadowy ball images
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *image2;

// Point objects to hold coordinates of ball, shadow ball, launching and dragged positions
// with goal and wall coordinates
@property (nonatomic) CGPoint ballCoordinates;
@property (nonatomic) CGPoint shadowBallCoordinates;
@property (nonatomic) CGPoint launchPosition;
@property (nonatomic) CGPoint draggedPosition;
@property (nonatomic) CGPoint goalCoordinates;
@property (nonatomic) CGPoint wallCoordinates;

@end

#endif /* GameView_h */
