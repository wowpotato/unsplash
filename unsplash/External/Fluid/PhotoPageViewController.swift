//
//  PhotoPageViewController.swift
//  FluidPhoto
//
//  Created by Masamichi Ueta on 2016/12/23.
//  Copyright © 2016 Masmichi Ueta. All rights reserved.
//

import UIKit

class PhotoPageViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var totalPageLabel: UILabel!
    
    var pageViewController: UIPageViewController?
    
    var currentViewController: PhotoZoomViewController? {
        guard let pvc = self.pageViewController else { return nil }
        guard let viewControllers = pvc.viewControllers, viewControllers.count > 0 else { return nil }
        return viewControllers[0] as? PhotoZoomViewController
    }
    
    var datas: [Image] = []
    var currentIndex = 0
    var nextIndex: Int?
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    var transitionController = ZoomTransitionController()
    var pageFrom: PhotoPageFrom?
    
    deinit {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let viewController = segue.destination  as? UIPageViewController {
            self.pageViewController = viewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @discardableResult
    static func pushVC(_ superView: UIView?,  _ index: Int, _ items: [Image], _ collectionView: UICollectionView?, nvc: UINavigationController?, direction: UICollectionView.ScrollPosition = .centeredVertically, animated : Bool = true) -> PhotoPageViewController? {
        guard let superView = superView else { return nil }
        guard let collectionView = collectionView else { return nil }
        
        guard let vc = UIStoryboard.Storyboard(storyboardName: "FluidPhoto", identifier: PhotoPageViewController.self) else { return nil }
        
        let from = PhotoPageFrom(collectionView, superView, index)
        from.direction = direction
        vc.pageFrom = from

        nvc?.delegate = vc.transitionController
        vc.transitionController.fromDelegate = from
        vc.transitionController.toDelegate = vc
        vc.currentIndex = index
        vc.datas = items
        nvc?.pushViewController(vc, animated: animated)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pvc = self.pageViewController else { return }
        
        self.setPageCount()
        
        pvc.delegate = self
        pvc.dataSource = self
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanWith(gestureRecognizer:)))
        self.panGestureRecognizer.delegate = self
        pvc.view.addGestureRecognizer(self.panGestureRecognizer)
        
        self.singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSingleTapWith(gestureRecognizer:)))
        pvc.view.addGestureRecognizer(self.singleTapGestureRecognizer)
        
        let vc = self.getPhotoZoomVC(self.currentIndex)
        let viewControllers: [UIViewController] = [vc]
        self.singleTapGestureRecognizer.require(toFail: vc.doubleTapGestureRecognizer)
        
        pvc.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
    }
    
    func getPhotoZoomVC(_ index: Int) -> PhotoZoomViewController {
        let vc = PhotoZoomViewController.getVC()
        vc.delegate = self
        vc.index = index
        vc.item = self.getItem(index)
        return vc
    }
    
    func getItem(_ index: Int) -> Image {
        let item = self.datas[index]
        return item
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = gestureRecognizer.velocity(in: self.view)

            var velocityCheck : Bool = false

            if UIDevice.current.orientation.isLandscape {
                velocityCheck = velocity.x < 0
            }
            else {
                velocityCheck = velocity.y < 0
            }
            if velocityCheck {
                return false
            }
        }

        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let cvc = self.currentViewController else { return false }
        if otherGestureRecognizer == cvc.scrollView.panGestureRecognizer {
            if cvc.scrollView.contentOffset.y == 0 {
                return true
            }
        }
        return false
    }
    
    @objc func didPanWith(gestureRecognizer: UIPanGestureRecognizer) {
        guard let cvc = self.currentViewController else { return }
        guard cvc.imageView.image != nil else { return }
        switch gestureRecognizer.state {
        case .began:
            cvc.scrollView.isScrollEnabled = false
            self.transitionController.isInteractive = true
            self.popViewController()
        case .ended:
            if self.transitionController.isInteractive {
                cvc.scrollView.isScrollEnabled = true
                self.transitionController.isInteractive = false
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        default:
            if self.transitionController.isInteractive {
                self.transitionController.didPanWith(gestureRecognizer: gestureRecognizer)
            }
        }
    }
    
    @objc func didSingleTapWith(gestureRecognizer: UITapGestureRecognizer) {
        if self.pageView.isHidden {
            self.pageView.isHidden = false
        }
        else {
            self.pageView.isHidden = true
        }
    }

    //MARK:- Page
    func setPageCount() {
        self.totalPageLabel.text = "\(String(format: "/%02d", datas.count))"
        self.currentPageLabel.text = "\(String(format: "%02d", self.currentIndex + 1))"
    }
    
    //MARK:- Action
    @IBAction func onCloseButton(_ sender: UIButton) {
        self.popViewController()
    }
    
    func popViewController() {
        let _ = self.navigationController?.popViewController(animated: true)
    }
}

extension PhotoPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return self.currentIndex
//    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return self.datas.count
//    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if currentIndex == 0 {
            return nil
        }
        
        let vc = self.getPhotoZoomVC(currentIndex - 1)
        self.singleTapGestureRecognizer.require(toFail: vc.doubleTapGestureRecognizer)
        return vc
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if currentIndex == (self.datas.count - 1) {
            return nil
        }
        
        let vc = self.getPhotoZoomVC(currentIndex + 1)
        self.singleTapGestureRecognizer.require(toFail: vc.doubleTapGestureRecognizer)
        return vc
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        guard let nextVC = pendingViewControllers.first as? PhotoZoomViewController else {
            return
        }
        
        self.nextIndex = nextVC.index
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let next = self.nextIndex, completed {
            previousViewControllers.forEach { vc in
                let zoomVC = vc as! PhotoZoomViewController
                zoomVC.scrollView.zoomScale = zoomVC.scrollView.minimumZoomScale
                
                self.currentIndex = next
                self.setPageCount()
                let indexPath = IndexPath(row: next, section: 0)
                self.pageFrom?.scrollToItem(indexPath)
            }
        }
        
        self.nextIndex = nil
    }
    
}

extension PhotoPageViewController: PhotoZoomViewControllerDelegate {
    
    func photoZoomViewController(_ photoZoomViewController: PhotoZoomViewController, scrollViewDidScroll scrollView: UIScrollView) {
    }
}

extension PhotoPageViewController: ZoomAnimatorDelegate {
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
        
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        guard let cvc = self.currentViewController else { return nil }
        return cvc.imageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        guard let cvc = self.currentViewController else { return .zero }
//        guard let imageView = cvc.imageView else { return .zero }
        return cvc.scrollView.convert(cvc.imageView.frame, to: self.view)
//        return cvc.scrollView.convert(cvc.imageView.frame, to: cvc.view)
    }
}
