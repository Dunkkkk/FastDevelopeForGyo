//
//  SwitchAnimationViewController.swift
//  animationStudy
//
//  Created by changgyo seo on 2022/07/22.
//

import UIKit
import SnapKit

final class SwitchAnimationViewController: UIViewController {
    
    var viewList: [UIColor] = {
        var list = [UIColor]()
        var temp: UIColor = .red
        list.append(temp)
        temp = .orange
        list.append(temp)
        temp = .cyan
        list.append(temp)
        temp = .gray
        list.append(temp)
        temp = .brown
        list.append(temp)
        
        return list
    }()
    let leftButton = UIButton()
    let rightButton = UIButton()
    let collectionView: UICollectionView = {
        let fl = UICollectionViewFlowLayout()
        fl.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: fl)
        
        return cv
    }()
    
    var leftInset : CGFloat = 70
    var rightInset : CGFloat = 70
    var topInset : CGFloat = 50
    var bottomInset : CGFloat = 24
    
    lazy var curIdx = self.viewList.count
    var cantAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
    }
    
    private func attribute(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftButton.tintColor = .black
        leftButton.addTarget(self, action: #selector(tapLeftButton(_:)), for: .touchUpInside)
        
        rightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        rightButton.tintColor = .black
        rightButton.addTarget(self, action: #selector(tapRightButton(_:)), for: .touchUpInside)
    }
    
    private func layout(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.frame.height * 0.6)
        }
        
        view.addSubview(leftButton)
        leftButton.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.width.equalTo(leftInset)
            $0.top.equalTo(collectionView.snp.top)
            $0.bottom.equalTo(collectionView.snp.bottom)
        }
        
        view.addSubview(rightButton)
        rightButton.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.width.equalTo(rightInset)
            $0.top.equalTo(collectionView.snp.top)
            $0.bottom.equalTo(collectionView.snp.bottom)
        }
    }
    
    @objc private func tapLeftButton(_ sender: Any){
        collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x - (view.frame.width / 2), y: 0) , animated: true)
    }
    @objc private func tapRightButton(_ sender: Any){
        collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x + (view.frame.width / 2), y: 0) , animated: true)
    }
    
}

extension SwitchAnimationViewController: UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate ,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewList.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = viewList[indexPath.section % viewList.count]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - leftInset - rightInset, height: collectionView.frame.height - topInset - bottomInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (cantAnimation) {
            cantAnimation.toggle()
            self.curIdx = indexPath.section
        }
        else {
            let x = indexPath.section
            collectionView.isScrollEnabled = false
            let curCell = collectionView.cellForItem(at: IndexPath(row: 0, section: curIdx))
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            collectionView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(x), y: self.collectionView.contentInset.top), animated: true)
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    cell.transform = .identity
                    curCell?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }){ _ in
                    if x == 0 {
                        self.cantAnimation = true
                        collectionView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat( self.viewList.count ), y: self.collectionView.contentInset.top), animated: false)
                    }
                    else if  x ==  self.viewList.count * 3 - 1 {
                        self.cantAnimation = true
                        collectionView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(self.viewList.count * 2 - 1), y: self.collectionView.contentInset.top), animated: false)
                    }
                    self.curIdx = x
                    collectionView.isScrollEnabled = true
                }
        }
    }
}

