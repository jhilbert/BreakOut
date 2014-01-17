//
//  BreakOut.h
//  BreakOut
//
//  Created by Josef Hilbert on 17.01.14.
//  Copyright (c) 2014 Stephen Compton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockImageView.h"

@interface BreakOut : NSObject

@property (nonatomic) NSMutableArray *player1Blocks;
@property (nonatomic) NSMutableArray *player2Blocks;
@property (nonatomic) NSMutableArray *blocks;
@property (nonatomic) NSInteger numberOfPlayers;
@property (nonatomic) NSInteger currentPlayer;
@property (nonatomic) NSInteger numberOfTurns;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSString *player1;
@property (nonatomic) NSString *player2;
@property (nonatomic) NSInteger player1Score;
@property (nonatomic) NSInteger player2Score;
@property (nonatomic) NSInteger player1Lifes;
@property (nonatomic) NSInteger player2Lifes;
@property (nonatomic) NSInteger player1Level;
@property (nonatomic) NSInteger player2Level;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) NSInteger numberOfLifes;


- (void)initGameForPlayers:(NSInteger)numberOfPlayers;
- (NSMutableArray*)setGameForLevel:(NSInteger)level;

-(NSInteger)hitBlock:(BlockImageView*)block;

- (void)lostBall;
- (BOOL)levelFinished;
- (void)flipPlayer;

@end
