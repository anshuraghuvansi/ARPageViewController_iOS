//
//  ARMainViewController.m
//  ARPageViewController
//
//  Created by Anshu Kumar on 10/09/15.
//  Copyright (c) 2015 Anshu Kumar. All rights reserved.

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


#import "ARMainViewController.h"
#import "ARChildViewController.h"
#import "ARPageViewControllerViewController.h"

@interface ARMainViewController ()

@end

@implementation ARMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showPageViewControlClicked:(id)sender
{
    ARChildViewController *child1 = [self.storyboard instantiateViewControllerWithIdentifier:@"ARChildViewController"];
    child1.view.backgroundColor = [UIColor whiteColor];
    child1.title = @"ONE";
    
    ARChildViewController *child2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ARChildViewController"];
    child2.view.backgroundColor = [UIColor greenColor];
    child2.title = @"TWO";
    
    ARChildViewController *child3 = [self.storyboard instantiateViewControllerWithIdentifier:@"ARChildViewController"];
    child3.view.backgroundColor = [UIColor redColor];
    child3.title = @"THREE";
    
    ARChildViewController *child4 = [self.storyboard instantiateViewControllerWithIdentifier:@"ARChildViewController"];
    child4.view.backgroundColor = [UIColor yellowColor];
    child4.title = @"FOUR";
    
    ARChildViewController *child5 = [self.storyboard instantiateViewControllerWithIdentifier:@"ARChildViewController"];
    child5.view.backgroundColor = [UIColor orangeColor];
    child5.title = @"FIVE";
    
    ARPageViewControllerViewController *pageController = [[ARPageViewControllerViewController alloc] initWithViewControllers:@[child1,child2,child3,child4,child5]];
    [pageController setIndexBarColor:[UIColor colorWithRed:25.0/255.0f green:49.0/255.0f blue:80.0/255.0f alpha:1]];
    [pageController setIndexBarButtonTitleFont:[UIFont fontWithName:@"OpenSans" size:13.0]];
    [pageController setIndexButtonTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:5.0]
                                    forState:ARIndexButtonStateNormal];

    
    //When Pushing
    //[self.navigationController pushViewController:pageController animated:YES];
    
    
    //When Presenting
    [self presentViewController:pageController animated:YES completion:nil];
    
}

@end
