//
//  ScrollViewDemoViewController.swift
//  ImpressionKitExample
//
//  Created by Yanni Wang on 31/5/21.
//

import UIKit
import ImpressionKit

class ScrollViewDemoViewController: UIViewController {
    
    private static let column = 4
    
    private let views = {
        return [Int](0...99).map { (index) -> CellView in
            return CellView.init(index: UInt(index))
        }
    }()
    
    private let scrollView = UIScrollView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "UIScrollView"
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.init(title: "push", style: .plain, target: self, action: #selector(pushNextPage)),
            UIBarButtonItem.init(title: "present", style: .plain, target: self, action: #selector(presentNextPage)),
            UIBarButtonItem.init(title: "redetect", style: .plain, target: self, action: #selector(redetect)),
        ]
        
        self.scrollView.frame = self.view.bounds
        self.view.addSubview(self.scrollView)
        
        var bottoms = [CGFloat].init(repeating: 0, count: ScrollViewDemoViewController.column)
        for cell in self.views {
            let y = bottoms.min()!
            let columnIndex = bottoms.firstIndex(of: y)!
            let width = self.scrollView.frame.width / CGFloat(ScrollViewDemoViewController.column)
            let height = width + CGFloat.random(in: 0 ..< width)
            let x = CGFloat(columnIndex) * width
            bottoms[columnIndex] = y + height
            cell.frame = CGRect.init(x: x, y: y, width: width, height: height)
            self.scrollView.addSubview(cell)
        }
        self.scrollView.contentSize = CGSize.init(width: self.scrollView.frame.width, height: bottoms.max()!)
    }
    
    @objc private func redetect() {
        self.views.forEach { (cell) in
            cell.redetect()
        }
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
}

private class CellView: UIView {
    
    let label = { () -> UILabel in
        let label = UILabel.init()
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let index: UInt
    
    init(index: UInt) {
        self.index = index
        super.init(frame: CGRect.zero)
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.alpha = CGFloat(HomeViewController.alphaInDemo)
        
        self.label.frame = self.bounds
        self.addSubview(self.label)
        self.updateUI()
        
        self.detectImpression { (view, state) in
            view.updateUI()
            if state.isImpressed {
                print("impressed index: \(view.index)")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        self.redetect()
        self.updateUI()
    }
    
    private func updateUI() {
        self.layer.removeAllAnimations()
        switch impressionState {
        case .impressed(_, let areaRatio):
            self.label.text = String.init(format: "\(self.index)\n\n%0.1f%%", areaRatio * 100)
            self.backgroundColor = .green
        case .inScreen(_):
            self.backgroundColor = .white
            UIView.animate(withDuration: TimeInterval(self.durationThreshold ?? UIView.durationThreshold), delay: 0, options: [.curveLinear, .allowUserInteraction], animations: {
                self.backgroundColor = .red
            }, completion: nil)
        default:
            self.label.text = "\(self.index)\n\n"
            self.backgroundColor = .white
        }
    }
}
