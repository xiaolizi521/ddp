





#import "cocos2d.h"
#import "Box.h"
#import "BaseLayer.h"
@interface PlayLayer : BaseLayer
{
	Box *box;
	Tile *selectedTile;
	Tile *firstOne;
    
    
    //时间进度
    ccTime time;
	NSString *changTime;
	int proDt;
}
+(id) scene;
-(void) back:(id)sender;
-(void) changeWithTileA: (Tile *) a TileB: (Tile *) b sel : (SEL) sel;
-(void) check: (id) sender data: (id) data;


//时间进度
- (void) setPb_bar;
- (void) progress;


@end
