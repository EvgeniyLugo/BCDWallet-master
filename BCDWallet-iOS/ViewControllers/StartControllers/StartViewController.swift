//
//  StartViewController.swift
//  BCDWallet-iOS
//
//  Created by Evgeniy Lugovoy on 04/10/2019.
//  Copyright © 2019 Meadowsphone. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private let titles = ["Welcome to BitCAD", "Keep your crypto\nsecurely", "Experience the\nFuture"]
    private let descriptions = ["Swipe to learn more...", "Your private key is stored encrypted\nand never leaves device", "Start by choosing of your\nbusiness needs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        forwardButton.isHidden = true
    }
}

extension StartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "startCollectionCell", for: indexPath) as! StartCollectionViewCell
        cell.setParams(title: titles[indexPath.row], description: descriptions[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionViewHeight.constant)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let current = pageControl.currentPage
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        checkForward(current: current)
    }
    
    private func moveToNext() {
        let offset = CGFloat(floor(collectionView.contentOffset.x + collectionView.bounds.size.width))
        collectionView.setContentOffset(CGPoint(x: offset, y: collectionView.contentOffset.y), animated: true)
    }
    
    private func checkForward(current: Int) {
        if pageControl.currentPage == 2 {
            animateForward(correct: true)
        }
        else if current == 2 {
            animateForward(correct: false)
        }

    }
}

extension StartViewController {
    @IBAction func nextbuttonClicked(_ sender: Any) {
        if pageControl.currentPage < 2 {
            let current = pageControl.currentPage
            pageControl.currentPage += 1
            moveToNext()
            checkForward(current: current)
        }
    }

    @IBAction func forwardbuttonClicked(_ sender: Any) {
        UIApplication.setRootView(AgreedViewController.instantiate(from: .Start), options: UIApplication.curlUpAnimation)
    }
    
    private func animateForward(correct: Bool) {
        self.forwardButton.isHidden = false
        self.forwardButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        if correct {
            self.forwardButton.alpha = 0
            UIView.animate(withDuration: 0.25,
                           animations: { () -> Void in
                            self.forwardButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                            self.forwardButton.alpha = 1
            }) { (succeed) -> Void in
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.forwardButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            }
        }
        else {
            self.forwardButton.alpha = 1
            UIView.animate(withDuration: 0.5,
                           animations: { () -> Void in
                            self.forwardButton.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                            self.forwardButton.alpha = 0.0
            }) { (succeed) -> Void in
                self.forwardButton.isHidden = true
            }
        }

    }
}
