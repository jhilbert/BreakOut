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

@interface ViewController ()<UICollisionBehaviorDelegate>

{
    __weak IBOutlet PaddleView *paddleView;
    UIDynamicAnimator *dynamicAnimator;
    __weak IBOutlet BallView *ballView;
    UIPushBehavior *pushBehavior;
    UICollisionBehavior *collisionBehavior;
    int numberOfBlocks;
}

@end

@implementation ViewController


- (IBAction)dragPaddle:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    paddleView.center = CGPointMake ([panGestureRecognizer locationInView:self.view].x, paddleView.center.y);
    [dynamicAnimator updateItemUsingCurrentState:paddleView];
    
    
}


- (void)restartGame
{
    UIDynamicItemBehavior *ballDynamicBehavior;
    UIDynamicItemBehavior *paddleDynamicBehavior;
    UIDynamicItemBehavior *blockDynamicBehavior;
    
    dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    pushBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
    pushBehavior.active = YES;
    pushBehavior.magnitude = 0.1;
    [dynamicAnimator addBehavior:pushBehavior];
    
    //paddlePushBehavior = [[UIPushBehavior alloc] initWithItems:@[paddleViewTwo] mode:UIPushBehaviorModeInstantaneous];
    
    
    collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ballView, paddleView]];
    collisionBehavior.collisionDelegate=self;
    collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    [dynamicAnimator addBehavior:collisionBehavior];
    
    paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[paddleView]];
    paddleDynamicBehavior.allowsRotation = NO;
    paddleDynamicBehavior.density = 10000.0;
    
    [dynamicAnimator addBehavior:paddleDynamicBehavior];
    
    
    ballDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ballView]];
    ballDynamicBehavior.allowsRotation = NO;
    ballDynamicBehavior.elasticity = 1.0;
    ballDynamicBehavior.friction = 0.0;
    ballDynamicBehavior.resistance = 0.0;
    
    [dynamicAnimator addBehavior:ballDynamicBehavior];
    
    
    blockDynamicBehavior = [[UIDynamicItemBehavior alloc] init];
    blockDynamicBehavior.allowsRotation = NO;
    blockDynamicBehavior.density = 10000.0;
    
    
    numberOfBlocks = 0;
    for (int y=1; y<5; y++)
    {
        for (int x=1; x<8; x++)
        {
            BlockView *newBlock = [[BlockView alloc] initWithFrame: CGRectMake(20+(x*32), (50 +(y*25)), 30.0, 15.0)];
            newBlock.backgroundColor = [UIColor redColor];
            [self.view addSubview:newBlock];
            [collisionBehavior addItem: newBlock];
            [blockDynamicBehavior addItem: newBlock];
            numberOfBlocks++;
            
        }
    }
    
    [dynamicAnimator addBehavior:blockDynamicBehavior];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self restartGame];
}




-(BOOL)shouldStartAgain
{
    if (numberOfBlocks == 0) {
        return YES;
    }else
    {return NO;
    }
}

#pragma mark UICollisionBehaviorDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    if (p.y > 560)
    {ballView.center = CGPointMake(160.0, self.view.center.y);
        [dynamicAnimator updateItemUsingCurrentState:ballView];
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if ([item1 isKindOfClass:[BlockView class]]) {
        
        [collisionBehavior removeItem:item1];
        //[blockDynamicBehavior removeItem: item1];
        [dynamicAnimator updateItemUsingCurrentState:item1];
        ((BlockView*)item1).alpha = 0;
        numberOfBlocks--;
        
    }
    
    if ([item2 isKindOfClass:[BlockView class]]) {
        
        [collisionBehavior removeItem:item2];
        //[item1 removeFromSuperView];
        [dynamicAnimator updateItemUsingCurrentState:item2];
        ((BlockView*)item2).alpha = 0;
        numberOfBlocks--;
        
    }
    
    if([self shouldStartAgain])
    {
        [self restartGame];
        ballView.center = CGPointMake(160.0, self.view.center.y);
        [dynamicAnimator updateItemUsingCurrentState:ballView];
        
    }
    
}

@end
