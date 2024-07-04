//
//  TodoItemViewCell.m
//  XTodo
//

#import "TodoItemViewCell.h"

@interface TodoItemViewCell ()

@property (nonatomic, strong, readwrite) UIButton *checkboxButton;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *contentLabel;
@property (nonatomic, strong, readwrite) UILabel *dateLabel;
@property (nonatomic, strong, readwrite) StoreOperation *dataOperation;

@end


@implementation TodoItemViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *circleImage = [[UIImage systemImageNamed:@"circle"] imageWithTintColor:[UIColor lightGrayColor] renderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.checkboxButton setImage:circleImage forState:UIControlStateNormal];
        [self.checkboxButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"] forState:UIControlStateSelected];
        [self.checkboxButton addTarget:self action:@selector(checkboxTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.checkboxButton];

        [self.checkboxButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(6);
            make.top.equalTo(self.contentView.mas_top).offset(8);
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(24);
        }];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.4];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 1;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.titleLabel];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(36);
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
        }];

        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.numberOfLines = 1;
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.contentLabel];

        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.checkboxButton.mas_left).offset(30);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.5);
        }];

        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        self.dateLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.dateLabel];

        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];

        // init
        self.dataOperation = [[StoreOperation alloc] init];
    }

    return self;
}

- (void)checkboxTapped:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (sender.selected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:@{ NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle) }];
            self.titleLabel.textColor = [UIColor lightGrayColor];
            self.contentLabel.enabled = NO;
            self.dateLabel.textColor = [UIColor lightGrayColor];
            self.dateLabel.enabled = NO;
        });

        // Delay the execution by 3 seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Notify the delegate
            if ([self.todoDelegate respondsToSelector:@selector(todoItemViewCell:didTapCheckbox:isSelected:)]) {
                [self.todoDelegate todoItemViewCell:self didTapCheckbox:sender isSelected:sender.selected];
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:@{ NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone) }];
            self.titleLabel.textColor = [UIColor blackColor];
            self.contentLabel.enabled = YES;
            self.dateLabel.textColor = [UIColor grayColor];
            self.dateLabel.enabled = YES;
        });

        // Delay the execution by 3 seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Notify the delegate
            if ([self.completedDelegate respondsToSelector:@selector(completedItemViewCell:didTapCheckbox:isSelected:)]) {
                [self.completedDelegate completedItemViewCell:self didTapCheckbox:sender isSelected:sender.selected];
            }
        });
    }
}

- (void)layoutTableViewCell:(TodoItem *)todoItem isSelected:(BOOL)isSelected {
    self.titleLabel.text = todoItem.title;
    self.contentLabel.text = todoItem.content;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];     // Set the desired date format

    // Convert the NSDate to an NSString
    NSString *dateString = [dateFormatter stringFromDate:todoItem.date];

    self.dateLabel.text = dateString;
    
    if (isSelected) {
        self.checkboxButton.selected = YES;
        self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:@{ NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle) }];
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.contentLabel.enabled = NO;
        self.dateLabel.textColor = [UIColor lightGrayColor];
        self.dateLabel.enabled = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
