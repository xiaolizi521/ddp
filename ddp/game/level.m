//
//  Level.m
//  ddp
//
//  Created by Liu Lei on 13-1-17.
//
//

#import "Level.h"

@implementation Level

@synthesize num;
@synthesize factor;
@synthesize tileMoveType;
@synthesize timeLimit;


-(CCArray *)getArrFace:(Level *)alevel{

    CCArray *arrFace = [CCArray arrayWithCapacity:8];
    for (int i = 1; i < 9; i++) {
        NSString *name = [NSString stringWithFormat:@"q%d.png",i];
        [arrFace addObject:name];
    }
   
    return arrFace;
}

-(int) tileCount{
	return kRowCount * kColumnCount;
}

-(BOOL) fillWithColumn: (int) columnIndex row: (int) rowIndex{
	if (columnIndex == 0 || rowIndex == 0) {
		return NO;
	}
	if (columnIndex == (kColumnCount - 1) || rowIndex == (kRowCount - 1)) {
		return NO;
	}
	switch (num) {
            
		case 1:
			return rowIndex%2 != 0;
		case 2:
			if (columnIndex%2 == 0) {
				return rowIndex%2 == 0;
			}else {
				return rowIndex%2 == 1;
			}
		case 3:
			return kRowCount / 2 != rowIndex && kColumnCount/2 != columnIndex;
		case 4:
			return columnIndex%2 == 0 || rowIndex %2 == 0;
		case 5:
			if (columnIndex == 1 || rowIndex == 1 || columnIndex == (kColumnCount-2) || rowIndex == (kRowCount-2)) {
				return YES;
			}
			if (columnIndex == 2) {
				return NO;
			}
			if (rowIndex == 2) {
				return NO;
			}
			if (columnIndex == (kColumnCount-3)) {
				return NO;
			}
			if (rowIndex == (kRowCount-3)) {
				return NO;
			}
			return YES;
		case 6:
		{
			int centerRow = 5;
			int centerColumn = 6;
			int rowSpan = abs(rowIndex - centerRow);
			int columnSpan = abs(columnIndex - centerColumn);
			return rowSpan >= (columnSpan-1);
			
		}
		case 7:
		{
			int centerRow = 5;
			int centerColumn = 6;
			int rowSpan = abs(rowIndex - centerRow);
			int columnSpan = abs(columnIndex - centerColumn);
			return rowSpan < (columnSpan+1);
		}
		case 8:
		{
			int centerRow = 5;
			int centerColumn = 6;
			int rowSpan = abs(rowIndex - centerRow);
			int columnSpan = abs(columnIndex - centerColumn);
			return rowSpan < 6- (columnSpan+1);
		}
            
		case 9:
		{
			int centerRow = 5;
			int centerColumn = 6;
			int rowSpan = abs(rowIndex - centerRow);
			int columnSpan = abs(columnIndex - centerColumn);
			return rowSpan >= 6- (columnSpan+1) || rowSpan < 4-(columnSpan+1);
		}
		case 10:
		{
			return YES;
		}
	}
	return YES;
}
-(int) ballCountRepaired{
	int resultTemp = [self faceCount];
	if (resultTemp%2== 0) {
		return resultTemp;
	}else {
		BOOL centerFill = [self fillWithColumn:kColumnCenter row:kRowCenter];
		if (centerFill) {
			return resultTemp-1;
		}else {
			return resultTemp+1;
		}
        
	}
    
}
-(int) faceCount{
	int result = 0;
	for (int y=0; y<kRowCount; y++) {
		for (int x=0; x<kColumnCount; x++) {
			if ([self fillWithColumn: x row: y]) {
				result++;
			}
		}
	}
	return result;
}


@end



@implementation LevelManager

+(Level *) getLevel: (int) num{
    
	int factor = kFactor;
    
	Level *level = [[[Level alloc] init] autorelease];
	level.num = num;
	level.factor = factor;
	level.tileMoveType = arc4random() % TileMove_Max;
    //level.timeLimit = 100 - 5 * num;
	level.timeLimit = kTimeLimit;
    
	return level;
}


@end