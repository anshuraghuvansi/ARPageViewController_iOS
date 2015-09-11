//
//  ARPageViewControllerViewController.m
//  ARPageViewController
//
//  Created by Anshu Kumar on 10/09/15.
//  Copyright (c) 2015 Anshu Kumar. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ARPageViewControllerViewController.h"

@interface ARPageViewControllerViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>
{
    NSInteger selectedIndex;
    BOOL isGestureTransition;
    float scrollViewContentOffsetX;
}
@property(nonatomic,strong) UIPageViewController *pageViewController;
@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) UIColor *colorForNormalState;
@property(nonatomic,strong) UIColor *colorForSelectedState;

@end

@implementation ARPageViewControllerViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if(self){
        self.viewControllers = viewControllers;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if(self.viewControllers){
        [self assignDefaultValues];
        [self addControlls];
        [self addConstraintForControls];
        [self addIndexButtonsToScrollView];
    }
}

- (void)assignDefaultValues
{
    if(!self.colorForNormalState)
        self.colorForNormalState = [UIColor whiteColor];
    
    if(!self.colorForSelectedState)
        self.colorForSelectedState = [UIColor whiteColor];
    
    if(!self.indexBarColor)
        self.indexBarColor = [UIColor whiteColor];
    
    if(!self.indexBarButtonTitleFont)
        self.indexBarButtonTitleFont = [UIFont systemFontOfSize:17];
    
    selectedIndex = 0;
    scrollViewContentOffsetX = - CGRectGetWidth(self.view.frame)/3;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)addControlls
{
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = self.indexBarColor;
    [self.view addSubview:_scrollView];
    
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageViewController setViewControllers:@[[self.viewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [(UIScrollView*)[_pageViewController.view.subviews firstObject] setDelegate:self];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [_pageViewController.view didMoveToSuperview];
}

- (void)addConstraintForControls
{
    float offsetY = 0;
    if(self.navigationController != nil)
        offsetY = 44;
        
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:20+offsetY]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:60+offsetY]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)addIndexButtonsToScrollView
{
    float indexButtonWidth = CGRectGetWidth(self.view.frame)/3;
    float buttonHeight = 0;
    
    for (NSLayoutConstraint *constraint in [_scrollView constraints]) {
        if(constraint.firstAttribute == NSLayoutAttributeHeight){
            buttonHeight = constraint.constant;
            break;
        }
    }
    
    for (UIViewController* vc in _viewControllers){
        NSUInteger currentVCIndex = [_viewControllers indexOfObject:vc];
        UIButton *indexButton = [[UIButton alloc] initWithFrame:CGRectMake(indexButtonWidth*currentVCIndex, 0, indexButtonWidth, buttonHeight)];
        [indexButton setTitle:vc.title forState:UIControlStateNormal];
        [indexButton setTitleColor:self.colorForNormalState forState:UIControlStateNormal];
        [indexButton setTitleColor:self.colorForSelectedState forState:UIControlStateSelected];
        [indexButton.titleLabel setFont:self.indexBarButtonTitleFont];
        indexButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [indexButton setTag:currentVCIndex];
        [indexButton addTarget:self action:@selector(indexButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:indexButton];
    }
    [[self.scrollView.subviews firstObject] setSelected:YES];
}

- (void)setIndexButtonTitleColor:(UIColor *)color forState:(ARIndexButtonState)state
{
    if(state == ARIndexButtonStateNormal && color != nil)
        self.colorForNormalState = color;
    else if(state == ARIndexButtonSelected && color != nil)
        self.colorForSelectedState = color;
}

- (void)indexButtonTapped:(UIButton*)sender
{
    [_scrollView setContentOffset:CGPointMake(scrollViewContentOffsetX + (-scrollViewContentOffsetX * sender.tag), 0) animated:YES];
    
    [[_scrollView.subviews objectAtIndex:selectedIndex] setSelected:NO];
    
    if (selectedIndex < sender.tag) {
        [_pageViewController setViewControllers:@[[_viewControllers objectAtIndex:selectedIndex+1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    } else if (selectedIndex > sender.tag){
        [_pageViewController setViewControllers:@[[_viewControllers objectAtIndex:selectedIndex-1]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    
    selectedIndex = sender.tag;
    
    [sender setSelected:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    UIButton *button = [_scrollView.subviews objectAtIndex:selectedIndex];
    [_scrollView setContentOffset:CGPointMake(scrollViewContentOffsetX + (-scrollViewContentOffsetX * button.tag), 0)];
}


#pragma mark -  UIPageViewControllerDatasource

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [_viewControllers indexOfObject:viewController];
    
    if (index == 0) {
        return nil;
    } else{
        return (UIViewController*)[_viewControllers objectAtIndex:index-1];
    }
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [_viewControllers indexOfObject:viewController];
    
    if (index == _viewControllers.count-1) {
        return nil;
    } else{
        return (UIViewController*)[_viewControllers objectAtIndex:index+1];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        [self indexButtonTapped:(UIButton*)[_scrollView.subviews objectAtIndex:[_viewControllers indexOfObject:[[pageViewController viewControllers] firstObject]]]];
    }
    isGestureTransition = NO;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
    isGestureTransition = YES;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isGestureTransition)
    {
        if (scrollView.contentOffset.x != CGRectGetWidth(self.view.frame)) {
            float newWidth = scrollViewContentOffsetX + (((CGRectGetWidth(_scrollView.frame)* selectedIndex) + (scrollView.contentOffset.x - CGRectGetWidth(self.view.frame)))/3);
            [_scrollView setContentOffset:CGPointMake(newWidth, 0)];
        }
    }
}

//Support only Portrait
#pragma mark - InterfaceOrientations
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end


@implementation UINavigationController(InterfaceOrientations)

-(BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end

