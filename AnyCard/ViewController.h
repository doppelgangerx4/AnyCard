//
//  ViewController.h
//  AnyCard
//
//  Created by Kevin Chen on 3/25/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_OPEN_DOCS 3

@interface ViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>
{
    NSInteger m_linesCount;
}

- (void) updateUI;
- (BOOL) saveFile;
- (BOOL) loadFile;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;

@property (readwrite, atomic) NSMutableArray* inputStrings;
@property (readwrite, atomic) NSString* outputString;
@property (readwrite, atomic) NSInteger currentDocIndex;

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@property (weak, nonatomic) IBOutlet UILabel *lineCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (weak, nonatomic) IBOutlet UITextField *shuffleTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *documentSegments;
@property (weak, nonatomic) IBOutlet UIButton *resetDocumentButton;


@end

