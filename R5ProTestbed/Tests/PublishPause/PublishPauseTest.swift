//
//  PublishStreamImageTest.swift
//  R5ProTestbed
//
//  Created by Andy Zupko on 12/17/15.
//  Copyright © 2015 Infrared5. All rights reserved.
//

import UIKit
import R5Streaming

@objc(PublishPauseTest)
class PublishPauseTest: BaseTest {

    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        AVAudioSession.sharedInstance().requestRecordPermission { (gotPerm: Bool) -> Void in
            
        };
        
        
        setupDefaultR5VideoViewController()
        
        // Set up the configuration
        let config = getConfig()
        // Set up the connection and stream
        let connection = R5Connection(config: config)
        
        setupPublisher(connection: connection!)
        // show preview and debug info
        
        self.currentView!.attach(publishStream!)
        
        
        self.publishStream!.publish(Testbed.getParameter(param: "stream1") as! String, type: R5RecordTypeLive)
        
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PublishStreamImageTest.handleSingleTap(recognizer:)))

        self.view.addGestureRecognizer(tap)

        
        
    }

    func handleSingleTap(recognizer : UITapGestureRecognizer) {

        let hasAudio = !(self.publishStream?.pauseAudio)!;
        let hasVideo = !(self.publishStream?.pauseVideo)!;
        
        if(hasAudio && hasVideo){
            self.publishStream?.pauseAudio = true
            self.publishStream?.pauseVideo = false
             ALToastView.toast(in: self.view, withText:"Pausing Audio")
            
        }else if(hasVideo && !hasAudio){
            self.publishStream?.pauseVideo = true
            self.publishStream?.pauseAudio = false
            ALToastView.toast(in: self.view, withText:"Pausing Video")
        }else if(!hasVideo && hasAudio){
            self.publishStream?.pauseVideo = true
            self.publishStream?.pauseAudio = true
            ALToastView.toast(in: self.view, withText:"Pausing Audio/Video")
        }else{
            self.publishStream?.pauseVideo = false
            self.publishStream?.pauseAudio = false
            ALToastView.toast(in: self.view, withText:"Resuming Audio/Video")
        }
   
    }
    
    override func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        super.onR5StreamStatus(stream, withStatus: statusCode, withMessage: msg)
        if (Int(statusCode) == Int(r5_status_buffer_flush_start.rawValue)) {
            NotificationCenter.default.post(Notification(name: Notification.Name("BufferFlushStart")))
        }
        else if (Int(statusCode) == Int(r5_status_buffer_flush_empty.rawValue)) {
            NotificationCenter.default.post(Notification(name: Notification.Name("BufferFlushComplete")))
        }
    }


}
