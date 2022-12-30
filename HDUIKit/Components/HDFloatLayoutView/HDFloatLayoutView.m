//
//  HDFloatLayoutView.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDFloatLayoutView.h"
#import "HDCommonDefines.h"

#define ValueSwitchAlignLeftOrRight(valueLeft, valueRight) ([self shouldAlignRight] ? valueRight : valueLeft)

const CGSize HDFloatLayoutViewAutomaticalMaximumItemSize = {-1, -1};

typedef struct {
    CGSize size;
    NSUInteger fowardingTotalRowCount;
} HDFloatLayoutViewLayoutGinseng;

@interface HDFloatLayoutView ()

@property (nonatomic, strong) UIButton *moreView;

@property (nonatomic, assign) NSUInteger realMaxRowCount;

@property (nonatomic, strong) NSMutableArray *reuseViews;

@end

@implementation HDFloatLayoutView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self didInitialized];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialized];
    }
    return self;
}

- (void)didInitialized {
    self.contentMode = UIViewContentModeLeft;
    self.minimumItemSize = CGSizeZero;
    self.maxRowCount = 0;
    self.maximumItemSize = HDFloatLayoutViewAutomaticalMaximumItemSize;
}



- (CGSize)sizeThatFits:(CGSize)size {
    return [self layoutSubviewsWithSize:size shouldLayout:NO].size;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutSubviewsWithSize:self.bounds.size shouldLayout:YES];
    
    if(!self.moreView) return; //没有自定义展开按钮
    
    BOOL showAll = NO;
    if(!self.moreView.selected) { //收起状态
        
        [self addSubview:self.moreView];
        
        [self layoutSubviewsWithSize:self.bounds.size shouldLayout:YES];
        
        while (![self isLastViewIsMoreView]) {
            
            UIView *lastObject = [self getLastVisibleSubview];
            [lastObject removeFromSuperview];
            [self.reuseViews insertObject:lastObject atIndex:0];
            [self addSubview:self.moreView];
            [self layoutSubviewsWithSize:self.bounds.size shouldLayout:YES];
        }
    }else{ //展开状态
        
        showAll = YES;
        
        for (UIButton *view in self.reuseViews) {
            [self addSubview:view];
        }
        [self.reuseViews removeAllObjects];
        [self.moreView removeFromSuperview];
        [self addSubview:self.moreView];
        [self layoutSubviewsWithSize:self.bounds.size shouldLayout:YES];
    }
    
    //回调通知主视图刷新UI布局
    if(self.delegate && [self.delegate respondsToSelector:@selector(floatLayoutViewFrameDidChangedIsShowAll:)]) {
        [self.delegate floatLayoutViewFrameDidChangedIsShowAll:showAll];
    }
}


- (HDFloatLayoutViewLayoutGinseng)layoutSubviewsWithSize:(CGSize)size shouldLayout:(BOOL)shouldLayout {
    NSArray<UIView *> *visibleItemViews = [self visibleSubviews];
    
    // 出参
    HDFloatLayoutViewLayoutGinseng layoutGinseng = {.size = CGSizeZero, .fowardingTotalRowCount = 0};
    
    if (visibleItemViews.count == 0) {
        layoutGinseng.size = CGSizeMake(UIEdgeInsetsGetHorizontalValue(self.padding), UIEdgeInsetsGetVerticalValue(self.padding));
        return layoutGinseng;
    }
    
    // 如果是左对齐，则代表 item 左上角的坐标，如果是右对齐，则代表 item 右上角的坐标
    CGPoint itemViewOrigin = CGPointMake(ValueSwitchAlignLeftOrRight(self.padding.left, size.width - self.padding.right), self.padding.top);
    CGFloat currentRowMaxY = itemViewOrigin.y;
    CGSize maximumItemSize = CGSizeEqualToSize(self.maximumItemSize, HDFloatLayoutViewAutomaticalMaximumItemSize) ? CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.padding), size.height - UIEdgeInsetsGetVerticalValue(self.padding)) : self.maximumItemSize;
    
    NSUInteger currentRow = 0;
    for (NSInteger i = 0; i < visibleItemViews.count; i++) {
        UIView *itemView = visibleItemViews[i];
        
        CGRect itemViewFrame = CGRectZero;
        CGSize itemViewSize = [itemView sizeThatFits:maximumItemSize];
        itemViewSize.width = MIN(maximumItemSize.width, MAX(self.minimumItemSize.width, itemViewSize.width));
        itemViewSize.height = MIN(maximumItemSize.height, MAX(self.minimumItemSize.height, itemViewSize.height));
        
        BOOL shouldBreakline = i == 0 ? YES : ValueSwitchAlignLeftOrRight(itemViewOrigin.x + self.itemMargins.left + itemViewSize.width + self.padding.right > size.width, itemViewOrigin.x - self.itemMargins.right - itemViewSize.width - self.padding.left < 0);
        if (shouldBreakline) {
            currentRow++;
            if (self.realMaxRowCount <= 0 || currentRow <= self.realMaxRowCount) {
                currentRowMaxY += (currentRow > 1 ? self.itemMargins.top : 0);
            }
            // 换行，每一行第一个 item 是不考虑 itemMargins 的
            itemViewFrame = CGRectMake(ValueSwitchAlignLeftOrRight(self.padding.left, size.width - self.padding.right - itemViewSize.width), currentRowMaxY, itemViewSize.width, itemViewSize.height);
            itemViewOrigin.y = CGRectGetMinY(itemViewFrame);
        } else {
            // 当前行放得下
            itemViewFrame = CGRectMake(ValueSwitchAlignLeftOrRight(itemViewOrigin.x + self.itemMargins.left, itemViewOrigin.x - self.itemMargins.right - itemViewSize.width), itemViewOrigin.y, itemViewSize.width, itemViewSize.height);
        }
        
        itemViewOrigin.x = ValueSwitchAlignLeftOrRight(CGRectGetMaxX(itemViewFrame) + self.itemMargins.right, CGRectGetMinX(itemViewFrame) - self.itemMargins.left);
        if (self.realMaxRowCount <= 0 || currentRow <= self.realMaxRowCount) {
            currentRowMaxY = MAX(currentRowMaxY, CGRectGetMaxY(itemViewFrame) + self.itemMargins.bottom);
        }
        
        if (shouldLayout) {
            itemView.frame = itemViewFrame;
            
            if (itemView.tag == 99) { //有展开按钮时，处理布局
                //找到上一个子控件
                CGRect beforeItemViewFrame = [visibleItemViews[i-1] frame];
                //判断子控件的位置做对应处理
                if(beforeItemViewFrame.origin.y == itemViewFrame.origin.y || !shouldBreakline) {
                    CGFloat y = CGRectGetMidY(beforeItemViewFrame)  -  CGRectGetHeight(itemViewFrame) / 2;
                    itemViewFrame.origin.y = y;
                    itemView.frame = itemViewFrame;
                }
            }
            
            if (self.realMaxRowCount > 0) {
                if (currentRow > self.realMaxRowCount ) {
                    [itemView removeFromSuperview];
                    if(itemView.tag != 99) {
                        [self.reuseViews addObject:itemView];
                    }
                    continue;
                }
            }
        }
    }
    
    // 最后一行不需要考虑 itemMarins.bottom，所以这里减掉
    currentRowMaxY -= self.itemMargins.bottom;
    
    CGSize resultSize = CGSizeMake(size.width, currentRowMaxY + self.padding.bottom);
    // 最后一个的行数就是最大行数
    layoutGinseng.fowardingTotalRowCount = currentRow;
    layoutGinseng.size = resultSize;
    return layoutGinseng;
}

