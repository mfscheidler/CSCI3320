//
//  CalculatorBrain.m
//  Calculator
//
//  Created by MFS on 1/30/15.
//  Copyright (c) 2015 MFS. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (!_operandStack)
    {
        _operandStack = [[NSMutableArray alloc] init];
    }
    
    return _operandStack;
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"])
    {
        result = [self popOperand] + [self popOperand];
    }
    else if ([@"*" isEqualToString:operation])
    {
        result = [self popOperand] * [self popOperand];
    }
    else if ([@"-" isEqualToString:operation])
    {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    }
    
    else if ([@"/" isEqualToString:operation])
    {
        double divisor = [self popOperand];
        
        if (divisor) result = [self popOperand] / divisor;
        
        // use NAN to output the illegal operation error for a divide-by-zero condition
        else result = NAN;
    }
    
    else if ([@"+/-" isEqualToString:operation])
    {
        {
            result = 0 - [self popOperand];
        }
        return result;
    }
    
    else if ([@"sin" isEqualToString:operation])
    {
        result = sin([self popOperand]);
    }
    
    else if ([@"cos" isEqualToString:operation])
    {
        result = cos([self popOperand]);
    }
    
    else if ([@"sqrt" isEqualToString:operation])
    {
        result = sqrt([self popOperand]);
    }
    
    // PI functions as an operation
    else if ([@"pi" isEqualToString:operation])
    {
        result = M_PI;
    }

    [self pushOperand:result];
    
    return result;
}

@end
