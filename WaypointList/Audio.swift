//
//  Audio.swift
//  AVAudio
//
//  Created by Max Krog on 2016-02-17.
//  Copyright © 2016 Max Krog. All rights reserved.
//
import CoreLocation
import AVFoundation
class Audio: NSObject{
    
    //MARK: Singleton
    static let singleton = Audio()
    
    //MARK: Soundorientation-values
    var yaw: Float = 0
    var pitch: Float = 0
    var roll: Float = 0
    
    var distance: Float = 0
    
    //MARK: Audio
    var engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    var envNode = AVAudioEnvironmentNode()
    var EQNode = AVAudioUnitEQ(numberOfBands: 1)

    
    var yaayPlayer = AVAudioPlayerNode()

    override init(){
        
        EQNode = AVAudioUnitEQ(numberOfBands: 2)
        EQNode.globalGain = 1
        engine.attachNode(EQNode)
        let filterParams: AVAudioUnitEQFilterParameters = EQNode.bands.first! as AVAudioUnitEQFilterParameters
        filterParams.filterType = .LowPass
        filterParams.frequency = 2000
        filterParams.bypass = false
        EQNode.bypass = true
        
        
        
        player.renderingAlgorithm = AVAudio3DMixingRenderingAlgorithm.HRTF
        //player.occlusion = -10.0
        //player.obstruction = -10.0
        
        //envNode.reverbParameters.enable = true
        //envNode.reverbParameters.loadFactoryReverbPreset(.MediumRoom)
        
        //player.reverbBlend = 0.9
        
        envNode.distanceAttenuationParameters.distanceAttenuationModel = AVAudioEnvironmentDistanceAttenuationModel.Inverse
        envNode.distanceAttenuationParameters.maximumDistance = 300
        envNode.distanceAttenuationParameters.referenceDistance = 10
        
        envNode.listenerPosition = AVAudioMake3DPoint(0, 0, 0)
        envNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: yaw, pitch: pitch , roll: roll)
        
        super.init()
    
        // MARK: Audio connect nodes
        engine.attachNode(player)
        engine.attachNode(envNode)
        engine.attachNode(yaayPlayer)
        //MARK: Load audio-file.
        
        let fileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("aos", ofType: "wav")!)
        let audioFile = try! AVAudioFile(forReading: fileURL)
        let audioFormat = audioFile.processingFormat
        let audioFrameCount = UInt32(audioFile.length)
        let audioFileBuffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: audioFrameCount)
        try! audioFile.readIntoBuffer(audioFileBuffer)

        
        engine.connect(player, to: EQNode, format: audioFormat )
        engine.connect(envNode, to: engine.mainMixerNode , format: nil)
        engine.connect(EQNode, to:envNode, format: audioFormat)
        engine.connect(yaayPlayer, to: engine.mainMixerNode, format: nil)
        
        //MARK: Start engine
        try! engine.start()
        
        //MARK: Play sounds
        
        player.scheduleBuffer(audioFileBuffer, atTime: nil, options: .Loops, completionHandler: nil)
        
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func yaay() {
        print("Yaay! User reached a waypoint!")
        let yaayFileURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("yaay", ofType: "wav")!)
        let yaayAudioFile = try! AVAudioFile(forReading: yaayFileURL)
        
        yaayPlayer.scheduleFile(yaayAudioFile, atTime: nil, completionHandler: nil)
        yaayPlayer.play()
    }
    
    //MARK: Delegate
    func updateDistance (newDistance: Float) {
        distance = newDistance
        player.position = AVAudioMake3DPoint(0, 5, -distance)

    }
    
    func updateObstruction(newObstruction: Float) {
        player.occlusion = newObstruction
    }
    
    func updateRelativeBearing(newRelativeBearing: Double) {
        yaw = Float(newRelativeBearing)
        print(yaw)
        envNode.listenerAngularOrientation = AVAudio3DAngularOrientation(yaw: yaw, pitch: pitch , roll: roll)
        
    }
    
}