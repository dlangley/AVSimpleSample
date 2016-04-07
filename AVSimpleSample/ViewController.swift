//
//  ViewController.swift
//  AVSimpleSample
//
//  Created by Dwayne Langley on 4/4/16.
//  Copyright © 2016 Dwayne Langley. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Class Constants
    let imagePicker = UIImagePickerController()
    let saveFileName = "/simpleSample.mp4"
    
    // MARK: - Preparatory UIKit Video Recording Implementation
    @IBAction func recordVideo(sender: AnyObject) {
        
        // check device has any camera
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            // check device has a rear camera
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                
                // configure and use the class' imagePicker
                imagePicker.sourceType = .Camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                print("no rear camera")
            }
        } else {
            print("Cam not available")
        }
    }
    
    // MARK: ImagePikerDelegate Method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedVidUrl : NSURL = info[UIImagePickerControllerMediaURL] as? NSURL {
            let selectorToCall = #selector(ViewController.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVidUrl.relativePath!, self, selectorToCall, nil)
            
            let videoData = NSData(contentsOfURL: pickedVidUrl)
            
            let fileUrlString = pathFinder()
            
            videoData?.writeToFile(fileUrlString, atomically: false)
        }
        
        imagePicker.dismissViewControllerAnimated(true, completion: {})
    }
    
    // MARK: Utility Methods
    
    // I'd use this optional selector if this sample had a case in which I'd actually get an error.
    func videoWasSavedSuccessfully(video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){

//        if let theError = error {
//            print("An error happened while saving the video = \(theError)")
//        } else {
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                // What you want to happen
//            })
//        }
    }
    
    // Build Document Paths
    func pathFinder() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docDirectory: AnyObject = paths.first!
        return docDirectory.stringByAppendingString(saveFileName)
    }
    
    // MARK: - AVFoundation Simple Implementation to play a video with all of the controls.
    @IBAction func playVideo(sender: AnyObject) {
        
        // Using a pre-specified path
        let fileUrlString = pathFinder()
        
        // Instantiate an asset for my AVPlayerItem
        let videoAsset = AVAsset(URL: NSURL(fileURLWithPath: fileUrlString))
        
        // Instantiate the AVPlayerItem for the AVPlayer
        let playerItem = AVPlayerItem(asset: videoAsset)
        
        // Instantiate the AVPlayer for the AVPlayerViewController
        let player = AVPlayer(playerItem: playerItem)
        
        // Instantiate & Configure the AVPlayerViewController
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
        // Programmatically presenting the viewController with a play action on presentation.
        presentViewController(playerVC, animated: true) {
            playerVC.player!.play()
        }
    }
}

