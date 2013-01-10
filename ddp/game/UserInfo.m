






#import "UserInfo.h"

@implementation UserInfo



#pragma mark- init & clear 
+(void) init{
    
    [self saveScore:0];
	[self saveWinedLevel:0];
	[self saveUsedTime:0];
    
}

+(void) clear{
    
    [self init];
}

#pragma mark- #Action get methods
+(NSString *) name{
    
	return [[NSUserDefaults standardUserDefaults] stringForKey:kName];
}

+(int) score{
    
	int score = [[NSUserDefaults standardUserDefaults] integerForKey: kScore];	
	if (score < 0) {
		return 0;
	}
    
	return score;
}

+(int) usedTime{
	return [[NSUserDefaults standardUserDefaults] integerForKey: kUsedTime];
}

+(int) winedLevel{
	int winedLevel = [[NSUserDefaults standardUserDefaults] integerForKey: kWindedLevel];	
	if (winedLevel <= 0) {
		return 0;
	}
	return winedLevel;
}

+(int) nextLevel{
	int winedLevel = [self winedLevel];
	return winedLevel % kMaxLevelNo + 1;
}


#pragma mark- #Action set methods

+(void) saveName: (NSString *) name{
    
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:kName];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


+(void) saveScore: (int) score{
    
	[[NSUserDefaults standardUserDefaults] setInteger:score forKey:kScore];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


+(void) saveWinedLevel: (int) winedLevel{
    
	if ([self winedLevel] >= winedLevel) {
		return;
	}
    
	[[NSUserDefaults standardUserDefaults] setInteger: winedLevel forKey:kWindedLevel];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) saveUsedTime: (int) usedTime{
    
	[[NSUserDefaults standardUserDefaults] setInteger:usedTime forKey:kUsedTime];
	[[NSUserDefaults standardUserDefaults] synchronize];	
}
@end
