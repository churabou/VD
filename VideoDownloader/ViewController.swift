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
