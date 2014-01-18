//
//  ViewController.m
//  BreakOut
//
//  Created by Stephen Compton on 1/16/14.
//  Copyright (c) 2014 Stephen Compton. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"
#import "BlockImageView.h"
#import "BreakOut.h"

@interface ViewController ()<UICollisionBehaviorDelegate>

{
    __weak IBOutlet UILabel *player2Textlabel;
    __weak IBOutlet UIButton *gameOverButton;
    __weak IBOutlet UIButton *startButton;
    __weak IBOutlet UILabel *scorePlayer2Label;
    __weak IBOutlet UILabel *scorePlayer1Label;
    __weak IBOutlet PaddleView *paddleView;
    UIDynamicAnimator *dynamicAnimator;
    __weak IBOutlet BallView *ballView;
    UIPushBehavior *pushBehavior;
    __weak IBOutlet UILabel *currentLevelLabel;
    UICollisionBehavior *collisionBehavior;
    UIDynamicItemBehavior *blockDynamicBehavior;
    UISnapBehavior *snapBall;
    UIDynamicItemBehavior *ballDynamicBehavior;
    
    UIView *gameBoard;
    
    NSMutableArray *player1LifeImages;
    NSMutableArray *player2LifeImages;
    
    BlockImageView *temp;
    BreakOut *game;
    
    CGRect ballStart;
    NSInteger timer;
    
    NSTimer *myTimer;
}

@end

@implementation ViewController


- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    paddleView.center = CGPointMake ([panGestureRecognizer locationInView:self.view].x, paddleView.center.y);
    [dynamicAnimator updateItemUsingCurrentState:paddleView];
    
    
}


- (IBAction)onStartGameButtonPressed:(id)sender
{
  
       [dynamicAnimator removeBehavior:snapBall];
       [dynamicAnimator updateItemUsingCurrentState:ballView];
    
    startButton.hidden =YES;
//    timer=1;
//    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                               target:self
//                                             selector:@selector(resetBall)
//                                             userInfo:nil
//                                              repeats:YES];
//    pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
//    pushBehavior.magnitude = 0.15;
    pushBehavior.active = YES;
    [collisionBehavior addItem:ballView];
    [dynamicAnimator updateItemUsingCurrentState:ballView];
    [myTimer invalidate];
    NSLog(@"dynamice animator %@", dynamicAnimator.behaviors);
    NSLog(@"collisision  %@", collisionBehavior.items);
    
}

- (IBAction)onGameOverButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearLevel
{
    for (int i = 0; i<game.extraballs.count; i++)
    {
        [self removeExtraball:game.extraballs[i]];
    }
    
    
    [collisionBehavior removeItem:ballView];
    
    snapBall = [[UISnapBehavior alloc] initWithItem:ballView snapToPoint:CGPointMake(160.0, 220)];
    [dynamicAnimator addBehavior:snapBall];
    
    pushBehavior.active = NO;
    
    if (game.blocks.count > 0)
    {
        for (UIView *tempBlock in game.blocks)
        {
            [tempBlock removeFromSuperview];
            [collisionBehavior removeItem:tempBlock];
            [blockDynamicBehavior removeItem:tempBlock];
        }
    }
}

- (void)setupLevel:(NSInteger)level
{
    
    
    [game setGameForLevel:level];
    
    for (BlockImageView *newBlock in game.blocks)
    {
        [gameBoard addSubview:newBlock];
        NSLog(@"new Block %@",newBlock);
        [collisionBehavior addItem: newBlock];
        [blockDynamicBehavior addItem: newBlock];
    }
    
}

- (void)restartGame
{
    gameOverButton.hidden = YES;
    startButton.hidden = NO;
    game = [BreakOut new];
    //    [BreakOut setNumberOfLifes:3];
    
    [game initGameForPlayers:_numberOfPlayers];
    
    scorePlayer1Label.text = [NSString stringWithFormat:@"%i", game.player1Score];
    scorePlayer2Label.text = [NSString stringWithFormat:@"%i", game.player2Score];
    

    UIDynamicItemBehavior *paddleDynamicBehavior;
    
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:gameBoard];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
    pushBehavior.active = NO;
    pushBehavior.magnitude = 0.1;
    [dynamicAnimator addBehavior:pushBehavior];
    
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ballView, paddleView]];
    collisionBehavior.collisionDelegate=self;
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [dynamicAnimator addBehavior:collisionBehavior];
    
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 10000.0;
    
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc] init];
    blockDynamicBehavior.allowsRotation = NO;
    blockDynamicBehavior.density = 10000.0;
    [dynamicAnimator addBehavior:blockDynamicBehavior];
    
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    
    [self setupLevel:(game.currentPlayer==1) ? game.player1Level : game.player2Level];
    [self refreshScore];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden =YES;
    ballStart = ballView.frame;
    
    gameBoard = self.view;
    
    player1LifeImages = [NSMutableArray array];
    player2LifeImages = [NSMutableArray array];
    
    for (int x=0; x< 5; x++)
    {
        UIImageView *life = [[UIImageView alloc] initWithFrame: CGRectMake(20+(x*25), (500), 20.0, 5.0)];
        life.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PlayerLife20x5.png"]];
        //    [life sizeToFit];
        [self.view addSubview:life];
        [player1LifeImages addObject:life];
        
        life = [[UIImageView alloc] initWithFrame: CGRectMake(170+(x*25), (500), 20.0, 5.0)];
        life.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PlayerLife20x5.png"]];
        //    [life sizeToFit];
        [self.view addSubview:life];
        [player2LifeImages addObject:life];
    }
    [startButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Start.png"]]];
    [self restartGame];
    
    
}


-(BOOL)shouldStartAgain
{
    if (game.blocks.count == 0) {
        return YES;
    }else
    {return NO;
    }
}

