
#import "NewsTableViewCell.h"

@interface NewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *cellNewsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellNewsDescLabel;

@end

@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateWithTitle:(NSString *)title andDescription:(NSString *)desc {
    _cellNewsTitleLabel.text = title;
    _cellNewsDescLabel.text = desc;
}

@end
