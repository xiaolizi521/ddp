







#import "Constants.h"
#import "Level.h"
#import "Tile.h"
#import "CCLayer.h"
#import "Constants.h"


@interface Box : NSObject {
	id first, second;
	CGSize size;
	NSMutableArray *content;
	NSMutableSet *readyToRemoveTiles;
	BOOL lock;
	CCLayer *layer;
	Tile *OutBorderTile;
   
}
@property (nonatomic, strong) CCArray *arrFace;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) CCLayer *layer;
@property (nonatomic, readonly) CGSize size;
@property (nonatomic) BOOL lock;


-(id) initWithSize: (CGSize) size level: (Level*) alevel;
-(Tile *) objectAtX: (int) posX Y: (int) posY;
-(BOOL) check;
-(void) unlock;
-(void) removeSprite: (id) sender;
-(void) afterAllMoveDone;
-(BOOL) haveMore;


@end
