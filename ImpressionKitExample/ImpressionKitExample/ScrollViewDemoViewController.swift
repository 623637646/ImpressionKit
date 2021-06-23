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
        self.view.backgroundColor = .gray
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem.init(title: "nextPage", style: .plain, target: self, action: #selector(nextPage)),
            UIBarButtonItem.init(title: "redetect", style: .plain, target: self, action: #selector(redetect)),
        ]
        
        self.scrollView.frame = CGRect(x: 0,
                                       y: view.frame
                                           .height * CGFloat(HomeViewController.viewHeightRatio) *
                                           (HomeViewController.viewHeightRatio == 1 ? 0 : 0.5),
                                       width: view.frame.width, height: view.frame.height * CGFloat(HomeViewController.viewHeightRatio))
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
    
    @objc private func nextPage() {
        let nextPage = UIViewController()
        nextPage.view.backgroundColor = .white
        self.navigationController?.pushViewController(nextPage, animated: true)
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
        switch state {
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
