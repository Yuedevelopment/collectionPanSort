//
//  SortCollectionViewCell.h
//  CollectionPanSort
//
//  Created by Tangguo on 16/5/10.
//  Copyright © 2016年 何月. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *cellLebel;

-(UIImage *)getImageView;

@end
