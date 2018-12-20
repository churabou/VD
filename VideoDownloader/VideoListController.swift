//
//  VideoListController.swift
//  VideoDownloader
//
//  Created by ちゅーたつ on 2018/12/19.
//  Copyright © 2018年 churabou. All rights reserved.
//

import UIKit


final class VideoListController: UIViewController {
    
    
    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(VideoListCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    private var videos: [VideoData] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocalVideo()
    }
    
    func loadLocalVideo() {
        let documentPath = NSHomeDirectory() + "/Documents"
        if let items = try? FileManager.default.contentsOfDirectory(atPath: documentPath) {
            videos = items.map { VideoData(filePath: NSHomeDirectory() + "/Documents/" + $0 ) }
        }
        tableView.reloadData()
    }
}

extension VideoListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = ShowVideoController(filePath: videos[indexPath.row].filePath)
        present(c, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return VideoListCell.height
    }
}

extension VideoListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? VideoListCell else {
            fatalError("not video list cell")
        }
        cell.configure(video: videos[indexPath.row])
        return cell
    }
}