#pragma mark UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if (p.y > 560)
    {
        
        [game lostBall];
        
        [dynamicAnimator removeBehavior:snapBall];
        [dynamicAnimator updateItemUsingCurrentState:ballView];
        [self clearLevel];
        
        //       ballView.center = CGPointMake(160.0, self.view.center.y);
        //       [dynamicAnimator updateItemUsingCurrentState:ballView];
        pushBehavior.active = NO;
        
        ballView.frame = ballStart;
        
        //      snapBall = [[UISnapBehavior alloc] initWithItem:ballView snapToPoint:CGPointMake(160.0, 300)];
        //      [dynamicAnimator addBehavior:snapBall];
        
        startButton.hidden = NO;
        
        [game flipPlayer];
        [self setupLevel:(game.currentPlayer==1) ? game.player1Level : game.player2Level];
        
        [self refreshScore];
        
    }
}

- (void)refreshScore
{
    scorePlayer1Label.text = [NSString stringWithFormat:@"%i", game.player1Score];
    scorePlayer2Label.text = [NSString stringWithFormat:@"%i", game.player2Score];
    
    
    if(game.currentPlayer ==1)
    {
        currentLevelLabel.text = [NSString stringWithFormat:@"%i", game.player1Level];
        scorePlayer1Label.textColor = [UIColor redColor];
        scorePlayer2Label.textColor = [UIColor whiteColor];
    }
    else
    {
        currentLevelLabel.text = [NSString stringWithFormat:@"%i", game.player2Level];
        scorePlayer2Label.textColor = [UIColor redColor];
        scorePlayer1Label.textColor = [UIColor whiteColor];
    }
    
    if (_numberOfPlayers == 1)
    {
        scorePlayer2Label.hidden = YES;
        player2Textlabel.hidden = YES;
    }
    else
    {
        scorePlayer2Label.hidden = NO;
        player2Textlabel.hidden = NO;
    }
    
    for (int x=0; x< game.numberOfLifes; x++)
    {
        UIImageView *life = [player1LifeImages objectAtIndex:x];
        if (game.player1Lifes > x)
        {
            life.hidden = NO;
        }
        else
        {
            life.hidden = YES;
        }
        
        life = [player2LifeImages objectAtIndex:x];
        if (game.player2Lifes > x && _numberOfPlayers == 2)
        {
            life.hidden = NO;
        }
        else
        {
            life.hidden = YES;
        }
        
    }
    
    if (game.gameOver)
    {
        if (game.player1Lifes == 0)
        {
            if (_numberOfPlayers == 2)
            {
                [gameOverButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FPlayer2Wins.png"]]];
        
            }
            else
            {
                [gameOverButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"GameOver.png"]]];
            }
        }
        else
        {
            [gameOverButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"FPlayer1Wins.png"]]];
        }
    
        [self clearLevel];
        gameOverButton.hidden = NO;
        startButton.hidden = YES;
    }
    
    
}

- (void)hitBlock:(id)item
{
    
    NSInteger currentNumberOfExtraBalls = game.extraballs.count;
    NSInteger hitValue;
    hitValue = [game hitBlock:item];
    NSLog(@"item hit %@",item);
    
    if (hitValue > 0)
    {
    [self refreshScore];
    
  //  [item removeFromSuperview];
    [collisionBehavior removeItem:item];
    [blockDynamicBehavior removeItem:item];
    [dynamicAnimator updateItemUsingCurrentState:item];
    
    [((BlockImageView*)item) startAnimating];
    //    [UIImageView animateWithDuration:0.5 animations:^{
    //        ((BlockImageView*)item).alpha = 0;
    //   }];
    
       [UIView animateWithDuration:0.5 animations:^{
             ((BlockImageView*)item).alpha = 0;
        } completion:^(BOOL finished) {
            [item removeFromSuperview];
        }];
        if (game.extraballs.count > currentNumberOfExtraBalls)
        {
            BallView *extraBall = [game.extraballs objectAtIndex:currentNumberOfExtraBalls];
            [self.view addSubview:extraBall];
   //         pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
   //         pushBehavior.magnitude = 0.1;
            pushBehavior.active = YES;
            [pushBehavior addItem:extraBall];
            [collisionBehavior addItem:extraBall];
            [dynamicAnimator updateItemUsingCurrentState:extraBall];
            [ballDynamicBehavior addItem:extraBall];

            myTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                        target:self
                                                     selector:@selector(timeToResetExtraball:)
                                                        userInfo:extraBall
                                                        repeats:NO];
        }
    }
}

- (void)removeExtraball:(BallView *)localExtraball
{
    [pushBehavior removeItem:localExtraball];
    [ballDynamicBehavior removeItem:localExtraball];
    [collisionBehavior removeItem:localExtraball];
    [localExtraball removeFromSuperview];
    [game.extraballs removeObject:localExtraball];
}

-(void)timeToResetExtraball:(NSTimer*)timer
{
        BallView *localExtraball = [timer userInfo];
    [self removeExtraball:localExtraball];
        [myTimer invalidate];
}



- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if ([item1 isKindOfClass:[BlockImageView class]]) {
        [self hitBlock:item1];
    }
    
    if ([item2 isKindOfClass:[BlockImageView class]]) {
        [self hitBlock:item2];
    }
    
    if(game.levelFinished)
    {
              [dynamicAnimator removeBehavior:snapBall];
        [dynamicAnimator updateItemUsingCurrentState:ballView];
        
        // next Level
        pushBehavior.active = NO;
        [collisionBehavior removeItem:ballView];
        
  
        [self clearLevel];
        startButton.hidden = NO;
        [self setupLevel:(game.currentPlayer==1) ? game.player1Level : game.player2Level];
    }
    
}

@end
