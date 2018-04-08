//
//  ViewController.m
//  KeyboardAvoid
//
//  Created by Mac on 2018/4/4.
//  Copyright © 2018年 saint. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UITextField * txtField;

@property (nonatomic, strong) UIToolbar * toorbar;

@end

@implementation ViewController

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(UITextField *)txtField {
    if (!_txtField) {
        _txtField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        
    }
    return _txtField;
}

-(UIToolbar *)toorbar {
    if (!_toorbar) {
        _toorbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onClickDone)];
        
        _toorbar.items = @[spaceItem,doneItem];
    }
    
    return _toorbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toorbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    UITextField * txt = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, 100, 40)];
    txt.borderStyle = UITextBorderStyleRoundedRect;
    [cell addSubview:txt];
    return cell;
}


-(void)keyboardWillShow:(NSNotification *)notif {
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray * subviews = [self.view subviews];
    
    for (UIView * sub in subviews) {
        CGFloat maxY  = CGRectGetMaxY(sub.frame);
        if ([sub isKindOfClass:[UITableView class]]) {
            sub.frame = CGRectMake(0, 0, sub.frame.size.width, [UIScreen mainScreen].bounds.size.height - rect.size.height-_toorbar.frame.size.height);
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.frame.size.height/2);
        } else {
            if (maxY > y) {
                sub.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, sub.center.y + y - maxY);
            }
        }
    }
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)notif {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];

    _toorbar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, _toorbar.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - onClick

-(void)onClickDone {
    [self.view endEditing:YES];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

