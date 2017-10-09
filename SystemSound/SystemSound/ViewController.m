//
//  ViewController.m
//  SystemSound
//
//  Created by Stefan on 2/20/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (assign, nonatomic) SystemSoundID beepA;
@property (assign, nonatomic) SystemSoundID beepB;
@property (assign, nonatomic) SystemSoundID beepC;
@property (strong, nonatomic) AVAudioPlayer *soundD;
@property (strong, nonatomic) AVAudioPlayer *player;

@property (assign, nonatomic) BOOL beepAGood;
@property (assign, nonatomic) BOOL beepBGood;
@property (assign, nonatomic) BOOL beepCGood;
@property (assign, nonatomic) BOOL beepDGood;
@property (assign, nonatomic) BOOL songGood;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the sound / create the sound ID
    NSString *soundAPath = [[NSBundle mainBundle] pathForResource:@"soundA" ofType:@"aiff"];
    NSURL *urlA = [NSURL fileURLWithPath:soundAPath];

    NSString *soundBPath = [[NSBundle mainBundle] pathForResource:@"sound3" ofType:@"wav"];
    NSURL *urlB = [NSURL fileURLWithPath:soundBPath];
    
    NSString *soundCPath = [[NSBundle mainBundle] pathForResource:@"sound5" ofType:@"wav"];
    NSURL *urlC = [NSURL fileURLWithPath:soundCPath];

    NSString *soundDPath = [[NSBundle mainBundle] pathForResource:@"sound4" ofType:@"mp3"];
    NSURL *urlD = [NSURL fileURLWithPath:soundDPath];
    
    NSString *songPath = [[NSBundle mainBundle] pathForResource:@"Calvin Harris &amp; David Guetta - Glows" ofType:@"mp3"];
    NSURL *urlSong = [NSURL fileURLWithPath:songPath];

    
    // c code
    // __bridge = C-level cast
    // tells ARC to stop taking notice of casted object
    // casting -> don`t generate ARC meta data
    // ovo bridge govori ARC-u da ga ne prati
    
    
    // beepA
    OSStatus statusReportA = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlA, &_beepA);
    
    if(statusReportA == kAudioServicesNoError)
        self.beepAGood = YES;
    else{
        self.beepAGood = NO;
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn`t load beepA" message:@"BeepA problem" preferredStyle:    UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    // beepB
    OSStatus statusReportB = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlB, &_beepB);
    
    if(statusReportB == kAudioServicesNoError)
        self.beepBGood = YES;
    else{
        self.beepBGood = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn`t load beepB" message:@"BeepB problem" preferredStyle:    UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    // beepC
    OSStatus statusReportC = AudioServicesCreateSystemSoundID((__bridge CFURLRef)urlC, &_beepC);
    
    if(statusReportC == kAudioServicesNoError)
        self.beepCGood = YES;
    else{
        self.beepCGood = NO;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn`t load beepC" message:@"BeepC problem" preferredStyle:    UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    NSError *err;
    
    // set up AVAudioPlayer, moze da pusta mp3 za razliku od system sound
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlSong error:&err];
    
    if(!self.player){
        self.songGood = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn`t load mp3" message:[err localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
        self.songGood = YES;
    
    self.soundD = [[AVAudioPlayer alloc] initWithContentsOfURL:urlD error:&err];
    
    if(!self.soundD){
        self.beepDGood = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn`t load mp3" message:[err localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
        self.beepDGood = YES;
}

- (IBAction)playSoundA:(id)sender {
    if(self.beepAGood)
        AudioServicesPlaySystemSound(_beepA);
}

- (IBAction)playSoundB:(id)sender {
    if(self.beepBGood)
        AudioServicesPlaySystemSound(_beepB);
}

- (IBAction)playSoundC:(id)sender {
    if(self.beepCGood)
        AudioServicesPlaySystemSound(_beepC);
}

- (IBAction)playSoundD:(id)sender {
    if(self.soundD)
        [self.soundD play];
}

- (IBAction)playASong:(id)sender {
    if(self.songGood){
        [self.player play];
    }
}

- (IBAction)stopASong:(id)sender {
    if(self.songGood){
        [self.player stop];
    }
}

- (void) dealloc{
    if(self.beepAGood)
        AudioServicesDisposeSystemSoundID(self.beepA);
    if(self.beepBGood)
        AudioServicesDisposeSystemSoundID(self.beepB);
    if(self.beepCGood)
        AudioServicesDisposeSystemSoundID(self.beepC);
}

@end
















