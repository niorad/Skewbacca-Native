import Cocoa

class ViewController: NSViewController {


    @IBOutlet weak var targetImageView: NSImageView!

    @IBOutlet weak var valueTLX: NSTextField!
    @IBOutlet weak var valueTLY: NSTextField!
    @IBOutlet weak var valueBLX: NSTextField!
    @IBOutlet weak var valueBLY: NSTextField!
    @IBOutlet weak var valueTRX: NSTextField!
    @IBOutlet weak var valueTRY: NSTextField!
    @IBOutlet weak var valueBRX: NSTextField!
    @IBOutlet weak var valueBRY: NSTextField!
    @IBOutlet weak var valueExposureSlider: NSSlider!

    var stageViewController: StageController?
    let stageSegueIdentifier = "stageSegue"

    let context = CIContext()


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var representedObject: Any? {
        didSet {
        }
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == stageSegueIdentifier {
            if let connectStageViewController = segue.destinationController as? StageController {
                stageViewController = connectStageViewController
            }
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

    func exposureFilter(_ input: CIImage, value: NSNumber) -> CIImage?
    {
        let pf = CIFilter(name:"CIExposureAdjust")

        pf!.setValue(input, forKey: "inputImage")
        pf!.setValue(value, forKey: "inputEV")

        return pf!.outputImage
    }


    @IBAction func onConvertClicked(_ sender: Any) {

        let cgImageFromView = stageViewController!.getImage().cgImage(forProposedRect: nil, context: nil, hints: nil)
        let ciImage = CIImage(cgImage: cgImageFromView!)
        let unskewedImage = self.perspectiveFilter(ciImage)
        let exposureSliderValue = NSNumber(value: valueExposureSlider!.doubleValue)
        let exposureCorrectedImage = self.exposureFilter(unskewedImage!, value: exposureSliderValue)
        let rep: NSCIImageRep = NSCIImageRep(ciImage: exposureCorrectedImage!)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        targetImageView.image = nsImage

    }

}

