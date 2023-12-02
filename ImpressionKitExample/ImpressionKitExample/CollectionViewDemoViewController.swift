//
//  CollectionViewDemoViewController.swift
//  ImpressionKitExample
//
//  Created by Yanni Wang on 31/5/21.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import ImpressionKit

class CollectionViewDemoViewController: UIViewController, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    let collectionView = { () -> UICollectionView in
        let layout = CHTCollectionViewWaterfallLayout.init()
        layout.columnCount = 4
        layout.minimumColumnSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        return view
    }()
    
    lazy var group = ImpressionGroup.init {(_, index: IndexPath, view, state) in
        if state.isImpressed {
            print("impressed index: \(index.row)")
        }
        if let cell = view.superview as? Cell {
            cell.updateUI(state: state)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "UICollectionView"
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.init(title: "push", style: .plain, target: self, action: #selector(pushNextPage)),
            UIBarButtonItem.init(title: "present", style: .plain, target: self, action: #selector(presentNextPage)),
            UIBarButtonItem.init(title: "redetect", style: .plain, target: self, action: #selector(redetect)),
        ]
        
        self.collectionView.frame = self.view.bounds
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.view.addSubview(self.collectionView)
    }
    
    @objc private func redetect() {
        self.group.redetect()
    }
    
    @objc private func pushNextPage() {
        let nextPage = UIViewController()
        nextPage.view.backgroundColor = .white
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
    
    @objc private func presentNextPage() {
        let nextPage = UIViewController()
        nextPage.view.backgroundColor = .white
        let backButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        backButton.setTitle("back", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.center = CGPoint.init(x: nextPage.view.frame.width / 2, y: nextPage.view.frame.height / 2)
        nextPage.view.addSubview(backButton)
        self.present(nextPage, animated: true, completion: nil)
    }
    
    @objc func back(){
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    // UICollectionViewDataSource & CHTCollectionViewDelegateWaterfallLayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 99
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.contentView.alpha = CGFloat(HomeViewController.alphaInDemo)
        self.group.bind(view: cell.contentView, index: indexPath)
        cell.index = indexPath.row
        cell.updateUI(state: self.group.states[indexPath])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 100
        let height = width + CGFloat.random(in: 0 ..< width)
        return CGSize.init(width: width, height: height)
    }
}

private class Cell: UICollectionViewCell {
    private var label = { () -> UILabel in
        let view = UILabel.init()
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .black
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    var index: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.borderColor = UIColor.gray.cgColor
        self.contentView.layer.borderWidth = 0.5
        self.contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.contentView.bounds
    }
    
    fileprivate func updateUI(state: UIView.ImpressionState?) {
        self.layer.removeAllAnimations()
        switch state {
        case .impressed(_, let areaRatio):
            self.label.text = String.init(format: "\(self.index)\n\n%0.1f%%", areaRatio * 100)
            self.contentView.backgroundColor = .green
        case .inScreen(_):
            self.contentView.backgroundColor = .white
            UIView.animate(withDuration: TimeInterval(self.contentView.durationThreshold ?? UIView.durationThreshold), delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {
                self.contentView.backgroundColor = .red
            }, completion: nil)
        default:
            self.label.text = "\(self.index)\n\n"
            self.contentView.backgroundColor = .white
        }
    }
}

