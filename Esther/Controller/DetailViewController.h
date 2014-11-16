//
//  DetailViewController.h
//  Esther
//
//  Created by Alessandro on 16/11/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

