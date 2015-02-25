//
//  CalculatorBrain.h
//  Calculator
//
//  Created by MFS on 1/30/15.
//  Copyright (c) 2015 MFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)popOperand;
- (double)performOperation:(NSString *)operation;

@end
