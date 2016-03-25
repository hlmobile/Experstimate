//
//  WKPagesScrollView.h
//  WKPagesScrollView
//
//  Created by 秦 道平 on 13-11-14.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKPagesCollectionViewFlowLayout.h"
#import "WKPagesCollectionViewCell.h"
@class WKPagesCollectionView;
@protocol WKPagesCollectionViewDataSource<UICollectionViewDataSource>
///删除cell时用来删除数据
-(void)collectionView:(WKPagesCollectionView*)collectionView willRemoveCellAtIndexPath:(NSIndexPath*)indexPath;
///追加数据时调用
-(void)willAppendItemInCollectionView:(WKPagesCollectionView*)collectionView;
@end
@protocol WKPagesCollectionViewDelegate <UICollectionViewDelegate>
@optional
///显示时的回调
-(void)collectionView:(WKPagesCollectionView*)collectionView didShownToHightlightAtIndexPath:(NSIndexPath*)indexPath;
///返回原来状态时的回调
-(void)didDismissFromHightlightOnCollectionView:(WKPagesCollectionView*)collectionView;
@end
@interface WKPagesCollectionView : UICollectionView{
    UIImageView* _maskImageView;
    BOOL _maskShow;
}
///是否可以删除
@property (nonatomic,assign) BOOL canRemove;
///显示mask
@property (nonatomic,assign) BOOL maskShow;
///是否正在显示
@property (nonatomic,assign) BOOL isHighLight;
-(id)initWithPagesFlowLayoutAndFrame:(CGRect)frame;
#pragma mark - Action
///显示
-(void)showCellToHighLightAtIndexPath:(NSIndexPath*)indexPath completion:(void(^)(BOOL finished))completion;
///没有动画的显示状态,不会有didShowCellToHightLight回调
-(void)showCellToHighLightAtIndexPath:(NSIndexPath*)indexPath;
///回到原来的滚动状态
-(void)dismissFromHightLightWithCompletion:(void(^)(BOOL finished))completion;
///追加内容
-(void)appendItem;
@end
