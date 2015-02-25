//
//  ViewController.m
//  Calculator
//
//  Created by MFS on 1/30/15.
//  Copyright (c) 2015 MFS. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation ViewController

@synthesize brain = _brain;

bool digitIsLastButtonPressed = NO;
bool radixAssigned = NO;
bool signChange = NO;
bool isEnter = NO;

- (CalculatorBrain *)brain
{
    if (!_brain)
    {
        _brain = [[CalculatorBrain alloc] init];
    }
    
    return _brain;
}


- (IBAction)digitPressed:(UIButton *)sender
{
    digitIsLastButtonPressed = YES;
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber && ![self.display.text isEqual: @"0"])
    {
        self.display.text =  [self.display.text stringByAppendingString:digit];
    }
    else
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed
{
    //if(![self.display.text isEqual: @"0"])
    {
        [self.brain pushOperand:[self.display.text doubleValue]];
    
        // Include text in programDisplay
        if ([self.programDisplay.text isEqualToString:@""] && isEnter)
        {
            self.programDisplay.text = @"0";
        }
        self.programDisplay.text = [self.programDisplay.text stringByAppendingString:
                                [NSString stringWithFormat:@" %@", self.display.text]];
    
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
    radixAssigned = NO;
    digitIsLastButtonPressed = NO;
}

- (IBAction)operationPressed:(id)sender
{
    if ((self.userIsInTheMiddleOfEnteringANumber && ![[sender currentTitle] isEqualToString:@"+/-"]))
    {
        if (![[sender currentTitle] isEqualToString:@"Enter"])
        {
            isEnter = YES;
        }
        
        [self enterPressed];
        isEnter = NO;
    }
    else if ([[sender currentTitle] isEqualToString:@"+/-"] && ![self.display.text isEqualToString:@"0"])
    {
        signChange = YES;
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    NSString *isItZero = self.programDisplay.text;
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    // Include text in programDisplay
    if (![[sender currentTitle] isEqualToString:@"+/-"])
    {
        // As long as the label is not th '+/-' label, display the label with the result and includ '='
        if ([isItZero isEqualToString:@""]
             && ([[sender currentTitle] isEqualToString:@"cos"]
             || [[sender currentTitle] isEqualToString:@"sin"]
             || [[sender currentTitle] isEqualToString:@"sqrt"]))
        {
            self.programDisplay.text = [self.programDisplay.text stringByAppendingString:
                                    [NSString stringWithFormat:@" 0 %@ = %g", [sender currentTitle], result]];
        }
        
        else
        {
            //NSLog(@"%@",isItZero);
            if (isnan(result))
            {
                self.display.text = [NSString stringWithFormat:@"error: illegal operation"];
            }
            else
                self.programDisplay.text = [self.programDisplay.text stringByAppendingString:
                                            [NSString stringWithFormat:@" %@ = %g", [sender currentTitle], result]];
        }
    }
    
    else if(result != 0)
    {
        if([[sender currentTitle] isEqualToString:@"+/-"])
        {
            self.display.text = [NSString stringWithFormat:@" %g", result];
            digitIsLastButtonPressed = YES;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    
        else
        {
            self.programDisplay.text = [self.programDisplay.text stringByAppendingString:
                                        [NSString stringWithFormat:@" %g", result]];
        }
    }
    
    
    
    if (![[sender currentTitle] isEqualToString:@"+/-"])
    {
        self.userIsInTheMiddleOfEnteringANumber = NO;
        digitIsLastButtonPressed = NO;
    }
}

- (IBAction)radixPressed
{
    if([self.display.text isEqualToString:@"0"])
        self.userIsInTheMiddleOfEnteringANumber = YES;
    
    if (radixAssigned == NO)
    {
        if(digitIsLastButtonPressed == YES)
        {
            self.display.text =  [self.display.text stringByAppendingString:@"."];
        }
        else
        {
            self.display.text = [NSString stringWithFormat:@"0."];
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
    
    radixAssigned = YES;
}

- (IBAction)clearPressed
{
    radixAssigned = NO;
    digitIsLastButtonPressed = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.brain = nil;
    self.display.text = [NSString stringWithFormat:@"0"];
    self.programDisplay.text = [NSString stringWithFormat:@""];
}

- (IBAction)deletePressed
{
    if (![self.display.text isEqual:@"0"])
    {
        self.display.text = [self.display.text substringToIndex:
                             self.display.text.length-(self.display.text.length>0)];
        
        if (![self.display.text containsString:@"."])
        {
            radixAssigned = NO;
        }
        
        if (self.display.text.length == 0)
            self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

@end
