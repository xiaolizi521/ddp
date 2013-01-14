//
//  SetUserInfoLayer.m
//  ddp
//
//  Created by Coolin 006 on 13-1-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "SetUserInfoLayer.h"


@implementation SetUserInfoLayer


-(id)init{
    
    self = [super init];
    
    
    CCMenuItemFont *back = [CCMenuItemFont itemWithString:@"back" block:^(id sender){
        
        [self back:nil];
    }];
	CCMenu *menu = [CCMenu menuWithItems: back, nil];
	menu.position = ccp(160, 150);
	[self addChild: menu];
    
    return self;
}

-(void) back: (id) sender{
    
	[self removeFromParentAndCleanup:YES];
    
}

@end
