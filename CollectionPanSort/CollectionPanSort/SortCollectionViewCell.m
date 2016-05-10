//
//  SortCollectionViewCell.m
//  CollectionPanSort
//
//  Created by Tangguo on 16/5/10.
//  Copyright © 2016年 何月. All rights reserved.
//

#import "SortCollectionViewCell.h"

@implementation SortCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _cellLebel = [[UILabel alloc]initWithFrame:CGRectMake(5.0, 5.0, frame.size.width - 10.0, frame.size.height - 10.0)];
        _cellLebel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_cellLebel];
    }
    return self;
}
-(UIImage *)getImageView
{
    return GetImageWithView(self);
}

UIImage * GetImageWithView(UIView * view)
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    
    //获取图像
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
