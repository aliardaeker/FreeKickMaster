//
//  GameView.m
//  Free Kick Master
//
//  Created by ali arda eker on 3/20/17.
//  Copyright © 2017 AliArdaEker. All rights reserved.
//

#import "GameView.h"
#import "ViewController.h"

@implementation GameView

// Instance variables
@synthesize ball, shadowBall, rect, goal, goalLabel, missLabel, balls, dragCompleted, rightFlag,
    prevDragX, prevDragY, ballCounter, width, height, goals, missings, ballW, ballH, ballx, bally,
    rectW, rectH, rectx, recty, goalW, goalH, goalx, goaly, panRecognizer, image, image2, ySpeed,
    xSpeed, wall, rightFlagW, ballCoordinates, shadowBallCoordinates, launchPosition, draggedPosition,
    goalCoordinates, wallCoordinates;

// Constructor. Game begins. Instances are initialized.
-(id)initWithCoder:(NSCoder *)aDecoder
{
    dragCompleted = false;
    rightFlag = true;
    rightFlagW = true;
    ballCounter = 7;
    prevDragX = 0;
    prevDragY = 0;
    
    self = [super initWithCoder:aDecoder];
    return self;
}

// Objects in game field are created and put in necessary places
- (void) fixSize
{
    static BOOL initialized = TRUE;
    
    // Those objects are just created once.
    if (initialized)
    {
        initialized = FALSE;
        
        width = [self bounds].size.width;
        height = [self bounds].size.height;
        
        ballW = 30, ballH = 30;
        ballx = width / 2 - ballW / 2;
        bally = height - height / 5;
     
        missLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 100, 30)];
        missings = 0;
        [missLabel setText:@"Miss: 0"];
        missLabel.textAlignment = NSTextAlignmentLeft;
        missLabel.layer.zPosition = 11;
        [missLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:22]];
        missLabel.textColor = [UIColor blackColor];
        [self addSubview:missLabel];
        
        goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 100, 25, 100, 30)];
        goals = 0;
        [goalLabel setText:@"Goals: 0"];
        goalLabel.textAlignment = NSTextAlignmentRight;
        goalLabel.layer.zPosition = 11;
        [goalLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:22]];
        goalLabel.textColor = [UIColor blackColor];
        [self addSubview:goalLabel];
        
        goalW = 100, goalH = 40;
        goalx = 0, goaly = 0;
        
        goal = [[UIImageView alloc] initWithFrame:CGRectMake(goalx, goaly, goalW, goalH)];
        UIImage *image4 = [UIImage imageNamed:@"goal"];
        [goal setImage:image4];
        [self addSubview:goal];
        goal.layer.zPosition = 11;
        
        goalCoordinates.x = ballx + ballW / 2;
        goalCoordinates.y = goalH * 2;
        [goal setCenter:goalCoordinates];
        
        wall = [[UIImageView alloc] initWithFrame:CGRectMake(goalx, goaly, goalW, goalH - 5)];
        UIImage *image5 = [UIImage imageNamed:@"wall"];
        [wall setImage:image5];
        [self addSubview:wall];
        wall.layer.zPosition = 12;
        
        wallCoordinates.x = 10;
        wallCoordinates.y = height / 2;
        [wall setCenter:wallCoordinates];
        
        rectW = 150, rectH = 100;
        rectx = 0, recty = 0;
        
        rect = [[UIImageView alloc] initWithFrame:CGRectMake(rectx, recty, rectW, rectH)];
        UIImage *image3 = [UIImage imageNamed:@"rect"];
        [rect setImage:image3];
        [self addSubview:rect];
        rect.layer.zPosition = 8;
        [rect setCenter:CGPointMake(goalCoordinates.x, bally + ballH / 2 + rectH / 2)];
        
        rectx = goalCoordinates.x - rectW / 2;
        
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
        [panRecognizer setMinimumNumberOfTouches:1];
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelegate:self];
        
        image = [UIImage imageNamed:@"ball"];
        image2 = [UIImage imageNamed:@"area"];
        
    }
    
    int counter = 0;
    balls = [[NSMutableArray alloc] init];
    
    // Ball objects at the bottom of the screen
    for (int i = 0; i < 7; i++)
    {
        UIImageView *b = [[UIImageView alloc] initWithFrame:CGRectMake(rectx + counter, height - 30, 30, 30)];
        UIImage *image3 = [UIImage imageNamed:@"ball"];
        [b setImage:image3];
        b.layer.zPosition = 11;
        
        [self addSubview:b];
        [balls addObject:b];
        counter = counter + 20;
    }
    
    [self refreshBall];
}

