//
//  ViewController.m
//  JSJSONParserDemo
//
//  Created by jignesh agola on 12/11/14.
//  Copyright (c) 2014 jignesh agola. All rights reserved.
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



#import "ViewController.h"
#import "JSJsonParser.h"
#import "User.h"

@interface ViewController ()
{
    NSMutableArray *userArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeDemoData];
    //Make Object of json parser
    JSJsonParser *js = [[JSJsonParser alloc] init];
    
    NSMutableArray *userObjectArray =  [js getArrayparseJson:userArray andClassName:[User class]];
    
    NSLog(@"User Object %@",userObjectArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)makeDemoData{
    
    NSMutableDictionary *officeDict = [[NSMutableDictionary alloc] init];
    [officeDict setObject:@"viva" forKey:@"officeName"];
    [officeDict setObject:@123 forKey:@"officeId"];
    
    NSMutableDictionary *officeDict1 = [[NSMutableDictionary alloc] init];
    [officeDict1 setObject:@"done" forKey:@"officeName"];
    [officeDict1 setObject:@456 forKey:@"officeId"];
    
    NSArray *officeAddress = [[NSArray alloc]initWithObjects:officeDict,officeDict1, nil];
    
    NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
    [addressDict setObject:@"Jignesh" forKey:@"firstname"];
    [addressDict setObject:@"Agola" forKey:@"secondname"];
    [addressDict setObject:officeAddress forKey:@"OfficeAddress"];
    
    NSMutableDictionary *addressDict1 = [[NSMutableDictionary alloc] init];
    [addressDict1 setObject:@"Jignesh1" forKey:@"firstname"];
    [addressDict1 setObject:@"Agola1" forKey:@"secondname"];
    [addressDict1 setObject:officeAddress forKey:@"OfficeAddress"];
    
    
    NSDictionary *dataDictc = [NSDictionary dictionaryWithObjectsAndKeys:@"Jignesh",@"name",addressDict1,@"address",nil];
    
    userArray = [[NSMutableArray alloc] initWithObjects:dataDictc,dataDictc,dataDictc,dataDictc,dataDictc,nil];
    
    
}
@end
