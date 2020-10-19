//
//  ExtendedController.swift
//  ExcessCash
//
//  Created by 서상의 on 2020/10/17.
//

import UIKit
import Photos

class ExtendedController: BaseController {
    
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var buttonsView: ButtonsView!
    @IBOutlet weak var subDisplayTop: NSLayoutConstraint!
    
    private var selectedButton: CalculatorButton?
    
    override func viewDidLoad() {
        buttonsView.delegate = self
        setupCustomGestures()
        super.viewDidLoad()
        callbackRegetPrice = {
            self.getPrice()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        addMenuObserverNotification()
        getPrice()
    }
    override func viewWillDisappear(_ animated: Bool) {
        removeMenuObserverNotification()
    }
    
    override func actionForNumberButton(_ sender: UIButton) {
        makeButtonDeselect(sender as? CalculatorButton)
        super.actionForNumberButton(sender)
    }
    override func actionForOperatorAddButton(_ sender: UIButton) {
        makeButtonDeselect(sender as? CalculatorButton)
        makeButtonSelected(sender as? CalculatorButton)
        super.actionForOperatorAddButton(sender)
    }
    override func actionForEqualButton(_ sender: UIButton) {
        makeButtonDeselect()
        super.actionForEqualButton(sender)
    }
    override func actionForShowButton(_ sender: UIButton) {
        makeSubDisplayDropdown()
        super.actionForShowButton(sender)
    }
    override func deepClear() {
        makeButtonDeselect()
        super.deepClear()
    }
}

private extension ExtendedController {
    func loadLastImageThumb(completion: @escaping (UIImage) -> ()) {
        let imgManager = PHImageManager.default()
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        if let last = fetchResult.lastObject {
            let size = CGSize(width: last.pixelWidth, height: last.pixelHeight)
            print("size\(size)")
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            imgManager.requestImage(for: last, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image, _) in
                if let image = image {
                    completion(image)
                }
            })
        }
        
    }
    
    func showAleart() {
        let dialogMessage = UIAlertController(title: "Can't find map", message: "Are you sure you want to try again?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Try", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            self.getPrice()
        })
        
        dialogMessage.addAction(ok)
        DispatchQueue.main.async {
            self.present(dialogMessage, animated: true, completion:nil)
        }
    }
    
    func getPrice() {
        loadLastImageThumb { (image) in
            self.callOCRSpace(image)
        }
    }
    
    func callOCRSpace(_ image: UIImage) {
        // Create URL request
        let url = URL(string: "https://api.ocr.space/Parse/Image")
        var request: URLRequest? = nil
        if let url = url {
            request = URLRequest(url: url)
        }
        request?.httpMethod = "POST"
        let boundary = "randomString"
        request?.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        // Image file and parameters
        let imageData = image.jpegData(compressionQuality: 0.6)
        let parametersDictionary = ["apikey" : "134212c55988957", "isOverlayRequired" : "True", "language" : "jpn"]
        
        // Create multipart form body
        let data = createBody(withBoundary: boundary, parameters: parametersDictionary, imageData: imageData, filename: "test.jpg")
        
        request?.httpBody = data
        
        // Start data session
        var task: URLSessionDataTask? = nil
        if let request = request {
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                var price = ""
                var responseOCR: ResponseOCR?
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        responseOCR = try decoder.decode(ResponseOCR.self, from: data)
                    }
                } catch let myError {
                    print(myError)
                }
                
                
                if let responseOCR = responseOCR,
                    let parsedResults = responseOCR.parsedResults,
                    parsedResults.count > 0,
                    let textOverlay = parsedResults.first?.textOverlay,
                    let lines = textOverlay.lines {
                    
                    lines.forEach { (line) in
                        if let lineText = line.lineText, lineText.contains("¥") {
                            price = String(lineText.dropFirst().replacingOccurrences(of: ",", with: "", options: .literal, range: nil))
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    UIPasteboard.general.string = price
                    print("price \(price)")
                    if !price.isEmpty {
                        self.setPrice(price)
                    }
                }
            })
        }
        task?.resume()
    }
    
    func createBody(withBoundary boundary: String?, parameters: [AnyHashable : Any]?, imageData data: Data?, filename: String?) -> Data? {
        var body = Data()
        if data != nil {
            if let data1 = "--\(boundary ?? "")\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let data1 = "Content-Disposition: form-data; name=\"\("file")\"; filename=\"\(filename ?? "")\"\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let data1 = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let data = data {
                body.append(data)
            }
            if let data1 = "\r\n".data(using: .utf8) {
                body.append(data1)
            }
        }
        
        for key in parameters!.keys {
            if let data1 = "--\(boundary ?? "")\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let data1 = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8) {
                body.append(data1)
            }
            if let parameter = parameters?[key], let data1 = "\(parameter)\r\n".data(using: .utf8) {
                body.append(data1)
            }
        }
        
        if let data1 = "--\(boundary ?? "")--\r\n".data(using: .utf8) {
            body.append(data1)
        }
        
        return body
    }
}

