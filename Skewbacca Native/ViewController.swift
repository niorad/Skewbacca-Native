import Cocoa

class ViewController: NSViewController {


    @IBOutlet weak var sourceImageView: NSImageView!
    @IBOutlet weak var targetImageView: NSImageView!

    @IBOutlet weak var valueTLX: NSTextField!
    @IBOutlet weak var valueTLY: NSTextField!
    @IBOutlet weak var valueBLX: NSTextField!
    @IBOutlet weak var valueBLY: NSTextField!
    @IBOutlet weak var valueTRX: NSTextField!
    @IBOutlet weak var valueTRY: NSTextField!
    @IBOutlet weak var valueBRX: NSTextField!
    @IBOutlet weak var valueBRY: NSTextField!

    let context = CIContext()


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var representedObject: Any? {
        didSet {
        }
    }

    func perspectiveFilter(_ input: CIImage) -> CIImage?
    {
        let pf = CIFilter(name:"CIPerspectiveCorrection")

        pf!.setValue(input, forKey: "inputImage")
        pf!.setValue(CIVector(x: CGFloat(valueTLX!.integerValue), y: CGFloat(valueTLY!.integerValue)), forKey: "inputTopLeft")
        pf!.setValue(CIVector(x: CGFloat(valueTRX!.integerValue), y: CGFloat(valueTRY!.integerValue)), forKey: "inputTopRight")
        pf!.setValue(CIVector(x: CGFloat(valueBLX!.integerValue), y: CGFloat(valueBLY!.integerValue)), forKey: "inputBottomLeft")
        pf!.setValue(CIVector(x: CGFloat(valueBRX!.integerValue), y: CGFloat(valueBRY!.integerValue)), forKey: "inputBottomRight")

        return pf!.outputImage
    }


    @IBAction func onConvertClicked(_ sender: Any) {

        let cgImageFromView = sourceImageView.image?.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let ciImage = CIImage(cgImage: cgImageFromView!)
        let newImage = self.perspectiveFilter(ciImage)
        let rep: NSCIImageRep = NSCIImageRep(ciImage: newImage!)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        targetImageView.image = nsImage

    }

}

