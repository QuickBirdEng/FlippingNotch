//
//  ViewController.swift
//  FlippingNotch
//
//  Created by Joan Disho on 14.01.18.
//  Copyright © 2018 Joan Disho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlets

    @IBOutlet var collectionView: UICollectionView!

    // MARK: Fileprivates

    fileprivate var notchView = UIView()
    fileprivate var notchViewTopConstraint: NSLayoutConstraint!
    fileprivate var isPulling: Bool = false
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNotchView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: UI

    private func configureNotchView() {
        self.view.addSubview(notchView)
        
        notchView.translatesAutoresizingMaskIntoConstraints = false
        notchView.backgroundColor = UIColor.black
        notchView.layer.cornerRadius = 20
        notchView.layer.masksToBounds = false
        
        notchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).activate
        notchView.widthAnchor.constraint(equalToConstant: Constants.notchWidth).activate
        notchView.heightAnchor.constraint(equalToConstant: 200).activate
        notchViewTopConstraint = notchView.bottomAnchor.constraint(equalTo: self.view.topAnchor, 
                                                                       constant: Constants.notchTopOffset)
        notchViewTopConstraint.activate
    }
    
    private func animateView() {
        let animatableView = UIImageView(frame: notchView.frame)
        animatableView.backgroundColor = UIColor.black
        animatableView.layer.cornerRadius = self.notchView.layer.cornerRadius
        animatableView.layer.masksToBounds = true
        animatableView.frame = self.notchView.frame
        self.view.addSubview(animatableView)
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let height = flowLayout.itemSize.height + flowLayout.minimumInteritemSpacing
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            let cellSize = flowLayout.itemSize
            animatableView.frame.size = CGSize(width: Constants.notchWidth, 
                                               height: (cellSize.height / cellSize.width) * Constants.notchWidth)
            animatableView.image = UIImage.fromColor(self.view.backgroundColor?.withAlphaComponent(0.2) ?? UIColor.black)
            animatableView.frame.origin.y = 40
            self.collectionView.contentOffset.y = 0
            self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: height * 0.5)
        }) { _ in
            UIView.transition(with: animatableView, duration: 0.6, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
                animatableView.frame.size = flowLayout.itemSize
                animatableView.frame.origin = CGPoint(x: (self.collectionView.frame.width - flowLayout.itemSize.width) / 2.0, 
                                                      y: self.collectionView.frame.origin.y - height * 0.5)
                animatableView.backgroundColor = UIColor.white
                self.collectionView.contentOffset.y = 0
                self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: height)
            }, completion: { _ in
                self.collectionView.transform = CGAffineTransform.identity
                animatableView.removeFromSuperview()
                self.isPulling = false
            })
        }
    }
}

// MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = max(Constants.maxScrollOffset, scrollView.contentOffset.y)
        notchViewTopConstraint.constant = Constants.notchTopOffset - min(0, scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !isPulling && scrollView.contentOffset.y <= Constants.scrollThreshold {
            isPulling = true
            animateView()
        }
    }
}
