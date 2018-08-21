//
//  PageContentVC.h
//  CWShedule+
//
//  Created by Mensah Shadrach on 1/1/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;


@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
