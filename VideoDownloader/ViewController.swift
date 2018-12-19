//
//  ViewController.swift
//  VideoDownloader
//
//  Created by ちゅーたつ on 2018/12/19.
//  Copyright © 2018年 churabou. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoList = VideoListController()
        videoList.tabBarItem = UITabBarItem.init(title: "保存", image: nil, tag: 1)
        let download = DownloadController()
        download.tabBarItem = UITabBarItem.init(title: "ダウンロード", image: nil, tag: 1)
        setViewControllers([videoList, download], animated: false)
    }
    
    func cannnotdownloadvideo() {
        let path = "https://r5---sn-oguesnze.googlevideo.com/videoplayback?mt=1545191192&sparams=clen%2Cdur%2Cei%2Cgir%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&mv=m&fvip=4&ms=au%2Conr&id=o-ANPDxrHRiNpIcnSj6WIa74HYIqsoVB8GdMLNMiXTmr1r&mime=video%2Fmp4&pl=22&gir=yes&mm=31%2C26&ip=210.226.228.254&key=yt6&mn=sn-oguesnze%2Csn-3pm7dn7s&expire=1545212875&ei=ar8ZXMzpN8eV4ALLxLf4Dw&signature=1DAC82FC9187B264397DB51517B79364A2FEC94E.1655133C48340D28A7588F9CE84C46296CD73220&requiressl=yes&itag=18&source=youtube&initcwndbps=1186250&clen=13749304&dur=214.947&ipbits=0&c=MWEB&txp=2211222&lmt=1544860367280403&ratebypass=yes&cpn=RQVFrYUvzSRZgj3U&cver=2.20181215&ptk=youtube_none&pltype=contentugc"
        
        let url = URL.init(string: path)!
        URLSession.shared.dataTask(with: url) { data, res, error in
            print(res)
            
            print(error)
            
            let savepath = NSHomeDirectory() + "/Documents/aaa.mp4"
            let url = URL.init(fileURLWithPath: savepath)
            try? data?.write(to: url)
            }.resume()
    }
}



import Foundation


protocol DonwLoaderDelegate: class {
    func updateProgress(to: Float)
    func sucess(location: URL)
    func failed()
}

class DonwLoader: NSObject {
    
    static let shared = DonwLoader()
    
    weak var delegate: DonwLoaderDelegate?
    
    lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    
    func download(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let task = session.downloadTask(with: url)
        task.resume()
    }
}

extension DonwLoader: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // ダウンロード進行中の処理
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        // ダウンロードの進捗をログに表示
        print(String(format: "%.2f", progress * 100) + "%")
        
        DispatchQueue.main.async {
            self.delegate?.updateProgress(to: progress)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // ダウンロードエラー発生時の処理
        if error != nil {
            print("download error: \(error)")
            delegate?.failed()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        delegate?.sucess(location: location)
    }
}


import UIKit
import AVKit
import AVFoundation

final class ShowVideoController: AVPlayerViewController {
    
    private var filePath: String
    
    init(filePath: String) {
        self.filePath = filePath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = AVPlayer(url: URL(fileURLWithPath: filePath))
        player?.play()
    }
}
