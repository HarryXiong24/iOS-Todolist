//
//  CreateTodoControllerViewController.h
//  XTodo
//

#import <UIKit/UIKit.h>
#import "../Models/TodoItem.h"
#import <Masonry/Masonry.h>
#import "../Models/StoreOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditTodoViewController : UIViewController

@property (nonatomic, readwrite) BOOL isEdit;

- (void)update:(TodoItem *)todoItem;

@end

NS_ASSUME_NONNULL_END
