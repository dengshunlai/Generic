//
//  CodeStore.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

class CodeStore {
    
    func templateUI() -> Void {
        /*
        <#lazy var name#> = {
            let tableView = UITableView.init(frame: .zero, style: .plain)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.tableFooterView = UIView.init()
            tableView.register(<#Class#>.self, forCellReuseIdentifier: <#identifier#>)
            return tableView
        }()
        
        <#lazy var name#> = {
            let label = UILabel.init()
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 1
            label.textAlignment = .left
            return label
        }()
        
        <#lazy var name#> = {
            let iv = UIImageView.init()
            iv.contentMode = .scaleAspectFit
            iv.image = UIImage(named: <#T##String#>)
            return iv
        }()
        
        <#lazy var name#> = {
            let btn = UIButton.init(type: .custom)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.setTitle("", for: .normal)
            btn.setImage(UIImage(named: ""), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            return btn
        }()
         
        <#lazy var name#> = {
            let sv = UIScrollView.init()
            sv.backgroundColor = UIColor.white
            return sv
        }()
        
        <#lazy var name#> = {
            let view = UIView.init()
            view.backgroundColor = UIColor.white
            return view
        }()
        
        <#lazy var name#> = {
            let tf = UITextField.init()
            tf.keyboardType = .default
            tf.borderStyle = .none
            tf.font = UIFont.systemFont(ofSize: 14)
            tf.textColor = UIColor.black
            tf.returnKeyType = .done
            tf.autocorrectionType = .no
            tf.spellCheckingType = .no
            tf.autocapitalizationType = .none
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 35))
            let done = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(<#T##@objc method#>))
            let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.items = [space, done]
            tf.inputAccessoryView = toolbar
            return tf
        }()
        
        <#lazy var name#> = {
            let textView = UITextView.init()
            textView.showsVerticalScrollIndicator = false
            textView.showsHorizontalScrollIndicator = false
            textView.font = UIFont.systemFont(ofSize: 14)
            textView.textColor = UIColor.black
            textView.returnKeyType = .done
            textView.autocorrectionType = .no
            textView.spellCheckingType = .no
            textView.autocapitalizationType = .none
            let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 35))
            let done = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(<#T##@objc method#>))
            let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.items = [space, done]
            textView.inputAccessoryView = toolbar
            return textView
        }()
        
        <#lazy var name#> = {
            let layout = UICollectionViewFlowLayout.init()
            layout.scrollDirection = .vertical
            let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = UIColor.white
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
            return collectionView
        }()
         */
    }
    
    func bar() -> Void {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor.white
        
        let ncBarAppearance = UINavigationBar.appearance()
        ncBarAppearance.isTranslucent = false
        ncBarAppearance.backgroundColor = UIColor.white
        ncBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.generic.hexColor("333333"),
            .font: UIFont.systemFont(ofSize: 17),
        ]
        ncBarAppearance.backIndicatorImage = UIImage.init(named: "back", in: Bundle(for: Self.self), compatibleWith: nil)
        ncBarAppearance.backIndicatorTransitionMaskImage = UIImage.init(named: "back", in: Bundle(for: Self.self), compatibleWith: nil)
        ncBarAppearance.tintColor = UIColor.orange
        
        if #available(iOS 13, *) {
            let ncBarStandarAppearance = UINavigationBarAppearance.init()
            ncBarStandarAppearance.titleTextAttributes = [
                .foregroundColor: UIColor.generic.hexColor("333333"),
                .font: UIFont.systemFont(ofSize: 17),
            ]
            ncBarStandarAppearance.backgroundColor = UIColor.white
            ncBarAppearance.standardAppearance = ncBarStandarAppearance
            ncBarAppearance.compactAppearance = ncBarStandarAppearance
            ncBarAppearance.scrollEdgeAppearance = ncBarStandarAppearance
        }
        
        let barBtnItemAppearance = UIBarButtonItem.appearance()
        barBtnItemAppearance.setTitleTextAttributes([
            .foregroundColor: UIColor.generic.hexColor("333333"),
            .font: UIFont.systemFont(ofSize: 15),
        ], for: .normal)
        barBtnItemAppearance.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 15),
        ], for: .highlighted)
        
        if #available(iOS 11, *) {
            let scrollViewAppearance = UIScrollView.appearance()
            scrollViewAppearance.contentInsetAdjustmentBehavior = .never
        }
        
        if #available(iOS 15, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
    
    //MARK: <#mark#>
}

/*
extension <#Class#>: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
}

extension <#Class#>: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        return view
    }
}
 */

/*
extension <#name#>: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell.init()
    }
}

extension <#name#>: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
*/
