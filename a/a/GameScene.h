//
//  GameScene.h
//  a
//
//  Created by Stefan on 3/27/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameScene : SKScene

@property (nonatomic) NSMutableArray<GKEntity *> *entities;
@property (nonatomic) NSMutableDictionary<NSString*, GKGraph *> *graphs;

@end
