





#import "cocos2d.h"
#import "Box.h"
#import "Game.h"
#import "BaseLayer.h"
#import "NameInputAlertViewDelegate.h"


@interface PlayLayer : BaseLayer
{
    Game *game;
	Box *box;
	Tile *selectedTile;
	Tile *firstOne;
    
    int					startIntroIndex;
	NSArray				*startIntroArray;
    
    
    //时间进度
    ccTime time;
	NSString *changTime;
	int proDt;
}

+(id) scene;
-(void) changeWithTileA: (Tile *) a TileB: (Tile *) b sel : (SEL) sel;
-(void) check: (id) sender data: (id) data;

-(void) actionBack:(id)sender;
-(void) actionChangerAvatar;

//时间进度
- (void) setPb_bar;
- (void) progress;


@end
