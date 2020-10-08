//
//  HomeViewController.swift
//  Loyalty
//
//  Created by treCoops on 10/8/20.
//  Copyright © 2020 treCoops. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var viewSearchParent: UIView!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    @IBOutlet weak var tblOffer: UITableView!
    
    var fetured : [XIBFeatured] = []
    var offers : [XIBOffer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfilePic.squareImageView()
        viewSearchParent.roundView()
        
        tblOffer.register(UINib(nibName: XIBIdentifier.XIB_OFFER, bundle: nil), forCellReuseIdentifier: XIBIdentifier.XIB_OFFER_CELL)
        
        
        offers.append(XIBOffer(bannerUrl: "", categoryName: "", title: "", logoUrl: ""))
        offers.append(XIBOffer(bannerUrl: "", categoryName: "", title: "", logoUrl: ""))
        offers.append(XIBOffer(bannerUrl: "", categoryName: "", title: "", logoUrl: ""))
        offers.append(XIBOffer(bannerUrl: "", categoryName: "", title: "", logoUrl: ""))
        
        
        registerNib()
        fetured.append(XIBFeatured(logoURL: ""))
        fetured.append(XIBFeatured(logoURL: ""))
        fetured.append(XIBFeatured(logoURL: ""))
        fetured.append(XIBFeatured(logoURL: ""))
        fetured.append(XIBFeatured(logoURL: ""))
        fetured.append(XIBFeatured(logoURL: ""))
        fetured.append(XIBFeatured(logoURL: ""))
        fetured.append(XIBFeatured(logoURL: ""))
        fetured.append(XIBFeatured(logoURL: ""))
        fetured.append(XIBFeatured(logoURL: ""))
        
        self.featuredCollectionView.reloadData()
        
        
    }
    
    func registerNib() {
        let nib = UINib(nibName: FeaturedCollectionViewCell.nibName, bundle: nil)
        featuredCollectionView?.register(nib, forCellWithReuseIdentifier: FeaturedCollectionViewCell.reuseIdentifier)
        if let flowLayout = self.featuredCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }
    

}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOffer.dequeueReusableCell(withIdentifier: XIBIdentifier.XIB_OFFER_CELL, for: indexPath) as! OfferTableViewCell
               cell.configXIB(data: offers[indexPath.row])
               
               cell.alpha = 0
               UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), animations: {
                   cell.alpha = 1
               })
               
               return cell
    }
    
    
}


extension HomeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetured.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = featuredCollectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.reuseIdentifier,
                                                             for: indexPath) as? FeaturedCollectionViewCell {
            cell.configureCell(Data: fetured[indexPath.row])
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: FeaturedCollectionViewCell = Bundle.main.loadNibNamed(FeaturedCollectionViewCell.nibName, owner: self, options: nil)?.first as? FeaturedCollectionViewCell else {
            return CGSize.zero
        }
        
        cell.configureCell(Data: fetured[indexPath.row])
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 65)
    }
    
}