// Objects to be created after a miss or score are implemented here
// This function is called after every launch of the ball
- (void) refreshBall
{
    ball = [[UIImageView alloc] initWithFrame:CGRectMake(ballx, bally, ballW, ballH)];
    [ball setImage:image];
    [self addSubview:ball];
    ball.layer.zPosition = 13;
    
    ballCoordinates.x = ballx + ballW / 2;
    ballCoordinates.y = bally + ballH / 2;
    
    shadowBall = [[UIImageView alloc] initWithFrame:CGRectMake(ballx, bally, ballW - 5, ballH)];
    [shadowBall setImage:image2];
    [self addSubview:shadowBall];
    shadowBall.layer.zPosition = 12;
    
    shadowBallCoordinates.x = ballx + ballW / 2;
    shadowBallCoordinates.y = bally + ballH / 2;
    
    launchPosition.x = shadowBallCoordinates.x;
    launchPosition.y = shadowBallCoordinates.y;
    
    [shadowBall setUserInteractionEnabled:YES];
    [shadowBall addGestureRecognizer:panRecognizer];
    [shadowBall setHidden:NO];
}

// Pan recognizer is set here. The distance between the shadowy ball and the actual ball
// is calculated to indicate how much user draged the ball with what angle.
-(void) move:(id)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    
    // Dragging started
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
    {
        prevDragX = 0;
        prevDragY = 0;
    }
    // Dragging ended
    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
        draggedPosition.x = shadowBallCoordinates.x;
        draggedPosition.y = shadowBallCoordinates.y;
        
        [self calculateLaunchVector];
        
        dragCompleted = true;
        [shadowBall setHidden:YES];
    }
    
    translatedPoint = CGPointMake(translatedPoint.x, translatedPoint.y);
    
    // Move the showdy red ball to indicate user drag
    shadowBallCoordinates.x = shadowBallCoordinates.x + translatedPoint.x - prevDragX;
    shadowBallCoordinates.y = shadowBallCoordinates.y + translatedPoint.y - prevDragY;
    [shadowBall setCenter:shadowBallCoordinates];
    
    prevDragX = translatedPoint.x;
    prevDragY = translatedPoint.y;
}

// Animation takes place here
- (void) arrange: (CADisplayLink *) sender
{
    // Goal and wall is moved
    [self moveTheGoal];
    [self moveTheWall];
    
    // If user releases the ball then it starts moving with the angle and speed
    // calculated by the position of the shadowy red ball.
    if (dragCompleted)
    {
        ballCoordinates.x = ballCoordinates.x + xSpeed;
        ballCoordinates.y = ballCoordinates.y + ySpeed;
        
        [ball setCenter:ballCoordinates];
        
        CGRect fieldFrame = [self frame];
        CGRect goalFrame = [goal frame];
        CGRect wallFrame = [wall frame];
        CGPoint ballCenter = [ball center];
        
        // If user hits the ball to the wall
        if (CGRectContainsPoint(wallFrame, ballCenter)) [self hitTheWall];
        
        // If user throws the ball out of the field
        if (! CGRectContainsPoint(fieldFrame, ballCenter)) [self missed];
        
        // If user scores
        if (CGRectContainsPoint(goalFrame, ballCenter)) [self scored];
    }
}

