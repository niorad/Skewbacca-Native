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

    @IBAction func onTopLeftClicked(_ sender: Any) {
        print("yo")
        print(handleTopLeft.frame)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            print($0.keyCode)
            let kc = $0.keyCode
            let mouse = self.view.convert(CGPoint(x:self.location.x,y:self.location.y), from: nil)

            if(kc == 18) {
                print("TOPLEFT")
                self.handleTopLeft.frame.origin = mouse
            } else if(kc == 19) {
                print("TOPRIGHT")
                self.handleTopRight.frame.origin = mouse
            } else if(kc == 20) {
                print("BOTTOMLEFT")
                self.handleBottomLeft.frame.origin = mouse
            } else if(kc == 21) {
                print("BOTTOMRIGHT")
                self.handleBottomRight.frame.origin = mouse
            }
            return $0
        }

    }

    func getImage() -> NSImage {
        return imageStage.image!
    }

    
}
