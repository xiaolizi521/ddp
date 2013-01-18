




#import "cocos2d.h"
#import "Level.h"
#import "UserInfo.h"
#import "Skills.h"

typedef enum GameState__ {
    kGameStateIntro,
    kGameStatePrepare,   //准备
	kGameStateWin,       //胜利
	kGameStateLost,      //失败
	kGameStatePlaying,   //进行中
	kGameStatePause      //暂停
}GameState;



@interface Game : NSObject

@property (nonatomic) GameState state;
@property (nonatomic, readonly) Level *level;
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) float usedTime;
@property (nonatomic, readonly) int lastKind;
@property (nonatomic, readonly) int lastKindCount;
@property (nonatomic, readonly) int ballRetainCount;
@property (nonatomic, retain) Skills *bombSkill;
@property (nonatomic, retain) Skills *suffleSkill;


-(void) notifyNewLink: (int) kind;
-(void) plusUsedTime: (float) delta;

@end
