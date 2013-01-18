//
//  level.h
//  ddp
//
//  Created by Liu Lei on 13-1-17.
//
//

#import <Foundation/Foundation.h>


typedef enum _TileMoveType {
	TileMove_NoMove = 0,
	TileMove_Up = 1,
	TileMove_Down = 2,
	TileMove_Left = 3,
	Tilemove_Right = 4,
	TileMove_Max = 5
} TileMoveType;


@interface Level : NSObject


@property (nonatomic) int no;
@property (nonatomic) int factor;
@property (nonatomic) TileMoveType tileMoveType;
@property (nonatomic) int timeLimit;
@property (nonatomic, readonly) int tileCount;
@property (nonatomic, readonly) int ballCount;

@end


@interface LevelManager : NSObject

+(Level *) get:(int) no;

@end;