// Using the shadowy ball`s location, launch vector is calculated
- (void) calculateLaunchVector
{
    // Distance in horizontal and vertical axis is calculated
    float b = draggedPosition.x - launchPosition.x;
    float a = draggedPosition.y - launchPosition.y;
    
    // Angle with respect to the ball`s original position is calculated
    float angle = atan(a / b);
    
    // Hypotenuse is calculated.
    float hypotenuse = sqrt(pow(a, 2) + pow(b, 2)) / 12;
    
    // Hypotenuse is extracted into y and x vectors
    ySpeed = sin(angle) * hypotenuse;
    xSpeed = cos(angle) * hypotenuse;
    
    if (b < 0) xSpeed = fabsf(xSpeed);
    else if (xSpeed > 0) xSpeed = xSpeed * -1;

    if (a < 0) ySpeed = fabsf(ySpeed);
    else if (ySpeed > 0) ySpeed = ySpeed * -1;
}

// When the user is out of his or her balls a new view controller is created/
- (void) gameOver
{
    [ball removeFromSuperview];
    
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while ([vc presentedViewController] != nil)
        vc = [vc presentedViewController];
    
    // If user lost, loosing view controller is created
    if (missings > goals)
        [vc performSegueWithIdentifier:@"toGameOver" sender:nil];
    // If user wins, winning view controller is creared
    else if (goals > missings)
        [vc performSegueWithIdentifier:@"toCongratulations" sender:nil];
    // If it is a tie, tie view controller is created
    else
        [vc performSegueWithIdentifier:@"tie" sender:nil];
    
    ballCounter = 7;
    missings = 0;
    goals = 0;
}

// Goal is moved within the borders of the field
- (void) moveTheGoal
{
    if (rightFlag)
    {
        int newX = goalCoordinates.x + 2;
        
        if (newX < width - goalW / 2)
        {
            goalCoordinates.x = newX;
            [goal setCenter:goalCoordinates];
        }
        else rightFlag = false;
    }
    else
    {
        int newX = goalCoordinates.x - 2;
        
        if (newX > goalW / 2)
        {
            goalCoordinates.x = newX;
            [goal setCenter:goalCoordinates];
        }
        else rightFlag = true;
    }
}

// Wall is moved within the borders of the field
- (void) moveTheWall
{
    if (rightFlagW)
    {
        int newX = wallCoordinates.x + 1;
        
        if (newX < width - goalW / 2)
        {
            wallCoordinates.x = newX;
            [wall setCenter:wallCoordinates];
        }
        else rightFlagW = false;
    }
    else
    {
        int newX = wallCoordinates.x - 1;
        
        if (newX > goalW / 2)
        {
            wallCoordinates.x = newX;
            [wall setCenter:wallCoordinates];
        }
        else rightFlagW = true;
    }
}

// If user hits the wall
- (void) hitTheWall
{
    missings = missings + 1;
    NSString *str = [NSString stringWithFormat:@"%i", missings];
    NSString *newScore = [@"Miss: " stringByAppendingString:str];
    [missLabel setText:newScore];
    
    [ball removeFromSuperview];
    dragCompleted = false;
    
    if (ballCounter == 0) [self gameOver];
    else
    {
        for (UIImageView *b in balls)
        {
            [balls removeObject:b];
            ballCounter--;
            [b removeFromSuperview];
            break;
        }
        
        [self refreshBall];
    }
}

// If user throws the ball out of the field
- (void) missed
{
    missings = missings + 1;
    NSString *str = [NSString stringWithFormat:@"%i", missings];
    NSString *newScore = [@"Miss: " stringByAppendingString:str];
    [missLabel setText:newScore];
    
    [ball removeFromSuperview];
    dragCompleted = false;
    
    if (ballCounter == 0) [self gameOver];
    else
    {
        for (UIImageView *b in balls)
        {
            [balls removeObject:b];
            ballCounter--;
            [b removeFromSuperview];
            break;
        }
        
        [self refreshBall];
    }
}

// If user scores
- (void) scored
{
    goals = goals + 1;
    NSString *str = [NSString stringWithFormat:@"%i", goals];
    NSString *newScore = [@"Goal: " stringByAppendingString:str];
    [goalLabel setText:newScore];
    
    [ball removeFromSuperview];
    dragCompleted = false;
    
    if (ballCounter == 0) [self gameOver];
    else
    {
        for (UIImageView *b in balls)
        {
            [balls removeObject:b];
            ballCounter--;
            [b removeFromSuperview];
            break;
        }
        
        [self refreshBall];
    }
}

@end
