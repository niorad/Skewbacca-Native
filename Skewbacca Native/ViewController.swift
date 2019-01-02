import Cocoa

class ViewController: NSViewController {


    @IBOutlet weak var targetImageView: NSImageView!
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

    func perspectiveFilter(_ input: CIImage, _ coords: Coordinates) -> CIImage?
    {
        let pf = CIFilter(name:"CIPerspectiveCorrection")

        pf!.setValue(input, forKey: "inputImage")
        pf!.setValue(coords.TL, forKey: "inputTopLeft")
        pf!.setValue(coords.TR, forKey: "inputTopRight")
        pf!.setValue(coords.BL, forKey: "inputBottomLeft")
        pf!.setValue(coords.BR, forKey: "inputBottomRight")

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
        let unskewedImage = self.perspectiveFilter(ciImage, stageViewController!.getImageCoordinates())
        let exposureSliderValue = NSNumber(value: valueExposureSlider!.doubleValue)
        let exposureCorrectedImage = self.exposureFilter(unskewedImage!, value: exposureSliderValue)
        let rep: NSCIImageRep = NSCIImageRep(ciImage: exposureCorrectedImage!)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        targetImageView.image = nsImage

    }

}

