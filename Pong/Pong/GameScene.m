//
//  GameScene.m
//  Pong
//
//  Created by Stefan on 2/25/17.
//  Copyright © 2017 Stefan. All rights reserved.
//


// skoro ceo template kod sam iskomentarisao da bi mogao da napravim svoju igru

#import "GameScene.h"

@interface GameScene()

@property (strong, nonatomic) UITouch *leftPaddleMotivatingTouch;
@property (strong, nonatomic) UITouch *rightPaddleMotivatingTouch;

@end

@implementation GameScene {
    NSTimeInterval _lastUpdateTime;
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
}

static const CGFloat kTrackPixelsPerSecond = 1000;


- (void)sceneDidLoad {
    // Setup your scene here
    
    // Initialize update time
    _lastUpdateTime = 0;
    
//    // Get label node from scene and store it for use later
//    _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
//    
//    _label.alpha = 0.0;
//    [_label runAction:[SKAction fadeInWithDuration:2.0]];
//    
//    CGFloat w = (self.size.width + self.size.height) * 0.05;
//    
//    // Create shape node to use during mouse interaction
//    _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
//    _spinnyNode.lineWidth = 2.5;
//    
//    [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
//    [_spinnyNode runAction:[SKAction sequence:@[
//                                                [SKAction waitForDuration:0.5],
//                                                [SKAction fadeOutWithDuration:0.5],
//                                                [SKAction removeFromParent],
//                                                ]]];
    
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    SKNode *ball = [self childNodeWithName:@"ball"];
    ball.physicsBody.angularVelocity = 1.0;
   
}

- (void)touchDownAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor greenColor];
//    [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor blueColor];
//    [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
//    SKShapeNode *n = [_spinnyNode copy];
//    n.position = pos;
//    n.strokeColor = [SKColor redColor];
//    [self addChild:n];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
    //[_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    //for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
    for(UITouch *touch in touches){
        CGPoint location = [touch locationInNode:self];
        
        NSLog(@"\n%f %f %f %f", location.x, location.y, self.frame.size.width, self.frame.size.height);
        
        // ako nam je dodir u levoj trecini ekrana to ce biti left touch
        if(location.x < self.frame.size.width * 0.3){
            self.leftPaddleMotivatingTouch = touch;
            NSLog(@"left");
        } else if(location.x > self.frame.size.width * 0.3){
            self.rightPaddleMotivatingTouch = touch;
            NSLog(@"right");
        } else {
            SKNode *ball = [self childNodeWithName:@"ball"];
            ball.physicsBody.velocity = CGVectorMake(ball.physicsBody.velocity.dx * 2.0, ball.physicsBody.velocity.dy);
        }
    }
    
    [self trackPaddlesToMotivatingTouches];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
    [self trackPaddlesToMotivatingTouches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
    if([touches containsObject:self.leftPaddleMotivatingTouch])
        self.leftPaddleMotivatingTouch = nil;
    
    if([touches containsObject:self.rightPaddleMotivatingTouch])
        self.rightPaddleMotivatingTouch = nil;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
    if([touches containsObject:self.leftPaddleMotivatingTouch])
        self.leftPaddleMotivatingTouch = nil;
    
    if([touches containsObject:self.rightPaddleMotivatingTouch])
        self.rightPaddleMotivatingTouch = nil;
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    
    // Initialize _lastUpdateTime if it has not already been
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = currentTime;
    }
    
    // Calculate time since last update
    CGFloat dt = currentTime - _lastUpdateTime;
    
    // Update entities
    for (GKEntity *entity in self.entities) {
        [entity updateWithDeltaTime:dt];
    }
    
    _lastUpdateTime = currentTime;
}

// funkcija za pomeranje palica u odnosu na nas dodir
- (void) trackPaddlesToMotivatingTouches{
    // niz, svaki clan niza je dictionary, key je node ili touch
    // za touch je ili touch ili null
    id a = @[@{@"node": [self childNodeWithName:@"left_paddle"],
               @"touch": self.leftPaddleMotivatingTouch ?: [NSNull null]},
             @{@"node": [self childNodeWithName:@"right_paddle"],
               @"touch": self.rightPaddleMotivatingTouch ?: [NSNull null]}];
    
    for(NSDictionary *o in a){
        SKNode *node = o[@"node"];
        UITouch *touch = o[@"touch"];
        if([[NSNull null] isEqual:touch])
            continue;
        
        CGFloat yPos = [touch locationInNode:self].y;
        NSTimeInterval duration = ABS(yPos - node.position.y) / kTrackPixelsPerSecond;
        
        SKAction *moveAction = [SKAction moveToY:yPos duration:duration];
        [node runAction:moveAction withKey:@"moving"];
    }
    
}


@end









