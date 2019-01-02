import Cocoa


class StageController: NSViewController {

    @IBOutlet weak var handleTopLeft: NSButton!
    @IBOutlet weak var handleTopRight: NSButton!
    @IBOutlet weak var handleBottomLeft: NSButton!
    @IBOutlet weak var handleBottomRight: NSButton!

    @IBOutlet weak var imageStage: NSImageView!

    lazy var window: NSWindow = self.view.window!
    var location: NSPoint {
        return window.mouseLocationOutsideOfEventStream
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            let kc = $0.keyCode
            let mouse = self.view.convert(CGPoint(x:self.location.x, y:self.location.y), from: nil)

            if(kc == 18) {
                self.handleTopLeft.frame.origin = mouse
            } else if(kc == 19) {
                self.handleTopRight.frame.origin = mouse
            } else if(kc == 20) {
                self.handleBottomLeft.frame.origin = mouse
            } else if(kc == 21) {
                self.handleBottomRight.frame.origin = mouse
            }
            return $0
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

    func getImageCoordinates() -> Coordinates {
        return Coordinates(
            TL: handleToImageCoordinate(self.handleTopLeft.frame.origin),
            TR: handleToImageCoordinate(self.handleTopRight.frame.origin),
            BL: handleToImageCoordinate(self.handleBottomLeft.frame.origin),
            BR: handleToImageCoordinate(self.handleBottomRight.frame.origin)
        )
    }

    
}
