









#import "Constants.h"


@interface UserInfo : NSObject {

    NSMutableDictionary *dicUserInfo;

}


+(void) init;
+(void) clear;

+(NSString *) name;
+(int) score;
+(int) usedTime;
+(int) winedLevel;
+(int) nextLevel;

+(void) saveName: (NSString *) name;
+(void) saveScore: (int) score;
+(void) saveWinedLevel: (int) winedLevel;
+(void) saveUsedTime: (int) usedTime;


@end
