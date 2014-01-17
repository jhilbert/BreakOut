//
//  BreakOut.m
//  BreakOut
//
//  Created by Josef Hilbert on 17.01.14.
//  Copyright (c) 2014 Stephen Compton. All rights reserved.
//

#import "BreakOut.h"
#import "BlockImageView.h"

@implementation BreakOut

{
 
}

//static NSInteger numberOfLifes;
//
//+(void)setNumberOfLifes:(NSInteger)numberOfLifes
//{
//    BreakOut.numberOfLifes = numberOfLifes;
//}
//
//+(NSInteger)numberOfLifes
//{
////    return BreakOut.numberOfLifes;
//    return 3;
//}

- (void)initGameForPlayers:(NSInteger)numberOfPlayers
{
    _numberOfLifes = 5;
    
    _player1Score = 0;
    _player2Score = 0;
    _player1Level = 1;
    _player2Level = 1;
    _player1Lifes = _numberOfLifes;
    _player2Lifes = _numberOfLifes;
    _player2Score = 0;
    _level = 0;
    _numberOfTurns = 0;
    _numberOfPlayers = numberOfPlayers;
    _currentPlayer = 1;
    _blocks = [NSMutableArray alloc];
    _player1Blocks = [NSMutableArray alloc];
    _player2Blocks = [NSMutableArray alloc];
    _gameOver = NO;
    _blocks = [NSMutableArray array];

    
}

- (NSMutableArray*)setGameForLevel:(NSInteger)level
{
    if ([self levelFinished])
    {
    
    _blocks = [NSMutableArray array];
    switch (level) {
        case 1:
            for (int y=1; y<2; y++)
            {
                for (int x=1; x<2; x++)
                {
                    BlockImageView *newBlock = [[BlockImageView alloc] initWithFrame: CGRectMake(20+(x*32), (50 +(y*25)), 30.0, 15.0)];
                    newBlock.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Explode1.png"]];
                    
                    // load all the frames of our animation
                    newBlock.animationImages = [NSArray arrayWithObjects:
                                                [UIImage imageNamed:@"Explode1.png"],
                                                [UIImage imageNamed:@"Explode2.png"],
                                                [UIImage imageNamed:@"Explode3.png"],
                                                [UIImage imageNamed:@"Explode4.png"],
                                                [UIImage imageNamed:@"Explode5.png"],
                                                [UIImage imageNamed:@"Explode6.png"],
                                                [UIImage imageNamed:@"Explode7.png"], nil];
                    
                    // all frames will execute in 1.75 seconds
                    newBlock.animationDuration = 0.5;
                    // repeat the animation forever
                    newBlock.animationRepeatCount = 1;

                    [_blocks addObject:newBlock];
                }
            }
            break;
        case 2:
            for (int y=1; y<3; y++)
            {
                for (int x=1; x<3; x++)
                {
                    BlockImageView *newBlock = [[BlockImageView alloc] initWithFrame: CGRectMake(20+(x*32), (50 +(y*25)), 30.0, 15.0)];
                    newBlock.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Explode1.png"]];
                    
                    // load all the frames of our animation
                    newBlock.animationImages = [NSArray arrayWithObjects:
                                                [UIImage imageNamed:@"Explode1.png"],
                                                [UIImage imageNamed:@"Explode2.png"],
                                                [UIImage imageNamed:@"Explode3.png"],
                                                [UIImage imageNamed:@"Explode4.png"],
                                                [UIImage imageNamed:@"Explode5.png"],
                                                [UIImage imageNamed:@"Explode6.png"],
                                                [UIImage imageNamed:@"Explode7.png"], nil];
                    
                    // all frames will execute in 1.75 seconds
                    newBlock.animationDuration = 0.5;
                    // repeat the animation forever
                    newBlock.animationRepeatCount = 1;
                    
                    [_blocks addObject:newBlock];
                }
            }
            break;
        case 3:
            for (int y=1; y<5; y++)
            {
                for (int x=1; x<8; x++)
                {
                    BlockImageView *newBlock = [[BlockImageView alloc] initWithFrame: CGRectMake(20+(x*32), (50 +(y*25)), 30.0, 15.0)];
                    newBlock.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Explode1.png"]];
                    
                    // load all the frames of our animation
                    newBlock.animationImages = [NSArray arrayWithObjects:
                                                [UIImage imageNamed:@"Explode1.png"],
                                                [UIImage imageNamed:@"Explode2.png"],
                                                [UIImage imageNamed:@"Explode3.png"],
                                                [UIImage imageNamed:@"Explode4.png"],
                                                [UIImage imageNamed:@"Explode5.png"],
                                                [UIImage imageNamed:@"Explode6.png"],
                                                [UIImage imageNamed:@"Explode7.png"], nil];
                    
                    // all frames will execute in 1.75 seconds
                    newBlock.animationDuration = 0.5;
                    // repeat the animation forever
                    newBlock.animationRepeatCount = 1;
                    
                    [_blocks addObject:newBlock];
                }
            }

            break;
            
        default:
            for (int y=1; y<(5+level-3); y++)
            {
                for (int x=1; x<8; x++)
                {
                    BlockImageView *newBlock = [[BlockImageView alloc] initWithFrame: CGRectMake(20+(x*32), (50 +(y*25)), 30.0, 15.0)];
                    newBlock.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Explode1.png"]];
                    
                    // load all the frames of our animation
                    newBlock.animationImages = [NSArray arrayWithObjects:
                                                [UIImage imageNamed:@"Explode1.png"],
                                                [UIImage imageNamed:@"Explode2.png"],
                                                [UIImage imageNamed:@"Explode3.png"],
                                                [UIImage imageNamed:@"Explode4.png"],
                                                [UIImage imageNamed:@"Explode5.png"],
                                                [UIImage imageNamed:@"Explode6.png"],
                                                [UIImage imageNamed:@"Explode7.png"], nil];
                    
                    // all frames will execute in 1.75 seconds
                    newBlock.animationDuration = 0.5;
                    // repeat the animation forever
                    newBlock.animationRepeatCount = 1;
                    
                    [_blocks addObject:newBlock];
                }
            }
           
            
            break;
    }

    }
    else
        if (_currentPlayer == 1) {
            _blocks = _player1Blocks;
        }
        else{
            _blocks = _player2Blocks;
        }
    
    return _blocks;
}

