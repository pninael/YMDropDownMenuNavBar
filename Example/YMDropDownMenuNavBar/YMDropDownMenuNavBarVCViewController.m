//
//  DropDownMenuNavBarVCViewController.m
//  DropDown
//
//  Created by Pnina Eliyahu on 11/3/15.
//  Copyright © 2015 Pnina Eliyahu. All rights reserved.
//

#import "YMDropDownMenuNavBarVCViewController.h"
#import "YMDropDownMenuNavBar.h"

@interface DropDownMenuNavBarVCViewController ()

@end

@implementation DropDownMenuNavBarVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize the DropDownMenuNavBar with titles and blocks
    YMDropDownMenuNavBar *dropDownMenuNavBar = [[YMDropDownMenuNavBar alloc]initWithMenuItems:
    [YMDropDownMenuItem itemWithTitle:@"first" blockAction:^
    {
        NSLog(@"moving back to fisrt");
        
        [self.navigationController popViewControllerAnimated:YES];
    }],
    [YMDropDownMenuItem itemWithTitle:@"second" blockAction:^
    {
        NSLog(@"moving to seconds");
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *secondVC = [storyBoard instantiateViewControllerWithIdentifier:@"second"];
        secondVC.navigationItem.hidesBackButton = YES;
        
        [self.navigationController pushViewController:secondVC animated:YES];
    }],
    nil];
    
    // set the selected item
    //dropDownMenuNavBar.dropDownMenu.selectedItemIndex = 1;
    
    // configure colors
    dropDownMenuNavBar.dropDownMenu.menuItemsBackgroudColor = self.view.backgroundColor;
    //dropDownMenuNavBar.dropDownMenu.selectedItemBackgroundColor = [UIColor yellowColor];
    //dropDownMenuNavBar.dropDownMenu.titlesColor = [UIColor greenColor];
    
    // replace the existing NavBar with DropDownMenuNavBar
    [self.navigationController setValue:dropDownMenuNavBar forKeyPath:@"navigationBar"];
}

@end
