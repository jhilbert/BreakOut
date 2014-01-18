//
//  BlockImageView.h
//  BreakOut
//
//  Created by Josef Hilbert on 16.01.14.
//  Copyright (c) 2014 Stephen Compton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockImageView : UIImageView

{

}

@property NSInteger typeOfBlock;
@property NSInteger value;
@property NSInteger hitsToDestroy;

-(void)setImageForBlock;
-(void)takeAHit;

@end
