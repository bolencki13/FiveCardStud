//
//  PokerHandChecker.m
//  FiveCardStud
//
//  Created by Brian Olencki on 12/31/15.
//  Copyright © 2015 bolencki13. All rights reserved.
//

#import "PokerHandChecker.h"

NSString *NSStringFromPokerHand(PokerHand handType) {
    NSString *type = @"HighCard";
    switch (handType) {
        case HighCard:
            type = @"HighCard";
            break;
        case OnePair:
            type = @"OnePair";
            break;
        case TwoPair:
            type = @"TwoPair";
            break;
        case ThreeOfAKind:
            type = @"ThreeOfAKind";
            break;
        case Straight:
            type = @"Straight";
            break;
        case Flush:
            type = @"Flush";
            break;
        case FullHouse:
            type = @"FullHouse";
            break;
        case FourOfAKind:
            type = @"FourOfAKind";
            break;
        case StraightFlush:
            type = @"StraightFlush";
            break;
        case RoyalFlush:
            type = @"RoyalFlush";
            break;
        default:
            break;
    }
    return type;
}

@implementation PokerHandChecker
+ (BOOL)checkWithHand:(NSArray *)hand {
    PokerHandChecker *checker = [[PokerHandChecker alloc] initWithHand:hand];
    return [checker isWinningHand];
}
+ (PokerHand)handTypeForHand:(NSArray *)hand {
    PokerHandChecker *checker = [[PokerHandChecker alloc] initWithHand:hand];
    return [checker handType];
}

- (instancetype)initWithHand:(NSArray*)hand {
    if (self == [super init]) {
        _hand = hand;
    }
    return self;
}
- (PokerHand)handType {
    NSMutableArray *aryCardNumber = [NSMutableArray new], *aryCardType = [NSMutableArray new];
    for (NSString *text in _hand) {
        NSArray *aryTemp = [text componentsSeparatedByString:@"-"];
        [aryCardType addObject:[aryTemp objectAtIndex:0]];
        
        NSInteger number = 0;
        if ([[aryTemp objectAtIndex:1] isEqualToString:@"J"]) {
            number = 11;
        } else if ([[aryTemp objectAtIndex:1] isEqualToString:@"Q"]) {
            number = 12;
        } else if ([[aryTemp objectAtIndex:1] isEqualToString:@"K"]) {
            number = 13;
        } else if ([[aryTemp objectAtIndex:1] isEqualToString:@"A"]) {
            number = 14;
        } else {
            number = (int)[[aryTemp objectAtIndex:1] integerValue];
        }
        [aryCardNumber addObject:[NSNumber numberWithUnsignedInteger:number]];
    }

    NSCountedSet *set = [NSCountedSet setWithArray:aryCardNumber];
    for (NSNumber *number in set) {
        if ([set countForObject:number] == 4) {
            return FourOfAKind;
        } else if ([set countForObject:number] == 3) {
            for (NSNumber *subNumber in set) {
                if ([set countForObject:subNumber] == 2 && number!=subNumber) {
                    return TwoPair;
                }
            }
            return ThreeOfAKind;
        } else if ([set countForObject:number] == 2) {
            for (NSNumber *subNumber in set) {
                if ([set countForObject:subNumber] == 2 && number!=subNumber) {
                    return TwoPair;
                }
            }
            for (NSNumber *subNumber in set) {
                if ([set countForObject:subNumber] == 3 && number!=subNumber) {
                    return FullHouse;
                }
            }
            return OnePair;
        }
    }
    
    NSInteger lowNumber = [self lowValueInArray:aryCardNumber];
    if ([aryCardNumber containsObject:[NSNumber numberWithInteger:lowNumber+1]] && [aryCardNumber containsObject:[NSNumber numberWithInteger:lowNumber+2]] && [aryCardNumber containsObject:[NSNumber numberWithInteger:lowNumber+3]] && [aryCardNumber containsObject:[NSNumber numberWithInteger:lowNumber+4]]) {
        
        if ([[aryCardType objectAtIndex:0] isEqualToString:[aryCardType objectAtIndex:1]] && [[aryCardType objectAtIndex:1] isEqualToString:[aryCardType objectAtIndex:2]] && [[aryCardType objectAtIndex:2] isEqualToString:[aryCardType objectAtIndex:3]] && [[aryCardType objectAtIndex:3] isEqualToString:[aryCardType objectAtIndex:4]]) {
            
            if (lowNumber == 10) {
                return RoyalFlush;
            }
            return StraightFlush;
        }
        
        return Straight;
    } else if ([[aryCardType objectAtIndex:0] isEqualToString:[aryCardType objectAtIndex:1]] && [[aryCardType objectAtIndex:1] isEqualToString:[aryCardType objectAtIndex:2]] && [[aryCardType objectAtIndex:2] isEqualToString:[aryCardType objectAtIndex:3]] && [[aryCardType objectAtIndex:3] isEqualToString:[aryCardType objectAtIndex:4]]) {
        return Flush;
    }
    
    return HighCard;
}
- (BOOL)isWinningHand {
    NSMutableArray *aryCardNumber = [NSMutableArray new], *aryCardType = [NSMutableArray new];
    for (NSString *text in _hand) {
        NSArray *aryTemp = [text componentsSeparatedByString:@"-"];
        [aryCardType addObject:[aryTemp objectAtIndex:0]];
        
        NSInteger number = 0;
        if ([[aryTemp objectAtIndex:1] isEqualToString:@"J"]) {
            number = 11;
        } else if ([[aryTemp objectAtIndex:1] isEqualToString:@"Q"]) {
            number = 12;
        } else if ([[aryTemp objectAtIndex:1] isEqualToString:@"K"]) {
            number = 13;
        } else if ([[aryTemp objectAtIndex:1] isEqualToString:@"A"]) {
            number = 14;
        } else {
            number = (int)[[aryTemp objectAtIndex:1] integerValue];
        }
        [aryCardNumber addObject:[NSNumber numberWithUnsignedInteger:number]];
    }
    
    NSCountedSet *set = [NSCountedSet setWithArray:aryCardNumber];
    for (NSNumber *number in set) {
        if ([set countForObject:number] == 2) {
            return YES;// 2,3,4 2 pair full house
        }
    }
    
    NSInteger lowNumber = [self lowValueInArray:aryCardNumber];
    if ([aryCardNumber containsObject:[NSNumber numberWithInteger:lowNumber+1]] && [aryCardNumber containsObject:[NSNumber numberWithInteger:lowNumber+2]] && [aryCardNumber containsObject:[NSNumber numberWithInteger:lowNumber+3]] && [aryCardNumber containsObject:[NSNumber numberWithInteger:lowNumber+4]]) {
        return YES;// straight
    }
    
    if ([[aryCardType objectAtIndex:0] isEqualToString:[aryCardType objectAtIndex:1]] && [[aryCardType objectAtIndex:1] isEqualToString:[aryCardType objectAtIndex:2]] && [[aryCardType objectAtIndex:2] isEqualToString:[aryCardType objectAtIndex:3]] && [[aryCardType objectAtIndex:3] isEqualToString:[aryCardType objectAtIndex:4]]) {
        return YES;//flush & royal flush & straight flush
    }
    return NO;//high card
}
- (NSInteger)lowValueInArray:(NSArray*)array {
    NSInteger lowValue = 15;
    for (NSNumber *number in array) {
        NSInteger value = [number integerValue];
        if (value < lowValue) {
            lowValue = value;
        }
    }
    return lowValue;
}
@end
