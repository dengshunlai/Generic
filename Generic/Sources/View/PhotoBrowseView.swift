//
//  PhotoBrowseView.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/12/24.
//

import UIKit

open class PhotoBrowseView: BaseView {
    
    public var option = PhotoBrowseOption()
    
    public var imageList: [UIImage] = [] {
        didSet {
            didSetImageList()
        }
    }
    
    public var imageUrlList: [String] = [] {
        didSet {
            didSetImageUrlList()
        }
    }
    
    lazy var topBar = {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view
    }()
    lazy var titleLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    public lazy var collectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.register(PhotoBrowseCell.self, forCellWithReuseIdentifier: PhotoBrowseCell.identifier())
        return collectionView
    }()
    
    open override func setupUI() {
        self.backgroundColor = .black
        self.addSubview(collectionView)
        self.addSubview(topBar)
        topBar.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: self.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: Utils.navAddTopHeight())
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: topBar.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = option.scrollViewFrame
    }
    
    public func showIn(_ parent: UIView? = nil) {
        var parentView = parent
        if parentView == nil {
            parentView = Utils.getKeyWindow()
        }
        parentView?.addSubview(self)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        
        self.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.alpha = 1
        }
    }
    
    public func dismiss() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { finish in
            self.removeFromSuperview()
        }
    }
    
    func didSetImageList() {
        collectionView.reloadData()
    }
    
    func didSetImageUrlList() {
        collectionView.reloadData()
    }
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

extension PhotoBrowseView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageList.count > 0 {
            return imageList.count
        } else if imageUrlList.count > 0 {
            return imageUrlList.count
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowseCell.identifier(), for: indexPath) as! PhotoBrowseCell
        cell.collectonView = collectionView
        cell.clickSVBlock = { [weak self] in
            self?.dismiss()
        }
        cell.clickIVBlock = { [weak self] in
            self?.dismiss()
        }
        if imageList.count > 0 {
            cell.fillCell(image: imageList[indexPath.row])
        } else if imageUrlList.count > 0 {
            cell.fillCell(imageUrl: imageUrlList[indexPath.row])
        }
        return cell
    }
}

extension PhotoBrowseView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let aCell = cell as! PhotoBrowseCell
        aCell.scrollView.zoomScale = 1
    }
}


class PhotoBrowseCell: BaseCollectionViewCell, UIScrollViewDelegate {
    
    var clickSVBlock: (() -> ())?
    var clickIVBlock: (() -> ())?
    
    weak var collectonView: UICollectionView?
    
    lazy var scrollView = {
        let sv = UIScrollView.init()
        sv.backgroundColor = UIColor.clear
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 2
        return sv
    }()
    lazy var iv = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    override func setupUI() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(scrollView)
        scrollView.addSubview(iv)
    }
    
    override func setupOther() {
        let tapSV = UITapGestureRecognizer(target: self, action: #selector(clickSV))
        scrollView.addGestureRecognizer(tapSV)
        
        let tapIV = UITapGestureRecognizer(target: self, action: #selector(clickIV))
        iv.addGestureRecognizer(tapIV)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshSizeAndPos()
    }
    
    func fillCell(image: UIImage) {
        scrollView.zoomScale = 1
        iv.image = image
        refreshSizeAndPos()
    }
    
    func fillCell(imageUrl: String) {
        //TODO: 依赖KF获取网络图片
    }
    
    override func refreshSizeAndPos() {
        guard let image = iv.image else { return }
        let selfWHRatio = self.frame.size.width / self.frame.size.height
        let imageWHRatio = image.size.width / image.size.height
        var ivWidth = 0.0
        var ivHeight = 0.0
        if imageWHRatio >= selfWHRatio {
            ivWidth = self.frame.size.width
            ivHeight = ivWidth / image.size.width * image.size.height
        } else {
            ivHeight = self.frame.size.height
            ivWidth = ivHeight / image.size.height * image.size.width
        }
        iv.frame = CGRect(x: 0, y: 0, width: ivWidth, height: ivHeight)
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        scrollView.contentSize = iv.frame.size
        handelIVCenter()
    }
    
    func handelIVCenter() {
        let centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : scrollView.frame.size.width / 2;
        let centerY = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : scrollView.frame.size.height / 2;
        iv.center = CGPoint(x: centerX, y: centerY)
    }
    
    @objc func clickSV() {
        self.clickSVBlock?()
    }
    
    @objc func clickIV() {
        self.clickIVBlock?()
    }
    
    //MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return iv
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        handelIVCenter()
        if scrollView.zoomScale <= 1 {
            collectonView?.isScrollEnabled = true
        } else {
            collectonView?.isScrollEnabled = false
        }
    }
}


open class PhotoBrowseOption {
    
    var scrollViewFrame = CGRectMake(0, Utils.navAddTopHeight(),
                                     kScreenWidth, kScreenHeight - Utils.navAddTopHeight() - Utils.tabbarAddBottomHeight())
}
