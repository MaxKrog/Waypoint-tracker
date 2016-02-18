//
//  Audio.swift
//  AVAudio
//
//  Created by Max Krog on 2016-02-17.
//  Copyright © 2016 Max Krog. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import CoreAudio

class Audio: NSObject, MasterTrackerDelegate{
    
    //MARK: Soundorientation-values
    var yaw: Float = -180
    var pitch: Float = 0
    var roll: Float = 0
    
    var distance: Float = 0
    
    //MARK: Audio
    var engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    var envNode = AVAudioEnvironmentNode()

    override init(){
        //player.position = AVAudioMake3DPoint(0, 0, 20)
        player.renderingAlgorithm = AVAudio3DMixingRenderingAlgorithm.HRTF
        
        envNode.reverbParameters.enable = true
        envNode.reverbParameters.loadFactoryReverbPreset(.Cathedral)
        envNode.distanceAttenuationParameters.maximumDistance = 20
        envNode.renderingAlgorithm = .SphericalHead
        envNode.listenerPosition = AVAudioMake3DPoint(0, 0, 0)
        envNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: yaw, pitch: pitch , roll: roll)
        
        super.init()
        
        // MARK: Audio connect nodes
        engine.attachNode(player)
        engine.attachNode(envNode)
        
        //MARK: Load audio-file.
        
        let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("crane", ofType: "wav")!)
        let audioFile = try! AVAudioFile(forReading: fileURL)
        let audioFormat = audioFile.processingFormat
        let audioFrameCount = UInt32(audioFile.length)
        let audioFileBuffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: audioFrameCount)
        try! audioFile.readIntoBuffer(audioFileBuffer)
        
        engine.connect(player, to: envNode, format: audioFormat )
        engine.connect(envNode, to: engine.mainMixerNode , format: nil)
        
        //MARK: Start engine
        try! engine.start()
        
        //MARK: Play sounds
        
        player.scheduleBuffer(audioFileBuffer, atTime: nil, options: .Loops, completionHandler: nil)
        player.play()
        
        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "changeOrientation", userInfo: nil, repeats: true)
        
    }
    
    //MARK: Delegate
    func updateDistance (newDistance: Float) {
        distance = newDistance
        player.position = AVAudioMake3DPoint(0, 0, distance)
    }
    
    func updateRelativeBearing(newRelativeBearing: Double) {
        yaw = Float(newRelativeBearing)
        envNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: yaw, pitch: pitch , roll: roll)
        
    }
    
}