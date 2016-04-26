//
//  RefreshView.m
//  scrollView
//
//  Created by di xing on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RefreshView.h"
@implementation RefreshView
@synthesize myLable;
@synthesize myIndicator;
@synthesize myArrowImage;
-(void)loading:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
 
    myArrowImage.hidden=YES;
    myIndicator.hidden=NO;
    [myIndicator startAnimating];
//rzy
    myLable.text=@"加载中...";
    scrollView.contentOffset = CGPointMake(0, 20);
    [self performSelector:@selector(stopLoading:)
               withObject:scrollView afterDelay:3]; 
    [UIView commitAnimations];
    NSLog(@"%@",myLable.text);
}
-(void)stopLoading:(UIScrollView *)scrollView
{
    isShouldLoad= NO;
    myArrowImage.hidden=NO;
    // Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    //    owner.contentInset = UIEdgeInsetsZero;
    
    scrollView.contentOffset =CGPointZero;
  
    self.myArrowImage.transform = CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
    
  
    // UI 赋值
    myLable.text = @"下拉刷新";
   
    myArrowImage.hidden = NO;
    [myIndicator stopAnimating];
    myIndicator.hidden=YES;
 NSLog(@"%F",scrollView.contentOffset.y);
    NSLog(@"%f",self.frame.origin.y);
}
-(void)isScrollViewDragging:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
    if (scrollView.contentOffset.y<-50) {
//rzy
    
        if (!isShouldLoad) {
           myLable.text= @"松开加载更多"; 
        }
        myArrowImage.transform = CGAffineTransformMakeRotation(3.14);
        isShouldLoad=YES;
       
    }else {
        myArrowImage.transform = CGAffineTransformMakeRotation(0);

    }
    [UIView commitAnimations];
}
-(void)isScrollViewStartDragging:(UIScrollView *)scrollView
{
    myLable.text = @"下拉刷新";
}
-(void)isScrollViewEndDragging:(UIScrollView *)scrollView
{
    if (isShouldLoad) {
         [self loading:scrollView];
    }
//rzy
//    myLable.text = @"下拉刷新";
    scrollView.contentOffset =CGPointMake(0, 20);
//rzy
//    isShouldLoad = NO;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        myIndicator.hidden =YES;
        isShouldLoad=NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
