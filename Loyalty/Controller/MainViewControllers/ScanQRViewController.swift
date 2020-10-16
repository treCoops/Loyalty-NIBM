//
//  ScanQRViewController.swift
//  Loyalty
//
//  Created by Hishara Dilshan on 10/16/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    //Set recognized types to QR codes
    var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    var launchedFromOfferClaim: Bool = false
    var offerClaimCallback: ((Bool)->())?
    var offer: Offer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIO()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //start the camera session if its not running
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        launchedFromOfferClaim = false
        //stop the camera session if changed viewControllers
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    //prepare to move to next viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Seagus.ScanQRToViewOffer {
            let destVC = segue.destination as! OfferViewController
            destVC.offer = offer
        }
    }
}

//MARK: - Interface Actions

extension ScanQRViewController {
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Inclass methods

extension ScanQRViewController {
    //validate the scnned QR code data to check whether it's a valid offer
    func validateAndViewOffer(qrCode: String){
        //optional bind the data retrieved from helper
        if let offer = DataModelHelper.requestOfferDataFromOfferIF(offerID: qrCode) {
            if (captureSession?.isRunning == true) {
                captureSession.stopRunning()
            }
            
            if launchedFromOfferClaim {
                self.dismiss(animated: true, completion: nil)
                self.offerClaimCallback?(true)
                return
            }
            
            self.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: Seagus.ScanQRToViewOffer, sender: nil)
                self.offer = offer
            })
        } else {
            PopupAlerts.instance.createAlert(title: FieldErrorCaptions.scannerOfferNotValidTitle, message: FieldErrorCaptions.scannerOfferNotValidDescription).addAction(title: "OK", handler: {_ in})
        }
    }
    //setup camera HW inorder to start capturing QR codes
    func setupIO() {
        view.backgroundColor = UIColor.black
        //check the HW is supported otherwise RETURN
        //NOTE: THIS WILL NOT WORK ON SIMMULATORS
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            NSLog("Capture session failed")
            return
        }
        captureSession = AVCaptureSession()
        let videoInput: AVCaptureDeviceInput
        do {
            //Set the Audio Video capture input to deviceInput (Camera)
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Unable to initialize CaptureDeviceInput \(error)")
            return
        }

        //check whether the generated capturesession is compatible with AVCaptureDevice Video input
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        //Holds the meta data of the captured videoData
        let metadataOutput = AVCaptureMetadataOutput()

        //Set the metadata output
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            //Set the delegate
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            //set the recognized object types (QR)
            metadataOutput.metadataObjectTypes = supportedBarcodeTypes
        } else {
            failed()
            return
        }

        //Setup the preview layer and add the preview layer to the root View
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        //start the session
        captureSession.startRunning()
        NSLog("Capture session running")
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    //if the capture grabs QR data
    func found(code: String) {
        NSLog("Scanned QR data : \(code)")
        validateAndViewOffer(qrCode: code)
    }
    
    //Delegate methods
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

//    override var prefersStatusBarHidden: Bool {
//        return true
//    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

