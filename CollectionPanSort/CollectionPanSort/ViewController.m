//
//  ViewController.m
//  CollectionPanSort
//
//  Created by Tangguo on 16/5/10.
//  Copyright © 2016年 何月. All rights reserved.
//

#import "ViewController.h"
#import "SortCollectionViewCell.h"

#define DEVICE_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define DEVICE_HEIGHT  ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIImageView *_moveingView;
    BOOL _isFirstChaned;
    UICollectionView *_mineCollection;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"长按拖动";
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    for (int i = 0; i < 30; i++) {
        [self.imagesArray addObject:[NSString stringWithFormat:@"%d",i+1]];
    }

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.sectionInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    _mineCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64.0, DEVICE_WIDTH, DEVICE_HEIGHT - 64.0) collectionViewLayout:layout];
    _mineCollection.backgroundColor = [UIColor lightGrayColor];
    _mineCollection.dataSource = self;
    _mineCollection.delegate = self;
    [_mineCollection registerClass:[SortCollectionViewCell class] forCellWithReuseIdentifier:@"SortCollectionViewCell"];
    [self.view addSubview:_mineCollection];
    
    _moveingView = [[UIImageView alloc] init];
    _moveingView.frame = CGRectMake(0, 0, (DEVICE_WIDTH - 25.0) / 4.0, (DEVICE_WIDTH - 25.0) / 4.0);
    
}

- (NSMutableArray *)imagesArray{
    if (!_imagesArray) {
        self.imagesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesArray;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((DEVICE_WIDTH - 25.0) / 4.0, (DEVICE_WIDTH - 25.0) / 4.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    SortCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SortCollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.cellLebel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    if (cell.gestureRecognizers.count == 0) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        [cell addGestureRecognizer:longPress];
    }
    return cell;
}


- (void)longPressGesture:(UILongPressGestureRecognizer *)sender {
    
    SortCollectionViewCell *cell = (SortCollectionViewCell *)sender.view;
    NSIndexPath *cellIndexPath = [_mineCollection indexPathForCell:cell];
    
    BOOL isChanged = NO;
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        _isFirstChaned = YES;
        
        _moveingView.center = cell.center;
        _moveingView.image = [cell getImageView];
        [_mineCollection addSubview:_moveingView];
        cell.hidden = YES;
        
        [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _moveingView.center = cell.center;
            _moveingView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            _moveingView.alpha = 0.6;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }else if (sender.state == UIGestureRecognizerStateChanged){
        
        cell.center = [sender locationInView:_mineCollection];
        
        if (_isFirstChaned) {
            _isFirstChaned = NO;
            [UIView animateWithDuration:.4f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _moveingView.center = cell.center;
            } completion:^(BOOL finished) {
                cell.hidden = YES;
            }];
        }else {
            _moveingView.center = cell.center;
        }
        
        NSIndexPath *index = [_mineCollection indexPathForItemAtPoint:cell.center];
        if (index) {
            isChanged = YES;
            //对数组中存放的元素重新排序
            NSString *imageStr = self.imagesArray[cellIndexPath.row];
            [self.imagesArray removeObjectAtIndex:cellIndexPath.row];
            [self.imagesArray insertObject:imageStr atIndex:index.row];
            
            [_mineCollection moveItemAtIndexPath:cellIndexPath toIndexPath:index];
        }
        
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (!isChanged) {
            [UIView animateWithDuration:0.4 animations:^{
                cell.center = [_mineCollection layoutAttributesForItemAtIndexPath:cellIndexPath].center;
            }];
            
            [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _moveingView.center = cell.center;
                _moveingView.transform = CGAffineTransformMakeScale(1, 1);
                _moveingView.alpha = 1;
            } completion:^(BOOL finished) {
                cell.hidden = NO;
                [_moveingView removeFromSuperview];
            }];
        }
    }
    
}


@end
