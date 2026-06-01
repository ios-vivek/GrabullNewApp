import UIKit

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

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        configureImages()
        pageControl.currentPage = safeStartIndex()
        scrollToPage(pageControl.currentPage, animated: false)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutPagingScrollView()
        layoutZoomScrollViews()
        scrollToPage(pageControl.currentPage, animated: false)
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

        let count = images.count
        pageControl.numberOfPages = count

        guard count > 0 else {
            return
        }

        for _ in 0..<count {
            let zoomScrollView = UIScrollView()
            zoomScrollView.minimumZoomScale = 1.0
            zoomScrollView.maximumZoomScale = 3.0
            zoomScrollView.delegate = self
            zoomScrollView.showsHorizontalScrollIndicator = false
            zoomScrollView.showsVerticalScrollIndicator = false
            zoomScrollView.bouncesZoom = true
            zoomScrollView.backgroundColor = .black
            zoomScrollView.translatesAutoresizingMaskIntoConstraints = false

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .black
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.isUserInteractionEnabled = false

            zoomScrollView.addSubview(imageView)
            pagingScrollView.addSubview(zoomScrollView)

            zoomScrollViews.append(zoomScrollView)
            imageViews.append(imageView)
        }

        // Load images asynchronously
        for (index, urlString) in images.enumerated() {
            loadRemoteImage(from: urlString, into: imageViews[index])
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
            resetZoomScaleForAllPages()
        }
    }

    @objc private func prevTapped() {
        guard !images.isEmpty else { return }
        let prevPage = max(pageControl.currentPage - 1, 0)
        if prevPage != pageControl.currentPage {
            pageControl.currentPage = prevPage
            scrollToPage(prevPage, animated: true)
            resetZoomScaleForAllPages()
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
            resetZoomScaleForAllPages()
        }
    }

    // MARK: - Image Loading

    private func loadRemoteImage(from urlString: String, into imageView: UIImageView) {
        imageView.backgroundColor = .black
        imageView.image = nil
        guard let url = URL(string: urlString) else {
            return
        }

        // Cancel any previous task associated with this imageView
        // Not strictly required here as image views are reused only on new setup

        URLSession.shared.dataTask(with: url) { [weak imageView] data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                imageView?.image = image
            }
        }.resume()
    }
}