-(NSInteger)hitBlock:(BlockImageView*)block{
    
    [_blocks removeObject:block];
    int hitValue = 0;
    
    hitValue = 10;
    if (_currentPlayer == 1)
    {
        _player1Score += hitValue;
    }
    else
    {
        _player2Score += hitValue;
    }
    return hitValue;
    
}

-(void)lostBall
{
    if (_currentPlayer == 1)
    {
        _player1Lifes -= 1;
        if (_player1Lifes == 0)
            _gameOver = YES;
        _player1Blocks = _blocks;
    }
    else
    {
        _player2Lifes -= 1;
        if (_player2Lifes == 0)
            _gameOver = YES;
        _player2Blocks = _blocks;
    }
}

 
//    int lostBallValue = 50;
//    if (_currentPlayer == 1)
//    {
//        _player1Score -= lostBallValue;
//        if (_player1Score < 0)
//        {
//            _player1Score = 0;
//        }
//    }
//    else
//    {
//        _player2Score -= lostBallValue;
//        if (_player2Score < 0)
//        {
//            _player2Score = 0;
//        }
//    }

- (BOOL)levelFinished
{
    if (_blocks.count == 0)
    {
        if(_currentPlayer == 1)
        {
            _player1Level++;
        }
        else
        {
            _player2Level++;
        }
        return YES;
    }
    else
        return NO;
}

- (void)flipPlayer
{
    if (_currentPlayer == 1)
    {
        _currentPlayer = 2;
    }
    else
    {
        _currentPlayer = 1;
    }
}


@end
