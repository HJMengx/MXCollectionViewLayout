//
//  MXCollectionViewLayout.h
//  MXExtensionTableViewCell
//
//  Created by mx on 2017/6/8.
//  Copyright © 2017年 mengx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXCollectionViewLayout;

@protocol MXCollectionViewLayoutDelegate <NSObject>

- (CGFloat) MXCollectionViewLayout:(MXCollectionViewLayout*)layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath;

@end

@interface MXCollectionViewLayout : UICollectionViewLayout

/*设置代理，获取动态高度*/
@property (nonatomic,strong)id<MXCollectionViewLayoutDelegate> delegate;

- (instancetype) initWithCols:(NSUInteger)cols ColMargin:(CGFloat)colMargin RowMargin:(CGFloat)rowMargin Inset:(UIEdgeInsets)inset;

@end
