import Cocoa


class StageController: NSViewController {

    @IBOutlet var topLeft: NSImageView!
    @IBOutlet var bottomRight: NSImageView!
    @IBOutlet var bottomLeft: NSImageView!
    @IBOutlet var topRight: NSImageView!

    @IBOutlet weak var imageStage: NSImageView!

    var coordinates = Coordinates(
        TL: CIVector(x: 100, y: 300),
        TR: CIVector(x: 300, y: 300),
        BL: CIVector(x: 100, y: 100),
        BR: CIVector(x: 300, y: 100)
    )

    lazy var window: NSWindow = self.view.window!
    var location: NSPoint {
        return window.mouseLocationOutsideOfEventStream
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        imageStage.layer?.backgroundColor = CGColor.black
        let nc = NotificationCenter.default
        self.updateHandlePositions()
        self.offsetHandlePositions()

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {

            let kc = $0.keyCode
            let mouse = self.view.convert(CGPoint(x:self.location.x, y:self.location.y), from: nil)

            if(kc == 18) {
                self.updateImageCoordinatesAt(.TL, x: mouse.x, y: mouse.y)
            } else if(kc == 19) {
                self.updateImageCoordinatesAt(.TR, x: mouse.x, y: mouse.y)
            } else if(kc == 20) {
                self.updateImageCoordinatesAt(.BL, x: mouse.x, y: mouse.y)
            } else if(kc == 21) {
                self.updateImageCoordinatesAt(.BR, x: mouse.x, y: mouse.y)
            } else {
                self.keyDown(with: $0)
            }
            self.updateHandlePositions()
            self.offsetHandlePositions()

            nc.post(name: Notification.Name("SelectionChanged"), object: nil)
            return nil
        }
        nc.post(name: Notification.Name("SelectionChanged"), object: nil)
    }


    func handleToImageCoordinate(_ coord: CGPoint) -> CIVector {

        let imageWidth = self.imageStage.image!.size.width
        let imageHeight = self.imageStage.image!.size.height
        let imgIsLandscape = imageWidth >= imageHeight

        var viewWidth = self.view.frame.width
        var viewHeight = self.view.frame.height

        if(imgIsLandscape) {
            viewHeight = viewHeight * (imageHeight / imageWidth)
        } else {
            viewWidth = viewWidth * (imageWidth / imageHeight)
        }

        let percX = coord.x / viewWidth
        let percY = coord.y / viewHeight

        let pointOnImageX = imageWidth * percX
        let pointOnImageY = imageHeight * percY

        return CIVector(cgPoint: CGPoint(x: pointOnImageX, y: pointOnImageY))
    }


    func imageToHandleCoordinate(_ coord: CIVector) -> CGPoint {

        let imageWidth = self.imageStage.image!.size.width
        let imageHeight = self.imageStage.image!.size.height
        let imgIsLandscape = imageWidth >= imageHeight

        var viewWidth = self.view.frame.width
        var viewHeight = self.view.frame.height

        if(imgIsLandscape) {
            viewHeight = viewHeight * (imageHeight / imageWidth)
        } else {
            viewWidth = viewWidth * (imageWidth / imageHeight)
        }

        let percX = coord.x / imageWidth
        let percY = coord.y / imageHeight

        let pointOnViewX = viewWidth * percX
        let pointOnViewY = viewHeight * percY

        return CGPoint(x: pointOnViewX, y: pointOnViewY)

    }


    func getImage() -> NSImage {
        return imageStage.image!
    }

    
    func setImage(_ url: URL) {
        let newImage = NSImage(byReferencing: url)
        self.imageStage.image = newImage
    }


    func updateHandlePositions() {
        topLeft.frame.origin = imageToHandleCoordinate(coordinates.TL)
        topRight.frame.origin = imageToHandleCoordinate(coordinates.TR)
        bottomLeft.frame.origin = imageToHandleCoordinate(coordinates.BL)
        bottomRight.frame.origin = imageToHandleCoordinate(coordinates.BR)
    }


    func offsetHandlePositions() {
        let handleSize = self.topLeft.frame.width
        let handleOffset = handleSize / -2
        topLeft.frame.origin.x += handleOffset
        topLeft.frame.origin.y += handleOffset
        topRight.frame.origin.x += handleOffset
        topRight.frame.origin.y += handleOffset
        bottomLeft.frame.origin.x += handleOffset
        bottomLeft.frame.origin.y += handleOffset
        bottomRight.frame.origin.x += handleOffset
        bottomRight.frame.origin.y += handleOffset
    }


    func updateImageCoordinatesAt(_ direction: Directions, x: CGFloat, y: CGFloat) {
        switch direction {
        case .TL:
            self.coordinates.TL = self.handleToImageCoordinate(CGPoint(x: x, y: y))
        case .TR:
            self.coordinates.TR = self.handleToImageCoordinate(CGPoint(x: x, y: y))
        case .BL:
            self.coordinates.BL = self.handleToImageCoordinate(CGPoint(x: x, y: y))
        case .BR:
            self.coordinates.BR = self.handleToImageCoordinate(CGPoint(x: x, y: y))
        }
    }


    func getImageCoordinates() -> Coordinates {
        return self.coordinates
    }

    
}
