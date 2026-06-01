import UIKit
import SDWebImage
public class ImageViewerVC: UIViewController, UIScrollViewDelegate {

    // MARK: - Public Properties
    public var images: [String] = []
    public var startIndex: Int = 0

    // MARK: - Private UI Elements
    private let pagingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .black
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.hidesForSinglePage = true
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        if let closeImage = UIImage(systemName: "xmark") {
            button.setImage(closeImage, for: .normal)
            button.tintColor = .white
        } else {
            button.setTitle("Close", for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
        button.accessibilityLabel = "Close"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        if let nextImage = UIImage(systemName: "chevron.right") {
            button.setImage(nextImage, for: .normal)
            button.tintColor = .white
        } else {
            button.setTitle("Next", for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
        button.accessibilityLabel = "Next image"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let prevButton: UIButton = {
        let button = UIButton(type: .system)
        if let prevImage = UIImage(systemName: "chevron.left") {
            button.setImage(prevImage, for: .normal)
            button.tintColor = .white
        } else {
            button.setTitle("Prev", for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
        button.accessibilityLabel = "Previous image"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private Properties
    private var zoomScrollViews: [UIScrollView] = []
    private var imageViews: [UIImageView] = []
    
    private var panGesture: UIPanGestureRecognizer!
    private var doubleTapGestureRecognizers: [UITapGestureRecognizer] = []
    private var didStartLoadingImages: Bool = false
    private var hasInitialLayoutCompleted: Bool = false

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        configureImages()
        if !images.isEmpty {
            let urls = images.compactMap { URL(string: $0) }
            SDWebImagePrefetcher.shared.prefetchURLs(urls)
        }
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(panGesture)

        pageControl.currentPage = safeStartIndex()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutPagingScrollView()
        layoutZoomScrollViews()
        if !hasInitialLayoutCompleted {
            hasInitialLayoutCompleted = true
            DispatchQueue.main.async {
                self.scrollToPage(self.pageControl.currentPage, animated: false)
            }
        }

        if !didStartLoadingImages {
            didStartLoadingImages = true
            for (index, urlString) in images.enumerated() {
                loadRemoteImage(from: urlString, into: imageViews[index])
            }
            preloadNeighbors(of: pageControl.currentPage)
        }
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Setup UI

    private func setupUI() {
        view.addSubview(pagingScrollView)
        pagingScrollView.delegate = self

        view.addSubview(pageControl)
        view.addSubview(closeButton)
        view.addSubview(nextButton)
        view.addSubview(prevButton)

        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            pagingScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pagingScrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            pagingScrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            pagingScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),

            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -12),
            nextButton.widthAnchor.constraint(equalToConstant: 44),
            nextButton.heightAnchor.constraint(equalToConstant: 44),

            prevButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            prevButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 12),
            prevButton.widthAnchor.constraint(equalToConstant: 44),
            prevButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    // MARK: - Configure Images

    private func configureImages() {
        // Cleanup any existing zoomScrollViews and imageViews
        for zoomScrollView in zoomScrollViews {
            zoomScrollView.removeFromSuperview()
        }
        zoomScrollViews.removeAll()
        imageViews.removeAll()
        doubleTapGestureRecognizers.removeAll()

        let count = images.count
        pageControl.numberOfPages = count

        guard count > 0 else {
            return
        }

        let placeholder = UIImage(named: "img_midium") ?? UIImage(systemName: "photo")
        for _ in 0..<count {
            let zoomScrollView = UIScrollView()
            zoomScrollView.minimumZoomScale = 1.0
            zoomScrollView.maximumZoomScale = 3.0
            zoomScrollView.zoomScale = 1.0
            zoomScrollView.delegate = self
            zoomScrollView.showsHorizontalScrollIndicator = false
            zoomScrollView.showsVerticalScrollIndicator = false
            zoomScrollView.bouncesZoom = true
            zoomScrollView.backgroundColor = .black
            zoomScrollView.translatesAutoresizingMaskIntoConstraints = true

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .clear
            imageView.image = placeholder
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = true
            imageView.isUserInteractionEnabled = true

            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            doubleTap.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(doubleTap)
            doubleTapGestureRecognizers.append(doubleTap)

            zoomScrollView.addSubview(imageView)
            pagingScrollView.addSubview(zoomScrollView)

            zoomScrollViews.append(zoomScrollView)
            imageViews.append(imageView)
        }
    }

    // MARK: - Layout

    private func layoutPagingScrollView() {
        let safeBounds = view.safeAreaLayoutGuide.layoutFrame
        pagingScrollView.frame = safeBounds
        pagingScrollView.contentSize = CGSize(width: safeBounds.width * CGFloat(images.count), height: safeBounds.height)
    }

    private func layoutZoomScrollViews() {
        let safeBounds = view.safeAreaLayoutGuide.layoutFrame
        for (index, zoomScrollView) in zoomScrollViews.enumerated() {
            zoomScrollView.frame = CGRect(x: safeBounds.width * CGFloat(index),
                                          y: 0,
                                          width: safeBounds.width,
                                          height: safeBounds.height)
            zoomScrollView.zoomScale = 1.0
            zoomScrollView.contentSize = zoomScrollView.bounds.size

            let imageView = imageViews[index]
            imageView.frame = zoomScrollView.bounds
        }
    }

    // MARK: - Helpers

    private func safeStartIndex() -> Int {
        guard !images.isEmpty else { return 0 }
        if startIndex < 0 {
            return 0
        } else if startIndex >= images.count {
            return images.count - 1
        }
        return startIndex
    }

    private func scrollToPage(_ page: Int, animated: Bool) {
        let safeBounds = view.safeAreaLayoutGuide.layoutFrame
        let offsetX = safeBounds.width * CGFloat(page)
        pagingScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }

    private func resetZoomScaleForAllPages() {
        for zoomScrollView in zoomScrollViews {
            zoomScrollView.setZoomScale(1.0, animated: false)
        }
    }
    
    private func resetZoomScaleForPages(except page: Int) {
        for (index, zoomScrollView) in zoomScrollViews.enumerated() {
            if index != page {
                zoomScrollView.setZoomScale(1.0, animated: false)
            }
        }
    }

    private func preloadNeighbors(of page: Int) {
        let indices = [page - 1, page + 1].filter { $0 >= 0 && $0 < images.count }
        for i in indices {
            if let url = URL(string: images[i]) {
                SDWebImageManager.shared.loadImage(with: url, options: [.retryFailed, .continueInBackground, .highPriority], progress: nil) { _, _, _, _, _, _ in
                    // cache warmed
                }
            }
        }
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func nextTapped() {
        guard !images.isEmpty else { return }
        let nextPage = min(pageControl.currentPage + 1, images.count - 1)
        if nextPage != pageControl.currentPage {
            pageControl.currentPage = nextPage
            scrollToPage(nextPage, animated: true)
            resetZoomScaleForPages(except: nextPage)
        }
    }

    @objc private func prevTapped() {
        guard !images.isEmpty else { return }
        let prevPage = max(pageControl.currentPage - 1, 0)
        if prevPage != pageControl.currentPage {
            pageControl.currentPage = prevPage
            scrollToPage(prevPage, animated: true)
            resetZoomScaleForPages(except: prevPage)
        }
    }

    // MARK: - UIScrollViewDelegate

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // Only zoomScrollViews have zooming enabled
        guard let index = zoomScrollViews.firstIndex(of: scrollView) else {
            return nil
        }
        return imageViews[index]
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == pagingScrollView else { return }
        let width = scrollView.frame.width
        guard width > 0 else { return }
        let fractionalPage = scrollView.contentOffset.x / width
        let page = Int(round(fractionalPage))
        if pageControl.currentPage != page && page >= 0 && page < images.count {
            pageControl.currentPage = page
            resetZoomScaleForPages(except: page)
            preloadNeighbors(of: page)
        }
    }

    // MARK: - Gesture Handlers
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        guard let imageView = gesture.view as? UIImageView else { return }
        guard let zoomScroll = imageView.superview as? UIScrollView else { return }
        let currentZoom = zoomScroll.zoomScale
        let targetZoom: CGFloat = currentZoom > 1.0 ? 1.0 : 2.5
        if targetZoom > currentZoom {
            let pointInView = gesture.location(in: imageView)
            let size = CGSize(width: zoomScroll.bounds.size.width / targetZoom,
                              height: zoomScroll.bounds.size.height / targetZoom)
            let origin = CGPoint(x: pointInView.x - size.width/2, y: pointInView.y - size.height/2)
            let rect = CGRect(origin: origin, size: size)
            zoomScroll.zoom(to: rect, animated: true)
        } else {
            zoomScroll.setZoomScale(targetZoom, animated: true)
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        // Allow vertical swipe to dismiss. Horizontal pans should be left to paging.
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        switch gesture.state {
        case .changed:
            // Only move vertically, damp the movement.
            let y = max(0, translation.y)
            let alpha = max(0.2, 1 - (y / view.bounds.height))
            self.view.transform = CGAffineTransform(translationX: 0, y: y)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        case .ended, .cancelled:
            let shouldDismiss = translation.y > view.bounds.height * 0.25 || velocity.y > 1200
            if shouldDismiss {
                self.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.transform = .identity
                    self.view.backgroundColor = .black
                })
            }
        default:
            break
        }
    }

    // MARK: - Image Loading

    private func loadRemoteImage(from urlString: String, into imageView: UIImageView) {
        let placeholder = UIImage(named: "img_midium") ?? UIImage(systemName: "photo")
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = placeholder

        guard !urlString.isEmpty else {
            print("[ImageViewerVC] Invalid URL string: empty")
            return
        }

        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encoded) else {
            print("[ImageViewerVC] Invalid URL string: \(urlString)")
            return
        }

        setImageWithSDWebImage(into: imageView, from: url, placeholder: placeholder)
    }
    
    private func setImageWithSDWebImage(into imageView: UIImageView, from url: URL, placeholder: UIImage? = UIImage(named: "img_midium")) {
        imageView.contentMode = .center
        imageView.image = placeholder
        imageView.sd_setImage(with: url, placeholderImage: placeholder, options: [.retryFailed, .continueInBackground, .highPriority]) { [weak imageView] image, error, _, _ in
            print("Loaded: \(url)")

               print("Image: \(String(describing: image))")

               print("Error: \(String(describing: error))")
            if let error = error {
                print("SDWebImage load failed: \(error.localizedDescription) for URL: \(url)")
                imageView?.image = placeholder
                imageView?.contentMode = .center
                return
            }
            if image != nil {
                imageView?.contentMode = .scaleAspectFit
            } else {
                imageView?.image = placeholder
                imageView?.contentMode = .center
            }
        }
    }
}

