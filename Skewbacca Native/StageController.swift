import Cocoa


class StageController: NSViewController {

    @IBOutlet var topLeft: NSImageView!
    @IBOutlet var bottomRight: NSImageView!
    @IBOutlet var bottomLeft: NSImageView!
    @IBOutlet var topRight: NSImageView!

    @IBOutlet weak var imageStage: NSImageView!

    var coordinates = Coordinates(
        TL: CIVector(x: 0, y: 0),
        TR: CIVector(x: 0, y: 0),
        BL: CIVector(x: 0, y: 0),
        BR: CIVector(x: 0, y: 0)
    )

    lazy var window: NSWindow = self.view.window!
    var location: NSPoint {
        return window.mouseLocationOutsideOfEventStream
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let nc = NotificationCenter.default

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {

            let kc = $0.keyCode
            let mouse = self.view.convert(CGPoint(x:self.location.x, y:self.location.y), from: nil)

            if(kc == 18) {
                let handleSize = self.topLeft.frame.width
                let handleOffset = handleSize / -2
                self.updateImageCoordinatesAt(.TL, x: mouse.x, y: mouse.y)
                self.topLeft.frame.origin = CGPoint(x: mouse.x + handleOffset, y: mouse.y + handleOffset)
            } else if(kc == 19) {
                let handleSize = self.topRight.frame.width
                let handleOffset = handleSize / -2
                self.updateImageCoordinatesAt(.TR, x: mouse.x, y: mouse.y)
                self.topRight.frame.origin = CGPoint(x: mouse.x + handleOffset, y: mouse.y + handleOffset)
            } else if(kc == 20) {
                let handleSize = self.bottomLeft.frame.width
                let handleOffset = handleSize / -2
                self.updateImageCoordinatesAt(.BL, x: mouse.x, y: mouse.y)
                self.bottomLeft.frame.origin = CGPoint(x: mouse.x + handleOffset, y: mouse.y + handleOffset)
            } else if(kc == 21) {
                let handleSize = self.bottomRight.frame.width
                let handleOffset = handleSize / -2
                self.updateImageCoordinatesAt(.BR, x: mouse.x, y: mouse.y)
                self.bottomRight.frame.origin = CGPoint(x: mouse.x + handleOffset, y: mouse.y + handleOffset)
            } else {
                self.keyDown(with: $0)
            }
            nc.post(name: Notification.Name("SelectionChanged"), object: nil)
            return nil
        }


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

    func getImage() -> NSImage {
        return imageStage.image!
    }

    func setImage(_ url: URL) {
        let newImage = NSImage(byReferencing: url)
        self.imageStage.image = newImage
    }

    func updateHandlePositions() {
        topLeft.frame.origin = CGPoint(x: coordinates.TL.x, y: coordinates.TL.y)
        topRight.frame.origin = CGPoint(x: coordinates.TR.x, y: coordinates.TR.y)
        bottomLeft.frame.origin = CGPoint(x: coordinates.BL.x, y: coordinates.BL.y)
        bottomRight.frame.origin = CGPoint(x: coordinates.BR.x, y: coordinates.BR.y)
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

//        self.coordinates = Coordinates(
//            TL: handleToImageCoordinate(self.topLeft.frame.origin),
//            TR: handleToImageCoordinate(self.topRight.frame.origin),
//            BL: handleToImageCoordinate(self.bottomLeft.frame.origin),
//            BR: handleToImageCoordinate(self.bottomRight.frame.origin)
//        )
    }


    func getImageCoordinates() -> Coordinates {
        return self.coordinates
    }

    
}
