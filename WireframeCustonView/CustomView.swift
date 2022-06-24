//
//  MockUpview.swift
//  DLIFE
//
//  Created by changgyo seo on 2022/01/03.
//

import UIKit
import SnapKit

class MockUpView: UIView{
    
    var name = UILabel()
    var vc: UIViewController?
    var delegate: ifBtn?
    var ifBaackBtn: Bool?
    var wantPrint: String?
    
    init(frame: CGRect, name: String, ifBtn: UIViewController? = nil, ifBackBtn: Bool = false, wantPrint: String? = nil) {
        super.init(frame: frame)
        self.name.text = name
        self.name.textColor = .black
        self.name.font = UIFont.systemFont(ofSize: CGFloat(12))
        self.name.textAlignment = .center
        self.settingView()
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.black.cgColor
        self.backgroundColor = .green
        if ifBtn != nil {
            self.vc = ifBtn
            let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
            self.addGestureRecognizer(gesture)
        } else if ifBackBtn {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(backAction(_:)))
            self.addGestureRecognizer(gesture)
        }
        if wantPrint != nil {
            self.wantPrint = wantPrint
            let gesture = UITapGestureRecognizer(target: self, action: #selector(printSomthing(_:)))
            self.addGestureRecognizer(gesture)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func tapAction(_ sender: Any){
        self.delegate?.whatVC(vc: self.vc ?? UIViewController())
    }
    
    @objc private func backAction(_ sender: Any){
        self.delegate?.wantBack()
    }
    @objc private func printSomthing(_ sender: Any){
        self.delegate?.printSomeThings(s: self.wantPrint!, vc: self.vc!)
    }
    
    private func settingView(){
        self.addSubview(name)
        name.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
}

protocol ifBtn {
    func whatVC(vc: UIViewController)
    func wantBack()
    func printSomeThings(s: String, vc: UIViewController)
}

extension UIViewController: ifBtn {
    
    func wantBack() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func whatVC(vc: UIViewController) {
       
        present(vc, animated: false)
    }
    
    func printSomeThings(s: String, vc: UIViewController) {
        let action = UIAlertAction(title: "ㅇㅋ", style: .default, handler: nil)
        let alert = UIAlertController(title: s + "를 눌렀다 임마", message: "DLIFE 대박나라", preferredStyle: .alert)
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}



