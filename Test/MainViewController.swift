//
//  ViewController.swift
//  Test
//
//  Created by Anton Romanov on 24/10/2018.
//  Copyright © 2018 Anton Romanov. All rights reserved.
//

import UIKit
import AlamofireImage

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainTableWithPictures: UITableView!
    
    var downloadedListOfPrefferedNumberOfImages = [[PicsumImage]]()
    let placeholderImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableWithPictures.delegate = self
        mainTableWithPictures.dataSource = self
        
        placeholderImage.af_setImage(withURL: URL(string: "https://picsum.photos/300")!)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return downloadedListOfPrefferedNumberOfImages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

        if section == tableView.numberOfSections - 1 {
            return 18.0
        } else {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VerticalTableViewCell") as! VerticalTableViewCell
        
        cell.horizontalCollectionView.tag = indexPath.section
        cell.horizontalCollectionView.delegate = self
        cell.horizontalCollectionView.dataSource = self
        return cell
    }
    
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedListOfPrefferedNumberOfImages[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCollectionViewCell", for: indexPath) as! HorizontalCollectionViewCell
        
        cell.imageViewForImageFromPicsum.af_setImage(withURL: URL(string: "https://picsum.photos/300/300?image=\(downloadedListOfPrefferedNumberOfImages[collectionView.tag][indexPath.row].id)")!, placeholderImage: placeholderImage.image, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { response in
        })
        cell.layer.cornerRadius = 12.0
        cell.lblAuthorName.text = downloadedListOfPrefferedNumberOfImages[collectionView.tag][indexPath.row].author
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 18.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 18.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 150.0, height: 175.0)
    }
    
}

//MARK: - Scroll View Delegate
extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainTableWithPictures {
            if(scrollView.contentOffset.x != 0){
                scrollView.setContentOffset(CGPoint(x: 0.0, y: scrollView.contentOffset.y), animated: false)
            }
        }
    }
    
    
}

