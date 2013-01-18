

#import "cocos2d.h"


//Game logic
#define kTimeLimit         30
#define kFactor          14

#define kScheduleInterval 0.5f
#define kTimeLabelTag 900
#define kScoreLabelTag 901
#define kComboTag 902
#define kComboNOTag 903
#define kStartHint 904
#define kMenuTag 905

// Game map
#define kTileSize   40.0f
#define kMoveTileTime   0.3f
#define kBoxWidth   7
#define kBoxHeight  7
#define kStartX     20
#define kStartY     130
#define kMaxLevelNo 10
#define kKindCount  8

// The time progress
#define kProBarWidth    210
#define kProBarLeftX    30
#define kProBarY        120


//User info
#define kUserInfo       @"kUserInfo"

#define kScore          @"kScore"
#define kWindedLevel    @"kWindedLevel"
#define kWantLevel      @"kWantLevel"
#define kName           @"kName"
#define kUsedTime       @"kUsedTime"


//Record
#define kMaxRecordCount     5
#define kRecordName         @"kRecordName"
#define kRecordScore        @"kRecordScore"
#define kRecordTime         @"kRecordTime"

typedef enum {
	OrientationHori,
	OrientationVert,
} Orientation;

