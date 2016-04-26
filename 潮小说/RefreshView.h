//
//  RefreshView.h
//  scrollView
//
//  Created by di xing on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshView : UIView<UIScrollViewDelegate>
{
    bool isShouldLoad;
}
@property(nonatomic,retain) IBOutlet UILabel *myLable;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *myIndicator;
@property(nonatomic,retain) IBOutlet UIImageView *myArrowImage;

-(void)isScrollViewStartDragging:(UIScrollView *)scrollView;
-(void)isScrollViewDragging:(UIScrollView *)scrollView;
-(void)isScrollViewEndDragging:(UIScrollView *)scrollView;
-(void)loading:(UIScrollView *)scrollView
;
-(void)stopLoading:(UIScrollView *)scrollView
;
@end
