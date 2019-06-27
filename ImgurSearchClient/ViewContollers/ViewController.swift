//
//  ViewController.swift
//  ImgurSearchClient
//
//  Created by Laxman Penmesta on 6/27/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var currentPage = 0
    var imagesArr = [ItemModel]()
    private let network = NetworkHandler()
    var debounceTimer = DebounceTimer(with: 0.25)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        searchBar.delegate = self
        
        registerNibs()
        populateImages()
    }

    func registerNibs(){
        collectionView.register(UINib(nibName: Constants.CollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.CollectionViewCell)
    }

    func populateImages()  {
        network.fetchImagesBySearch(1, self.searchBar.text?.count == 0 ? "flowers" : searchBar.text ?? "") { [weak self] resultArr in
            guard let self = self else {return}
            self.imagesArr = resultArr
            self.collectionView.reloadData()
        }
    }
    
    func fetchNextPageImages(){
        currentPage += 1
        if currentPage > 25{
            return
        }
        self.network.fetchImagesBySearch(currentPage, self.searchBar.text ?? "") { [weak self] results in
            guard let self = self else {return}
            self.imagesArr = results
            self.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCell, for: indexPath) as? CollectionViewCell {
            if indexPath.item < self.imagesArr.count{
                cell.titleLabel.text = self.imagesArr[indexPath.item].title
                let imageLink = self.imagesArr[indexPath.item].imageLink
                if imageLink.contains(".mp4"){
                    do {
                        if let url = URL(string: imageLink){
                            let asset = AVURLAsset(url: url, options: nil)
                            let imgGenerator = AVAssetImageGenerator(asset: asset)
                            imgGenerator.appliesPreferredTrackTransform = true
                            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                            let thumbnail = UIImage(cgImage: cgImage)
                            cell.imageView.image = thumbnail
                        }
                    } catch let error {
                        print("*** Error generating thumbnail: \(error.localizedDescription)")
                    }
                }else{
                    if let url = URL(string: imageLink){
                        cell.imageView.kf.setImage(with: url)
                    }
                }
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArr.count
    }
}
extension ViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: Constants.DetailViewController) as? DetailViewController {
            detailViewController.imageLink = self.imagesArr[indexPath.item].imageLink
            detailViewController.titleString = self.imagesArr[indexPath.item].title
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let nextPageOffset: Float = Float(offset.y + bounds.size.height - inset.bottom)
        let height: Float = Float(size.height)
        
        let reload_distance: Float = 50
        
        if nextPageOffset > height - reload_distance {
            self.fetchNextPageImages()
        }
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 15
        let collectionViewSize = collectionView.frame.size.width - padding
        var width: CGFloat = 0
        // Display 3 columns on landscape, 2 columes on portrait
        if UIDevice.current.orientation.isLandscape {
            width = collectionViewSize/3
        } else {
            width = collectionViewSize/2
        }
        return CGSize(width: width, height: width)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.imagesArr = []
        self.debounceTimer.resetTimer()
        debounceTimer.timerHandler = {
            self.populateImages()
            self.collectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.imagesArr = []
        self.currentPage = 0
        self.collectionView.reloadData()
    }
}
