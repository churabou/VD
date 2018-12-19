//
//  DownloadController.swift
//  VideoDownloader
//
//  Created by ちゅーたつ on 2018/12/19.
//  Copyright © 2018年 churabou. All rights reserved.
//

import UIKit
import AVFoundation

final class DownloadController: UIViewController {
    
    override func viewDidLoad() {
        let webView = UIWebView()
//        let url = "https://www.youtube.com/watch?v=wS8VUKFQdTk&feature=youtu.be"
        let url = "https://www.google.com"
        webView.loadRequest(URLRequest(url: URL(string: url)!))
        view.addSubview(webView)
        
        downloadButton.setTitle("download", for: .normal)
        downloadButton.layer.cornerRadius = 5
        downloadButton.addTarget(self, action: #selector(actionDownload), for: .touchUpInside)
        downloadButton.isEnabled = false
        downloadButton.alpha = 0.7
        downloadButton.backgroundColor = .orange
        view.addSubview(downloadButton)
        
        webView.chura.layout
            .left(0).top(view.safeAreaLayoutGuide.topAnchor)
            .right(0).bottom(anchor: downloadButton.topAnchor, offSet: -5)
        
        downloadButton.chura
            .layout.left(5).right(-5)
            .bottom(view.safeAreaLayoutGuide.bottomAnchor).height(50)
        
        loadingLabel.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        loadingLabel.frame = view.bounds
        loadingLabel.textColor = .white
        loadingLabel.font = .systemFont(ofSize: 50)
        loadingLabel.text = "start download"
        view.addSubview(loadingLabel)
        loadingLabel.isHidden = true
    }
    
    private let downloadButton = UIButton()
    private var loadingLabel = UILabel()
    
    @objc private func actionDownload() {
        loadingLabel.isHidden = false
        DonwLoader.shared.download(url: downloadUrl!)
        DonwLoader.shared.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemBecameCurrent), name: NSNotification.Name(rawValue: "AVPlayerItemBecameCurrentNotification"),
                                               object:nil)
    }
    
    private var downloadUrl: String? {
        didSet {
            downloadButton.isEnabled = downloadUrl != nil
            downloadButton.alpha = downloadButton.isEnabled ? 1 : 0.4
        }
    }
    
    @objc func playerItemBecameCurrent(notification:NSNotification){
        
        guard let playerItem: AVPlayerItem = notification.object as? AVPlayerItem,
            let asset: AVURLAsset=playerItem.asset as? AVURLAsset else {
                return
        }
        let path = asset.url.absoluteString
        print("get video url: \(path)")
        downloadUrl = path
    }
}

extension DownloadController: DonwLoaderDelegate {
    
    func updateProgress(to: Float) {
        loadingLabel.text = "progress in \(to)"
    }
    
    func sucess(location: URL) {
        let data = try! Data(contentsOf: location)
        let path = NSHomeDirectory() + "/Documents/\(UUID().uuidString).mp4"
        try! data.write(to: URL(fileURLWithPath: path))
        
        loadingLabel.isHidden = true
        downloadUrl = nil
    }
    
    func failed() {
        
    }
}


