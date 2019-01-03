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

    func perspectiveFilter(_ input: CIImage, _ coords: Coordinates) -> CIImage? {
        let pf = CIFilter(name:"CIPerspectiveCorrection")

        pf!.setValue(input, forKey: "inputImage")
        pf!.setValue(coords.TL, forKey: "inputTopLeft")
        pf!.setValue(coords.TR, forKey: "inputTopRight")
        pf!.setValue(coords.BL, forKey: "inputBottomLeft")
        pf!.setValue(coords.BR, forKey: "inputBottomRight")

        return pf!.outputImage
    }

    func exposureFilter(_ input: CIImage, value: NSNumber) -> CIImage? {
        let pf = CIFilter(name:"CIExposureAdjust")
        pf!.setValue(input, forKey: "inputImage")
        pf!.setValue(value, forKey: "inputEV")
        return pf!.outputImage
    }

    @IBAction func onOpenClick(_ sender: Any) {
        let openDialog = NSOpenPanel()
        openDialog.title = "Open Image"
        openDialog.showsResizeIndicator = true
        if(openDialog.runModal() == NSApplication.ModalResponse.OK) {
            print(openDialog.url!)
            stageViewController!.setImage(openDialog.url!)
        } else {
            print("Opening Aborted")
        }
    }

    @IBAction func onSaveClick(_ sender: Any) {
        let saveDialog = NSSavePanel()
        saveDialog.title = "Save Lid"
        saveDialog.showsResizeIndicator = true
        saveDialog.canCreateDirectories = true
        saveDialog.showsHiddenFiles = false
        saveDialog.allowedFileTypes = ["jpg"]
        if(saveDialog.runModal() == NSApplication.ModalResponse.OK) {
            print("Modal done")
            print(saveDialog.url!)

            let img = convertImage()
            let bitmap = NSBitmapImageRep(ciImage: img)
            let data = bitmap.representation(using: .jpeg, properties: [:])


            do {
                try data?.write(to: saveDialog.url!)
            } catch {
                print("Saving faileth")
            }

        } else {
            print("Cancelled")
        }
    }

    func convertImage() -> CIImage {
        let cgImageFromView = stageViewController!.getImage().cgImage(forProposedRect: nil, context: nil, hints: nil)
        let ciImage = CIImage(cgImage: cgImageFromView!)
        let unskewedImage = self.perspectiveFilter(ciImage, stageViewController!.getImageCoordinates())
        let exposureSliderValue = NSNumber(value: valueExposureSlider!.doubleValue)
        return self.exposureFilter(unskewedImage!, value: exposureSliderValue)!
    }
    
    @IBAction func onConvertClicked(_ sender: Any) {
        let filteredImage = convertImage()
        let rep: NSCIImageRep = NSCIImageRep(ciImage: filteredImage)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        targetImageView.image = nsImage
    }

}