- (NSUInteger)fowardingTotalRowCountWithMaxSize:(CGSize)maxSize {
    HDFloatLayoutViewLayoutGinseng layoutGinseng = [self layoutSubviewsWithSize:maxSize shouldLayout:false];
    return layoutGinseng.fowardingTotalRowCount;
}

- (NSArray<UIView *> *)visibleSubviews {
    NSMutableArray<UIView *> *visibleItemViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0, l = self.subviews.count; i < l; i++) {
        UIView *itemView = self.subviews[i];
        if (!itemView.hidden) {
            [visibleItemViews addObject:itemView];
        }
    }
    //处理先设置了展开按钮的情况，把展开按钮放最后
    if(self.moreView && [visibleItemViews containsObject:self.moreView] && visibleItemViews.firstObject == self.moreView) {
        [self.moreView removeFromSuperview];
        [self addSubview:self.moreView];
        
        [visibleItemViews removeObject:self.moreView];
        [visibleItemViews addObject:self.moreView];
        
    }
    
    return visibleItemViews;
}

- (BOOL)shouldAlignRight {
    return self.contentMode == UIViewContentModeRight;
}

//设置自定义按钮，高度不能高于子控件
- (void)setCustomMoreView:(UIButton *)moreView {
    if(!moreView) {
        return;
    }
    
    if(self.moreView){
        [self.moreView removeFromSuperview];
        self.moreView = nil;
    }
    
    
    if(![moreView isKindOfClass:UIButton.class]) return;
    self.moreView = moreView;
    self.moreView.tag = 99;
    self.moreView.selected = self.defaultShowAll;
    if(self.moreView.selected) {
        _realMaxRowCount = 0;
        [self.reuseViews removeAllObjects];
    }else{
        _realMaxRowCount = self.maxRowCount;
    }
    [self addSubview:self.moreView];
    [self.moreView addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


///按钮事件
- (void)moreBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if(btn.selected) {
        _realMaxRowCount = 0;
    }else{
        _realMaxRowCount = self.maxRowCount;
    }
    [self layoutSubviews];
}

/// 最后一个子控件是否为展开按钮
- (BOOL)isLastViewIsMoreView {
    NSArray *arr = [self visibleSubviews];
    return arr.lastObject == self.moreView;
}

//获取最后一个子控件
- (UIView *)getLastVisibleSubview {
    NSArray *arr = [self visibleSubviews];
    return arr.lastObject;
}

- (void)setMaxRowCount:(NSUInteger)maxRowCount {
    _maxRowCount = maxRowCount;
    _realMaxRowCount = maxRowCount;
}

- (NSMutableArray *)reuseViews {
    if(!_reuseViews) {
        _reuseViews = NSMutableArray.new;
    }
    return _reuseViews;
}

@end
