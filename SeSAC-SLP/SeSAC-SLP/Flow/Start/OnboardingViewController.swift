//
//  OnboardingViewController.swift
//  SeSAC-SLP
//
//  Created by Sehun Kang on 2022/02/26.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    static let identifier = "OnboardingViewController"

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: FilledButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)

        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = CustomColor.SLPBlack.color
        pageControl.pageIndicatorTintColor = CustomColor.SLPGray5.color
    }
    
    @IBAction func startButtonClicked(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: PhoneAuthViewController.identifier) as! PhoneAuthViewController
        let nav = UINavigationController(rootViewController: vc)
        self.view.window?.rootViewController = nav
        self.view.window?.makeKeyAndVisible()
    }
    
    
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else {return UICollectionViewCell()}
        
        let text = NSMutableAttributedString()
        let image: UIImage
        if indexPath.item == 0 {
            text.append(NSAttributedString(string: "위치 기반", attributes: [NSAttributedString.Key.foregroundColor: CustomColor.SLPGreen.color]))
            text.append(NSAttributedString(string: "으로 빠르게\n주위 친구를 확인", attributes: [NSAttributedString.Key.foregroundColor: CustomColor.SLPBlack.color]))
            image = UIImage(named: "onboarding_img1")!
        } else if indexPath.item == 1 {
            text.append(NSAttributedString(string: "관심사가 같은 친구", attributes: [NSAttributedString.Key.foregroundColor: CustomColor.SLPGreen.color]))
            text.append(NSAttributedString(string: "를\n찾을 수 있어요", attributes: [NSAttributedString.Key.foregroundColor: CustomColor.SLPBlack.color]))
            image = UIImage(named: "onboarding_img2")!
        } else {
            text.append(NSAttributedString(string: "SeSAC Friends", attributes: [NSAttributedString.Key.foregroundColor: CustomColor.SLPBlack.color]))
            image = UIImage(named: "onboarding_img3")!
        }
        
        cell.imageView.image = image
        cell.textLabel.attributedText = text
        return cell
    }
    
    //collectionView의 Estimate Size를 None으로 해줘야 함
    //코드로는 (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = .zero
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2

        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
}
