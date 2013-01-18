//
//  Level.m
//  ddp
//
//  Created by Liu Lei on 13-1-17.
//
//

#import "Level.h"

@implementation Level

@end



@implementation LevelManager

+(Level *) get: (int) no{
	int factor = 14;
	Level *level = [[[Level alloc] init] autorelease];
	level.no = no;
	level.factor = factor;
	level.tileMoveType = arc4random()%TileMove_Max;
    //	level.timeLimit = 100-5*no;
	level.timeLimit = 5;
	return level;
}
@end