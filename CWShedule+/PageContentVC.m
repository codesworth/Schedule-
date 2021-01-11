//
//  PageContentVC.m
//  CWShedule+
//
//  Created by Mensah Shadrach on 1/1/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "PageContentVC.h"

@interface PageContentVC ()

@end

@implementation PageContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.backgroundView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.backgroundView setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
