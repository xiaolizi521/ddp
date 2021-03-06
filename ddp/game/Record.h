




#import "Constants.h"
#import "UserInfo.h"
@interface Record : NSObject {
	NSString *name;
	int score;
	int time;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int time;


+(int) trySaveTimeRecord: (Record *) newRecord;
+(int) trySaveScoreRecord: (Record *) newRecord;

+(NSArray *) getHighScores;
+(NSArray *) getHighTimes;
+(Record *) createCurrentRecord;

@end
