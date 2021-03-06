//
//  ViewController.swift
//  AugmentedCompass
//
//  Created by Buwaneka Galpoththawela on 11/16/15.
//  Copyright © 2015 Buwaneka Galpoththawela. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import AVFoundation

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    
    //MARK: - CAMERA METHOD
    
    
    
    @IBOutlet weak var previewView: UIView!
    var captureSession :AVCaptureSession?
    var previewLayer :AVCaptureVideoPreviewLayer?
    
    
    
    
    func startCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError?
        var input :AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
            
            
        }catch let error1 as NSError {
            error = error1
            input = nil
            print("Error\(error)")
        }
        if error == nil && captureSession!.canAddInput(input){
            captureSession!.addInput(input)
            
        
        }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer!.connection?.videoOrientation = .Portrait
            previewView.layer.addSublayer(previewLayer!)
            
            captureSession?.startRunning()
            
        }
    
    
    //MARK: - ROTATION METHOD
    
    private var motionManager = CMMotionManager()
    private var timer :NSTimer?
    @IBOutlet private var angleLabel :UILabel!
    
    
    @IBAction private func startAngleFinder(sender: UIButton) {
        timer = NSTimer(timeInterval: 0.2, target: self, selector: "getAngleInfo", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        
    }
    
    @IBAction private func stopAngleFinder(sender: UIButton) {
        if let uTimer = timer {
            uTimer.invalidate()
        }
    }
    
    
    func getAngleInfo (){
        if let uDeviceManager = motionManager.deviceMotion {
            let currentGaravity = uDeviceManager.gravity
            let angleInRadianss = atan2(currentGaravity.y, currentGaravity.x)
            var angleInDegrees = (angleInRadianss * 180.0/M_PI)
            if angleInDegrees <= -90 {
                angleInDegrees += 450.0
                
            }else {
                angleInDegrees += 90.0
            }
            
            angleLabel.text = "Angle : \(angleInDegrees)degrees"
            //string(format:"%.0f",angleInDegrees)
            
            
        }
    }
    

    
    //MARK: - COMPASS METHOD
    
    var locationManager = CLLocationManager()
    @IBOutlet var headingLabel :UILabel!
    
    @IBAction func startGettingHeading(sender:UIBarButtonItem){
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        
    }
    @IBAction func stopGettingHeading(sender:UIBarButtonItem){
        locationManager.stopUpdatingHeading()
        headingLabel.text = ""
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var headingString = ""
        switch newHeading.magneticHeading {
        case 0...22.5:
            headingString = "N"
        case 22.5...67.5:
            headingString = "NE"
        case 67.5...112.5:
            headingString = "E"
        case 112.5...157.5:
            headingString = "SE"
        case 157.5...202.5:
            headingString = "S"
        case 202.5...247.5:
            headingString = "SW"
        case 247.5...292.5:
            headingString = "W"
        case 293.5...337.5:
            headingString = "NW"
        case 337.5...360.0:
            headingString = "N"
            
        default:
            headingString = "?"
        }
        let wholeDegrees = String(format: "%.0f", newHeading.magneticHeading)
        headingLabel.text = "\(headingString)  \(wholeDegrees)°"
    }

    



    
    
    
    
    
    //MARK: - LIFE CYCLE METHOD

    override func viewDidLoad() {
        super.viewDidLoad()
        // motionManager = CMMotionManager
       motionManager.startDeviceMotionUpdates()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startCaptureSession()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer!.frame = previewView.bounds
        
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        //super.supportedInterfaceOrientations()
        return.All
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

