import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var openMenuItem: NSMenuItem!
    @IBOutlet weak var exportMenuItem: NSMenuItem!
    var rootVC: ViewController!

    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        rootVC.onFileDraggedOnDock(filename)
        return true
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rootVC = (NSApplication.shared.mainWindow?.windowController?.contentViewController as! ViewController)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}

