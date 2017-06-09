//
//  MXCollectionViewLayout.m
//  MXExtensionTableViewCell
//
//  Created by mx on 2017/6/8.
//  Copyright © 2017年 mengx. All rights reserved.
//

#import "MXCollectionViewLayout.h"

@interface MXCollectionViewLayout()

/*存放列数*/
@property (nonatomic,assign)NSUInteger numberOfCols;

/*边距*/
@property (nonatomic,assign)UIEdgeInsets inset;

/*行间距*/
@property (nonatomic,assign)CGFloat MXRowMargin;

/*列间距*/
@property (nonatomic,assign)CGFloat MXColMargin;

//存放布局属性
@property (nonatomic,strong)NSMutableArray<UICollectionViewLayoutAttributes*>* MXAttris;

//存放当前每一列的高度
@property (nonatomic,strong)NSMutableArray<NSNumber *>* colsHeight;

@end

@implementation MXCollectionViewLayout

- (instancetype)initWithCols:(NSUInteger)cols ColMargin:(CGFloat)colMargin RowMargin:(CGFloat)rowMargin Inset:(UIEdgeInsets)inset{
    
    if(self = [super init]){
        //相关赋值方法
        self.numberOfCols = cols;
        
        self.MXColMargin = colMargin;
        
        self.MXRowMargin = rowMargin;
        
        self.inset = inset;
    }
    
    return self;
}

#pragma mark 懒加载
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)MXAttris{
    
    if(!_MXAttris){
        _MXAttris = [[NSMutableArray alloc] init];
        
    }
    
    return _MXAttris;
}

- (NSMutableArray<NSNumber *> *)colsHeight{
    if(!_colsHeight){
        _colsHeight = [NSMutableArray array];
        
        for (int index = 0; index < self.numberOfCols; index++) {
            [_colsHeight addObject:[NSNumber numberWithDouble:self.inset.top]];
        }
    }
    
    return _colsHeight;
}
//每一次是否重新设置属性
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

//布局前的准备
//当布局开始和布局失效时候调用
//刷新的时候也会调用，满足需求，先将之前的全部移除，然后重新返回最新的布局属性数组
- (void)prepareLayout{
    [super prepareLayout];
    //清空最大高度数组
    [self.colsHeight removeAllObjects];
    for (int index = 0; index < self.numberOfCols; index++) {
        [self.colsHeight addObject:[NSNumber numberWithDouble:self.inset.top]];
    }
    
    //清空属性
    [self.MXAttris removeAllObjects];
    
    //重新添加属性
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int index = 0; index < count; index++) {
        UICollectionViewLayoutAttributes* attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        [self.MXAttris addObject:attribute];
    }
    
}

//返回ContentSize,内容的宽高，控制滚动方向
- (CGSize)collectionViewContentSize{
    CGFloat width =  self.collectionView.bounds.size.width;
    //找出最大的高度
    //从第一个开始
    CGFloat height = [self.colsHeight[0] doubleValue];
    
    for (int index = 1; index < self.numberOfCols; index++) {
        if(height < [self.colsHeight[index] doubleValue]){
            height = [self.colsHeight[index] doubleValue];
        }
    }
    
    return CGSizeMake(width, height + self.inset.bottom);
}

//返回指定位置的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //在这里设置属性
    //找出最短的那一列，因为需要在下面添加新的Cell
    int minCol = 0;
    
    for (int index = 1; index < self.colsHeight.count; index++) {
        if([self.colsHeight[minCol] doubleValue] > [self.colsHeight[index] doubleValue]){
            minCol = index;
        }
    }
    
    //计算尺寸
    CGFloat width = (self.collectionView.bounds.size.width - self.inset.left - self.inset.right - (self.numberOfCols - 1) * self.MXColMargin) / self.numberOfCols;
    
    CGFloat height = 0;
    
    if([self.delegate respondsToSelector:@selector(MXCollectionViewLayout:heightForWidth:atIndexPath:)]){
        
        height = [self.delegate MXCollectionViewLayout:self heightForWidth:width atIndexPath:indexPath];
    }
    //计算位置
    CGFloat x = self.inset.left + (width + self.MXColMargin) * minCol;
    
    CGFloat y = self.MXRowMargin + [self.colsHeight[minCol] doubleValue];
    
    //修改最短行高
    self.colsHeight[minCol] = [NSNumber numberWithDouble:y + height];
    
    //为对应位置创建属性
    UICollectionViewLayoutAttributes* attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attribute.frame = CGRectMake(x, y, width, height);
    
    return attribute;
}

//返回Rect范围内的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.MXAttris;
}


@end
