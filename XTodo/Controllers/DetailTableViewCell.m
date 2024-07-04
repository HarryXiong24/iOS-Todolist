//
//  DetailTableViewCell.m
//  XTodo
//

#import "DetailTableViewCell.h"


@interface DetailTableViewCell ()

@property (nonatomic, readwrite) TodoItem *todoItem;
@property (nonatomic, strong) UILabel *titleText;
@property (nonatomic, strong) UILabel *contentText;
@property (nonatomic, strong) UILabel *dateText;
@property (nonatomic, strong) StoreOperation *operation;

@end

@implementation DetailTableViewCell

- (instancetype)initWithDate:(TodoItem *)todoItem {
    self= [super init];
    if (self) {
        self.todoItem = todoItem;
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.title = @"Detail";

	// left button
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.navigationItem.rightBarButtonItem = rightButton;

	// Title input
	self.titleText = [[UILabel alloc] init];
    self.titleText.font = [UIFont systemFontOfSize:16 weight:0.4];
    self.titleText.textColor = [UIColor blackColor];
    self.titleText.numberOfLines = 1;
    self.titleText.text = self.todoItem.title;
    [self.view addSubview: self.titleText];

	[self.titleText mas_makeConstraints:^(MASConstraintMaker *make) {
	         make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
	         make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
	 }];

	// Description input
	self.contentText = [[UILabel alloc] init];
    self.contentText.font = [UIFont systemFontOfSize:14];
    self.contentText.textColor = [UIColor blackColor];
    self.contentText.numberOfLines = 6;
    self.contentText.lineBreakMode = NSLineBreakByTruncatingTail;
    self.contentText.text = self.todoItem.content;
	[self.view addSubview:self.contentText];

	[self.contentText mas_makeConstraints:^(MASConstraintMaker *make) {
	         make.top.equalTo(self.titleText.mas_bottom).offset(5);
	         make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
	         make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
	         make.height.mas_equalTo(100);
	 }];


	// Time input
	self.dateText = [[UILabel alloc] init];
    self.dateText.font = [UIFont systemFontOfSize:12];
    self.dateText.textColor = [UIColor grayColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // Set the desired date format
    // Convert the NSDate to an NSString
    NSString *dateString = [dateFormatter stringFromDate:self.todoItem.date];
    self.dateText.text = dateString;
	[self.view addSubview:self.dateText];

	[self.dateText mas_makeConstraints:^(MASConstraintMaker *make) {
	         make.top.equalTo(self.contentText.mas_bottom).offset(5);
	         make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
	 }];
}

- (void) back {

	// if I use NavigationBar
	//    [self.navigationController popViewControllerAnimated:YES];

	// normal way
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
