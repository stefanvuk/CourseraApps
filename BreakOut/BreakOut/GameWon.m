//
//  GameWon.m
//  BreakOut
//
//  Created by Stefan on 3/27/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "GameWon.h"
#import "GameScene.h"

@implementation GameWon

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // called when a touch begins
    
    if(touches){
        SKView * skView = (SKView *) self.view;
        [self removeFromParent];
        
        // create and configure the scene
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // present the scene
        [skView presentScene:scene];
    }
}

-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

@end
