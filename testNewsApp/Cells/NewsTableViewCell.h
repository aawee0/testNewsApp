//
//  NewsTableViewCell.h
//  testNewsApp
//
//  Created by Evgeny Patrikeev on 02.07.2018.
//  Copyright © 2018 Evgeny Patrikeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

- (void)updateWithTitle:(NSString *)title andDescription:(NSString *)desc;

@end
