//
//  DetailTableViewCell.h
//  XTodo
//

#import <UIKit/UIKit.h>
#import "../Models/TodoItem.h"
#import <Masonry/Masonry.h>
#import "../Models/StoreOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailTableViewCell : UIViewController

- (instancetype)initWithDate:(TodoItem *)todoItem;

@end

NS_ASSUME_NONNULL_END
