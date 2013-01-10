//
//  GameLayer.h
//  T01
//
//  Created by li zeyao on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Progress : CCLayer {

	ccTime time;
	NSString *changTime;
	int i;
}
+ (id) scene;
- (void) setPb_bar;
- (void) progress;
@end