private extension ExtendedController {
    func makeSubDisplayDropdown() {
        subDisplay.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.subDisplayTop.constant = 20
            self.view.layoutIfNeeded()
        }
    }
    func setupCustomGestures() {
        makeLongPressibleView()
        makeSwipableView()
    }
    func makeLongPressibleView() {
        let longPress = makeLongPressAction(with: #selector(longPress(_:)))
        displayView.addGestureRecognizer(longPress)
    }
    func makeSwipableView() {
        let swipeToUp = makeSwipeAction(with: #selector(swipeUpSubDisplay(_:)))
        swipeToUp.direction = .up
        subDisplay.addGestureRecognizer(swipeToUp)
    }
    func makeButtonSelected(_ newButton: CalculatorButton?) {
        if let newbutton = newButton {
            newbutton.isSelected = true
            selectedButton = newbutton
        }
    }
    func makeButtonDeselect(_ newButton: CalculatorButton? = nil) {
        if let newbutton = newButton, newbutton == selectedButton { return }
        if let oldbutton = selectedButton {
            oldbutton.forceToDeselect()
            selectedButton = nil
        }
    }
}
// MARK: - Notification Center
private extension ExtendedController {
    private func removeMenuObserverNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    private func addMenuObserverNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowMenu), name: UIMenuController.willShowMenuNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideMenu), name: UIMenuController.willHideMenuNotification, object: nil)
    }
    @objc func willShowMenu() {
        mainDisplay.backgroundColor = UIColor(named: "Custom_DarkGray")
    }
    @objc func willHideMenu() {
        mainDisplay.backgroundColor = .clear
    }
}
// MARK: - Action Methods
private extension ExtendedController {
    func makeLongPressAction(with action: Selector?) -> UILongPressGestureRecognizer {
        return UILongPressGestureRecognizer(target: self, action: action)
    }
    func makeSwipeAction(with action: Selector?) -> UISwipeGestureRecognizer {
        return UISwipeGestureRecognizer(target: self, action: action)
    }
    @objc func swipeUpSubDisplay(_ recognizer: UISwipeGestureRecognizer) {
        if let _ = recognizer.view {
            UIView.animate(withDuration: 0.3) {
                self.subDisplayTop.constant = -150
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func longPress(_ recognizer: UIGestureRecognizer) {
        if let recognizedView = recognizer.view,
            recognizer.state == .began {
            mainDisplay.becomeFirstResponder()
            if #available(iOS 13.0, *) {
                UIMenuController.shared.showMenu(from: recognizedView, rect: mainDisplay.frame)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
extension ExtendedController: ButtonsViewDelegate {
    func sendSelectedButton(_ button: CalculatorButton) {
        if ["+", "−", "÷", "×"].contains(button.getButtonValue()) {
            selectedButton = button
        }
    }
}
extension UISwipeGestureRecognizer {
    func setDirection(to direction: Direction) {
        self.direction = direction
    }
}
