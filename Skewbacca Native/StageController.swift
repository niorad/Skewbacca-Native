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
            print($0.keyCode)
            let kc = $0.keyCode
            let mouse = self.view.convert(CGPoint(x:self.location.x, y:self.location.y), from: nil)

            let imageWidth = self.imageStage.image!.size.width
            let imageHeight = self.imageStage.image!.size.height

            let viewWidth = self.view.frame.width
            let viewHeight = self.view.frame.height

            let percX = mouse.x / viewWidth
            let percY = mouse.y / viewHeight

            let pointOnImageX = imageWidth * percX
            let pointOnImageY = imageHeight * percY

            print(pointOnImageX)
            print(pointOnImageY)

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

    func getImage() -> NSImage {
        return imageStage.image!
    }

    func getImageCoordinates() {
    }

    
}
