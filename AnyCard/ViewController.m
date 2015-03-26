//
//  ViewController.m
//  AnyCard
//
//  Created by Kevin Chen on 3/25/15.
//  Copyright (c) 2015 Kevin Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.inputStrings = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
    
    self.currentDocIndex = 0;
    m_linesCount = [[self.lineCountLabel text] integerValue];
}

- (void) textViewDidChange:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    assert(self.currentDocIndex < [self.inputStrings count]);
    
    NSString* str = [textView text];
    self.inputStrings[self.currentDocIndex] = str;
    
    m_linesCount = [[str componentsSeparatedByString:@"\n"] count];
    [self.lineCountLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)m_linesCount]];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSInteger intVal = [[textField text] integerValue];
    if (intVal < 1)
    {
        [textField setText:@"1"];
    }
    if ((intVal > m_linesCount) )
    {
        [textField setText:[NSString stringWithFormat:@"%lu",m_linesCount]];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)shuffleButtonTapped:(id)sender
{
    NSString* str = self.inputStrings[self.currentDocIndex];
    if ([str length] > 0)
    {
        NSString* hand = [NSString string];

        NSMutableArray* cards = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"\n"]];
        NSInteger draws = [[self.shuffleTextField text] integerValue];
        
        if (draws < 1)
        {
            NSLog(@"ERROR: Drawing an invalid number of cards.");
            return;
        }
        
        for (int i=0; i<draws; i++)
        {
            int index = arc4random_uniform((uint32_t)[cards count]);
            
            NSString* card = cards[index];
            hand = [hand stringByAppendingFormat:@"%@\n",card];
            [cards removeObjectAtIndex:index];
        }
        
        [self.outputTextView setText:hand];
    }
}

- (IBAction)resetTextViewButtonTapped:(id)sender
{
    self.inputStrings[self.currentDocIndex] = @"";
    [self.inputTextView setText:@""];
    [self.outputTextView setText:@""];
}
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender
{
    [self setCurrentDocIndex:[sender selectedSegmentIndex]];
    NSString* currentInputText = self.inputStrings[self.currentDocIndex];
    [self.inputTextView setText:currentInputText];
    [self.outputTextView setText:@""];
    
    m_linesCount = [[currentInputText componentsSeparatedByString:@"\n"] count];
    [self.lineCountLabel setText:[NSString stringWithFormat:@"%lu",m_linesCount]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
