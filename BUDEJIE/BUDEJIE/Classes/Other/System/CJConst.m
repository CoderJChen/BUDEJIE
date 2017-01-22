#import <UIKit/UIKit.h>

/** UITabBar的高度 */
CGFloat const CJTabBarH = 49;

/** 导航栏的最大Y值 */
CGFloat const CJNavMaxY = 64;

/** 标题栏的高度 */
CGFloat const CJTitlesViewH = 35;

/** 全局统一的间距 */
CGFloat const CJMargin = 10;

/** 统一较小的间距 */
CGFloat const CJCommonSmallMargin = 5;

/** 统一的一个请求路径 */
NSString  * const CJCommonURL = @"http://api.budejie.com/api/api_open.php";

/** 标签的高度 */
 CGFloat const CJTagH = 25;

/** 帖子-文字的Y值 */
 CGFloat const CJTopicTextY = 55;

/** 帖子-底部工具条的高度 */
 CGFloat const CJTopicToolbarH = 35;

/** 帖子-最热评论-顶部的高度 */
 CGFloat const CJTopicTopCmtTopH = 20;

/** 性别-男 */
 NSString * const CJUserSexMale = @"male";

/** 性别-女 */
 NSString * const CJUserSexFemale = @"female";


/** TabBarButton被重复点击的通知 */
 NSString  * const CJTabBarButtonDidRepeatClickNotification = @"CJTabBarButtonDidRepeatClickNotification";

/** TitleButton被重复点击的通知 */
 NSString  * const CJTitleButtonDidRepeatClickNotification = @"CJTitleButtonDidRepeatClickNotification";
/** 选中表情按钮的通知 */
 NSString * const CJEmotionDidSelectNotification = @"CJEmotionDidSelectNotification";

/** 删除表情的通知 */
 NSString * const CJEmotionDidDeleteNotification = @"CJEmotionDidDeleteNotification";

/** 选中表情的key */
 NSString * const CJSelectEmotionKey = @"CJSelectEmotionKey";
