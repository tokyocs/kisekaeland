//
//  ViewController.swift
//  kisekaelandcam
//
//  Created by tcs15059 on 2019/07/11.
//  Copyright © 2019 tcs15059. All rights reserved.
//

import UIKit
import AVFoundation



class ViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    var captureSession = AVCaptureSession()
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func styleCaptureButton() {
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
    }
        
        // メインカメラの管理オブジェクトの作成
        var mainCamera: AVCaptureDevice?
        // インカメの管理オブジェクトの作成
        var innerCamera: AVCaptureDevice?
        // 現在使用しているカメラデバイスの管理オブジェクトの作成
        var currentDevice: AVCaptureDevice?
        
         var photoOutput : AVCapturePhotoOutput?
        
        func setupInputOutput() {
            do {
                // 指定したデバイスを使用するために入力を初期化
                let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
                // 指定した入力をセッションに追加
                captureSession.addInput(captureDeviceInput)
                // 出力データを受け取るオブジェクトの作成
                photoOutput = AVCapturePhotoOutput()
                // 出力ファイルのフォーマットを指定
                photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
                captureSession.addOutput(photoOutput!)
            } catch {
                print(error)
            }
        }

        
    // デバイスの設定
    func setupDevice() {
            // カメラデバイスのプロパティ設定
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            // プロパティの条件を満たしたカメラデバイスの取得
            let devices = deviceDiscoverySession.devices
            
            for device in devices {
                if device.position == AVCaptureDevice.Position.back {
                    mainCamera = device
                } else if device.position == AVCaptureDevice.Position.front {
                    innerCamera = device
                }
            }
            // 起動時のカメラを設定
            currentDevice = mainCamera
        }
    
    // 必要なライブラリをインポートします
   
    
    @IBAction func kisekae(_ sender: Any) {
    }
    
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    var kisekaeLayer : CALayer?
    func setupPreviewLayer() {
        // 指定したAVCaptureSessionでプレビューレイヤを初期化
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.kisekaeLayer = CALayer()
        self.kisekaeLayer?.frame = self.view.bounds
        self.kisekaeLayer?.contents = UIImage(named: "water")?.cgImage
        
        // プレビューレイヤが、カメラのキャプチャーを縦横比を維持した状態で、表示するように設定
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // プレビューレイヤの表示の向きを設定
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        
        
        self.cameraPreviewLayer?.frame = view.frame
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
        self.view.layer.insertSublayer(self.kisekaeLayer!,at: 1)
        // 必要なライブラリをインポートします
       
           
    }
   

    
    
    @IBAction func tuchshutter(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
      
        // カメラの手ぶれ補正
        settings.isAutoStillImageStabilizationEnabled = true
        // 撮影された画像をdelegateメソッドで処理
        self.photoOutput?.capturePhoto(with: settings, delegate: self as! AVCapturePhotoCaptureDelegate)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
//HELLO MY NAME IS HARUNORI MIYAJI


extension ViewController: AVCapturePhotoCaptureDelegate{
    // 撮影した画像データが生成されたときに呼び出されるデリゲートメソッド
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            // Data型をUIImageオブジェクトに変換
            let uiImage = UIImage(data: imageData)
            // 写真ライブラリに画像を保存
            UIImageWriteToSavedPhotosAlbum(uiImage!, nil,nil,nil)
        }
    }
}





