//
//  BlockImageView.m
//  BreakOut
//
//  Created by Josef Hilbert on 16.01.14.
//  Copyright (c) 2014 Stephen Compton. All rights reserved.
//

#import "BlockImageView.h"

@implementation BlockImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)takeAHit
{
    if (self.typeOfBlock < 4)
    {
        NSInteger i = self.hitsToDestroy - 1;
        [self setTypeOfBlock:i];
        [self setImageForBlock];
    }
}

-(void)setImageForBlock
{
    switch (self.typeOfBlock) {
        case 1:
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Explode1.png"]];
            // load all the frames of our animation
            self.animationImages = [NSArray arrayWithObjects:
                                    [UIImage imageNamed:@"Explode1.png"],
                                    [UIImage imageNamed:@"Explode2.png"],
                                    [UIImage imageNamed:@"Explode3.png"],
                                    [UIImage imageNamed:@"Explode4.png"],
                                    [UIImage imageNamed:@"Explode5.png"],
                                    [UIImage imageNamed:@"Explode6.png"],
                                    [UIImage imageNamed:@"Explode7.png"], nil];
            
            // all frames will execute in 1.75 seconds
            self.animationDuration = 0.5;
            // repeat the animation forever
            self.animationRepeatCount = 1;
            self.hitsToDestroy = 1;
            break;
        case 2:
            self.backgroundColor = [UIColor yellowColor];
            self.animationRepeatCount = 1;
            self.hitsToDestroy = 2;
            break;
        case 3:
            self.backgroundColor = [UIColor whiteColor];
            self.animationRepeatCount = 1;
            self.hitsToDestroy = 3;
            break;
        case 4:
            self.backgroundColor = [UIColor orangeColor];
            self.hitsToDestroy = 1;
            break;
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
