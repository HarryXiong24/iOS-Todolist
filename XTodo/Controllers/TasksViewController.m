//
//  OverallViewController.m
//  XTodo
//

#import "TasksViewController.h"

@interface TasksViewController () <UITableViewDataSource, UITableViewDelegate, TodoItemViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic, readwrite) NSMutableArray<TodoItem *> *todoList;
@property (strong, nonatomic, readwrite) StoreOperation *dataOperation;

@end

@implementation TasksViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	// add observer
	self.dataOperation = [[StoreOperation alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"ListUpdated" object:nil];

	// title and style
	self.navigationItem.title = @"Tasks";
	NSDictionary *titleAttributes = @{
		NSForegroundColorAttributeName: [UIColor blackColor],
		NSFontAttributeName: [UIFont boldSystemFontOfSize:24]
	};
	self.navigationController.navigationBar.titleTextAttributes = titleAttributes;

	// right button
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"]
	                                style:UIBarButtonItemStylePlain
	                                target:self
	                                action:@selector(rightButtonTapped:)];
	self.navigationItem.rightBarButtonItem = rightButton;

	// todo list
	self.tableView = [[UITableView alloc] init];
	[self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.view.mas_height);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];

	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.todoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoItemViewCell *cell = [[TodoItemViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
    
    cell.todoDelegate = self;

	TodoItem *item = [self.todoList objectAtIndex:indexPath.row];

	[cell layoutTableViewCell:item isSelected:false];

	return cell;
}

- (void)todoItemViewCell:(TodoItemViewCell *)cell didTapCheckbox:(UIButton *)checkbox isSelected:(BOOL)selected {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath && selected) {
        TodoItem *todoItem = self.todoList[indexPath.row];
        [self.dataOperation removeItemWithNo:todoItem.no];
        [self.dataOperation savedCompletedListWithTitle:todoItem.title content:todoItem.content date:todoItem.date];
        [self reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CompletedListUpdated" object:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
	// create delete option
	UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {


	                                            // remove item
	                                            TodoItem *item = [self.todoList objectAtIndex:indexPath.row];
	                                            [self.dataOperation removeItemWithNo:item.no];

	                                            [self.todoList removeObjectAtIndex:indexPath.row];
	                                            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	                                            completionHandler(YES);
					    }];

	// create edit option
	UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Edit" handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
	                                          // handle
	                                          TodoItem *item = [self.todoList objectAtIndex:indexPath.row];

	                                          EditTodoViewController *createTodoVC = [[EditTodoViewController alloc] init];
	                                          createTodoVC.modalPresentationStyle = UIModalPresentationFormSheet;
                

	                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                 [createTodoVC update:item];
                                                  createTodoVC.isEdit = true;
                                             });

	                                          UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createTodoVC];
	                                          [self.navigationController presentViewController:nav animated: YES completion: nil];

	                                          completionHandler(YES);
					  }];
	editAction.backgroundColor = [UIColor blueColor];

	// return
	UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction, editAction]];
	return configuration;
}

- (void) rightButtonTapped:(id)sender {
	EditTodoViewController *createTodoVC = [[EditTodoViewController alloc] init];

	// if I use NavigationBar
	//	[self.navigationController pushViewController:createTodoVC animated:YES];

	// I use the normal way
	//	createTodoVC.modalPresentationStyle = UIModalPresentationFormSheet;
	//	[self presentViewController:createTodoVC animated:YES completion:nil];

	createTodoVC.modalPresentationStyle = UIModalPresentationFormSheet;
    createTodoVC.isEdit = false;
    
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createTodoVC];
	[self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TodoItem *item = [self.todoList objectAtIndex:indexPath.row];

    EditTodoViewController *createTodoVC = [[EditTodoViewController alloc] init];
    createTodoVC.modalPresentationStyle = UIModalPresentationFormSheet;


    dispatch_async(dispatch_get_main_queue(), ^{
       [createTodoVC update:item];
        createTodoVC.isEdit = true;
   });

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createTodoVC];
    [self.navigationController presentViewController:nav animated: YES completion: nil];
}


- (void) reloadData {
	self.todoList = [self.dataOperation getTodoList];
	[self.tableView reloadData];
}

@end
