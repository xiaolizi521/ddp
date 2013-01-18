//
//  level.h
//  ddp
//
//  Created by Liu Lei on 13-1-17.
//
//

#import "cocos2d.h"



#define kColumnCount 13
#define kColumnCenter 6
#define kRowCount 11
#define kRowCenter 5

typedef enum _TileMoveType {
	TileMove_NoMove = 0,
	TileMove_Up = 1,
	TileMove_Down = 2,
	TileMove_Left = 3,
	Tilemove_Right = 4,
	TileMove_Max = 5
} TileMoveType;


@interface Level : NSObject


@property (nonatomic) int num;
@property (nonatomic) int factor;
@property (nonatomic) TileMoveType tileMoveType;
@property (nonatomic) int timeLimit;
@property (nonatomic, readonly) int tileCount;
@property (nonatomic, readonly) int faceCount;


-(BOOL) fillWithColumn: (int) columnIndex row: (int) rowIndex;
-(int) ballCountRepaired;
-(CCArray *)getArrFace:(Level *)alevel;

@end


@interface LevelManager : NSObject

+(Level *) getLevel:(int) num;

@end;
