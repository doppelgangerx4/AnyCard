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

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [textView setText:@""];
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
    
    [self updateUI];
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
    [self.outputTextView setText:@""];
    [self updateUI];
}

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender
{
    [self setCurrentDocIndex:[sender selectedSegmentIndex]];
    [self.outputTextView setText:@""];
    [self updateUI];
}

- (IBAction)saveButtonTapped:(UIButton *)sender
{
    [self saveFile];
}

- (IBAction)loadButtonTapped:(UIButton *)sender
{
    [self loadFile];
}

- (void) updateUI
{
    NSString* currentInputText = self.inputStrings[self.currentDocIndex];
    [self.inputTextView setText:currentInputText];
    
    m_linesCount = [[currentInputText componentsSeparatedByString:@"\n"] count];
    [self.lineCountLabel setText:[NSString stringWithFormat:@"%lu",m_linesCount]];
}

- (BOOL) saveFile
{
    NSFileManager* fileMan = [NSFileManager defaultManager];
    NSError* error = nil;
    NSURL* docDirectoryURL = [fileMan URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    if (error)
    {
        NSLog(@"Error accessing document directory: %@",error);
        error = nil;
        return NO;
    }
    
    NSString* saveFilename = [NSString stringWithFormat:@"%lu.txt",self.currentDocIndex];
    NSURL* saveFileURL = [NSURL URLWithString:saveFilename relativeToURL:docDirectoryURL];
    
    NSString* outputStr = self.inputStrings[self.currentDocIndex];
    
    [outputStr writeToURL:saveFileURL atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        NSLog(@"Error writing to file %@: %@", saveFileURL, error);
        error = nil;
        return NO;
    }
    return YES;
}

- (BOOL) loadFile
{
    NSFileManager* fileMan = [NSFileManager defaultManager];
    NSError* error = nil;
    NSURL* docDirectoryURL = [fileMan URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    if (error)
    {
        NSLog(@"Error accessing document directory: %@",error);
        error = nil;
        return NO;
    }
    
    NSString* saveFilename = [NSString stringWithFormat:@"%lu.txt",self.currentDocIndex];
    NSURL* saveFileURL = [NSURL URLWithString:saveFilename relativeToURL:docDirectoryURL];

    NSString* str = [NSString stringWithContentsOfURL:saveFileURL encoding:NSUTF8StringEncoding error:&error];
    if (error)
    {
        NSLog(@"Error reading from file %@: %@", saveFileURL, error);
        error = nil;
        return NO;
    }
    
    if (str)
    {
        self.inputStrings[self.currentDocIndex] = str;
        [self.inputTextView setText:str];
    }
    else
    {
        NSLog(@"Error: Contents of file %@ empty.",saveFileURL);
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
