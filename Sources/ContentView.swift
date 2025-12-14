import SwiftUI
import UniformTypeIdentifiers
import Foundation
import UIKit

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPhone14,7":                                    return "iPhone 14"
            case "iPhone14,8":                                    return "iPhone 14 Plus"
            case "iPhone15,2":                                    return "iPhone 14 Pro"
            case "iPhone15,3":                                    return "iPhone 14 Pro Max"
            case "iPhone15,4":                                    return "iPhone 15"
            case "iPhone15,5":                                    return "iPhone 15 Plus"
            case "iPhone16,1":                                    return "iPhone 15 Pro"
            case "iPhone16,2":                                    return "iPhone 15 Pro Max"
            case "iPhone17,3":                                    return "iPhone 16"
            case "iPhone17,4":                                    return "iPhone 16 Plus"
            case "iPhone17,1":                                    return "iPhone 16 Pro"
            case "iPhone17,2":                                    return "iPhone 16 Pro Max"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad13,18", "iPad13,19":                        return "iPad (10th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
            case "iPad14,8", "iPad14,9":                          return "iPad Air (11-inch) (M2)"
            case "iPad14,10", "iPad14,11":                        return "iPad Air (13-inch) (M2)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad16,1", "iPad16,2":                          return "iPad mini (A17 Pro)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad14,3", "iPad14,4":                          return "iPad Pro (11-inch) (4th generation)"
            case "iPad16,3", "iPad16,4":                          return "iPad Pro (11-inch) (M4)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "iPad14,5", "iPad14,6":                          return "iPad Pro (12.9-inch) (6th generation)"
            case "iPad16,5", "iPad16,6":                          return "iPad Pro (13-inch) (M4)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2", "AppleTV11,1", "AppleTV14,1": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #elseif os(visionOS)
            switch identifier {
            case "RealityDevice14,1": return "Apple Vision Pro"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

func getBuildNumber() -> String? {
    var size: size_t = 0
    let ctlKey = "kern.osversion"
    
    if sysctlbyname(ctlKey, nil, &size, nil, 0) == -1 {
        return nil
    }
    
    var machine = [CChar](repeating: 0, count: Int(size))
    if sysctlbyname(ctlKey, &machine, &size, nil, 0) == -1 {
        return nil
    }
    
    return String(cString: machine)
}

func getKernelVersion() -> String? {
    var size: size_t = 0
    let ctlKey = "kern.version"
    
    if sysctlbyname(ctlKey, nil, &size, nil, 0) == -1 {
        return nil
    }
    
    var kernelVersion = [CChar](repeating: 0, count: Int(size))
    if sysctlbyname(ctlKey, &kernelVersion, &size, nil, 0) == -1 {
        return nil
    }
    
    return String(cString: kernelVersion)
}

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var pairingFile: String?
    @State var mbdb: Backup?
    @State var heartbeatReady = false
    @State var ddiMounted = false
    @State var showPairingFileImporter = false
    @State var showErrorAlert = false
    @State var taskRunning = false
    @State var initError: String?
    @State var lastError: String?
    @State var path = NavigationPath()
    let modelName = UIDevice.modelName
    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section {
                    HStack {
                        Text("Trậng thái Heartbeat")
                        Spacer()
                        Text(heartbeatReady ? AttributedString("Đang chạy", attributes: .init([.foregroundColor: UIColor.systemGreen])) : AttributedString("Chưa bắt đầu", attributes: .init([.foregroundColor: UIColor.systemRed])))
                    }
                    HStack {
                        Text("Nhà phát triển")
                        Spacer()
                        Text(ddiMounted ? AttributedString("đã có", attributes: .init([.foregroundColor: UIColor.systemGreen])) : AttributedString("chưa có", attributes: .init([.foregroundColor: UIColor.systemRed])))
                    }
                    Button(pairingFile == nil ? "Chọn tệp ghép nối" : "Đặt lại tệp ghép nối") {
                        if pairingFile == nil {
                            showPairingFileImporter.toggle()
                        } else {
                            pairingFile = nil
                        }
                    }
                    .dropDestination(for: Data.self) { items, location in
                        guard let item = items.first else { return false }
                        pairingFile = String(decoding: item, as: UTF8.self)
                        guard pairingFile?.contains("DeviceCertificate") ?? false else {
                            lastError = "Tệp bạn vừa thả không phải là tệp ghép nối"
                            showErrorAlert.toggle()
                            pairingFile = nil
                            return false
                        }
                        savePairingFile()
                        startHeartbeat()
                        return true
                    }
                } footer: {
                    if pairingFile == nil {
                        Text("Chọn hoặc kéo và thả tệp ghép nối để tiếp tục. Thêm thông tin: https://docs.sidestore.io/docs/getting-started/pairing-file")
                    } else if !heartbeatReady {
                        Text("Đang bắt đầu Heartbeat")
                    } else if !ddiMounted {
                        HStack {
                            Text("Hình ảnh đĩa dành cho nhà phát triển không được gắn kết. Vui lòng mở StikDebug để gắn nó để tiếp tục.")
                        }
                    } else {
                        Text("Đã chọn tệp ghép nối")
                    }
                }
                
                if !ddiMounted {
                    Section {
                        Button("Mở StikDebug") {
                            if let url = URL(string: "stikjit://") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                
                Section {
                    NavigationLink("Ứng dụng đã cài đặt") {
                        AppListView()
                    }
                    .disabled(!ddiMounted)
                } header: {
                    //Text("Utilities")
                }
                Section {
                    NavigationLink("Tuỳ chỉnh MobileGestalt") {
                        MobileGestaltView()
                    }
                    .disabled(!ddiMounted)
                    
                    let tempUnavailable = true
                    Button("Bỏ qua giới hạn 3 ứng dụng (sắp có)") {
                        testBypassAppLimit()
                    }
                    .disabled(tempUnavailable || Restore.supportedExploitLevel() != .dotAndSlashes || !heartbeatReady || taskRunning)
                } header: {
                    //Text("BookRestore exploit")
                }footer: {
                    Text(
                        "Ẩn các ứng dụng dành cho nhà phát triển miễn phí khỏi cài đặt, để bạn có thể cài đặt nhiều hơn 3 ứng dụng. Bạn cần áp dụng điều này cho mỗi 3 ứng dụng bạn cài đặt hoặc cập nhật." +
                        "\nTính năng này hiện không khả dụng khi sử dụng thư viện idevice." +
                        (Restore.supportedExploitLevel() == .dotAndSlashes ? "" : "\nPhiên bản iOS của bạn (\(UIDevice.current.systemVersion)) sắp được hộ trợ")
                    )
                }


                
                /*Section {
                    let tempUnavailable = true
                    Button("Bỏ qua giới hạn 3 ứng dụng (sắp có)") {
                        testBypassAppLimit()
                    }
                    .disabled(tempUnavailable || Restore.supportedExploitLevel() != .dotAndSlashes || !heartbeatReady || taskRunning)
                } header: {
                    Text("SparseRestore exploit")
                } footer: {
                    Text(
                        "Hide free developer apps from installd, so you could install more than 3 apps. You need to apply this for each 3 apps you install or update." +
                        "\nThis feature is currently unavailable when using idevice library." +
                        (Restore.supportedExploitLevel() == .dotAndSlashes ? "" : "\nYour iOS version (\(UIDevice.current.systemVersion)) does not support SparseRestore.")
                    )
                }*/
                /*Section {
                } footer: {
                    VStack {
                        /*Text("""
A terrible app by @khanhduytran0. Use it at your own risk.
Thanks to:
@SideStore team: idevice, C bindings from StikDebug
@JJTech0130: SparseRestore and backup exploit
@hanakim3945: bl_sbx exploit files and writeup
@PoomSmart: MobileGestalt dump
@Lakr233: BBackupp
@libimobiledevice
""")*/
                    }
                }*/
            }
            .fileImporter(isPresented: $showPairingFileImporter, allowedContentTypes: [UTType(filenameExtension: "mobiledevicepairing", conformingTo: .data)!], onCompletion: { result in
                switch result {
                case .success(let url):
                    pairingFile = try! String(contentsOf: url)
                    savePairingFile()
                    startHeartbeat()
                case .failure(let error):
                    lastError = error.localizedDescription
                    showErrorAlert.toggle()
                }
            })
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") {}
            } message: {
                Text(lastError ?? "???")
            }
            .navigationDestination(for: String.self) { view in
                if view == "Apply3AppLimitBypass" {
                    Text("TODO")
                } else {
                    Text("Unknown view: \(view)")
                }
            }
            .navigationTitle("SaiGon Toolkit")
        }
        .onAppear {
            if initError != nil {
                lastError = initError
                initError = nil
                showErrorAlert.toggle()
                return
            }
            
            if pairingFile == nil {
                pairingFile = try? String(contentsOf: URL.documentsDirectory.appendingPathComponent("pairingFile.plist"))
            }
            
            if let altPairingFile = Bundle.main.object(forInfoDictionaryKey: "ALTPairingFile") as? String, altPairingFile.count > 5000, pairingFile == nil {
                pairingFile = altPairingFile
                savePairingFile()
            }
            
            if pairingFile != nil {
                startHeartbeat()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            // keep HTTP server alive in the background for a while
            if scenePhase == .inactive {
                Utils.bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                    // This executes when time is about to run out
                    UIApplication.shared.endBackgroundTask(Utils.bgTask)
                    Utils.bgTask = .invalid
                })
                if Utils.bgTask == .invalid {
                    print("Failed to start background task")
                    return
                }
            } else if scenePhase == .active {
                if Utils.bgTask != .invalid {
                    UIApplication.shared.endBackgroundTask(Utils.bgTask)
                    Utils.bgTask = .invalid
                }
            }
        }
    }
    
    func savePairingFile() {
        try? pairingFile?.write(to: URL.documentsDirectory.appendingPathComponent("pairingFile.plist"), atomically: true, encoding: .utf8)
    }

    func testBypassAppLimit() {
        guard Restore.supportedExploitLevel() == .dotAndSlashes else {
            lastError = "Unsupported iOS version. Must be running iOS 18.1b4 or older."
            showErrorAlert.toggle()
            return
        }
        Task {
            taskRunning = true
            mbdb = Restore.createBypassAppLimit()
            path.append("Apply3AppLimitBypass")
            taskRunning = false
        }
    }
    
    func startHeartbeat() {
        guard pairingFile != nil else {
            return
        }
        //let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
        DispatchQueue.global(qos: .background).async {
            print("Heartbeat: starting...")
            let completionHandler: @convention(block) (Int32, String?) -> Void = { result, message in
                if result == 0 {
                    heartbeatReady = true
                    print("Heartbeat started successfully: \(message ?? "")")
                    
                    // quick way to check if DDI is mounted
                    let ddiPath: String
                    if #available(iOS 17.0, *) {
                        ddiPath = "/System/Developer/Library"
                    } else {
                        ddiPath = "/Developer/Library"
                    }
                    ddiMounted = FileManager.default.fileExists(atPath: ddiPath)
                    
                    // TODO: mount DDI
                    //                        pubHeartBeat = true
                    //
                    //                        if FileManager.default.fileExists(atPath: URL.documentsDirectory.appendingPathComponent("DDI/Image.dmg.trustcache").path) {
                    //                            MountingProgress.shared.pubMount()
                    //                        }
                } else {
                    print("Error: \(message ?? "") (Code: \(result))")
                    DispatchQueue.main.async {
                        if result == -9 {
                            do {
                                try FileManager.default.removeItem(at: URL.documentsDirectory.appendingPathComponent("pairingFile.plist"))
                                print("Removed invalid pairing file")
                            } catch {
                                print("Error removing invalid pairing file: \(error)")
                            }
                            
                            lastError = "The pairing file is invalid or expired. Please select a new pairing file."
                            showErrorAlert.toggle()
                        } else {
                            lastError = "Failed to connect to Heartbeat (\(result)). Are you connected to WiFi or is Airplane Mode enabled? Cellular data isn’t supported. Please launch the app at least once with WiFi enabled. After that, you can switch to cellular data to turn on the VPN, and once the VPN is active you can use Airplane Mode."
                            showErrorAlert.toggle()
                        }
                    }
                }
            }
            JITEnableContext.shared.startHeartbeat(completionHandler: completionHandler, logger: nil)
        }
    }
    
    func performApply3AppLimitBypass() {
        lastError = "3 app limit bypass is temporarily disabled."
        showErrorAlert.toggle()
        /*
        let deviceList = MobileDevice.deviceList()
        guard deviceList.count == 1 else {
            print("Invalid device count: \(deviceList.count)")
            return
        }
        Utils.udid = deviceList.first!
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = documentsDirectory.appendingPathComponent(Utils.udid, conformingTo: .data)
        try? FileManager.default.removeItem(at: folder)
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: false)
            try mbdb!.writeTo(directory: folder)
            // Restore now
            let restoreArgs = [
                "idevicebackup2",
                "-n", "restore", "--no-reboot", "--system",
                documentsDirectory.path(percentEncoded: false)
            ]
            print("Executing args: \(restoreArgs)")
            var argv = restoreArgs.map{ strdup($0) }
            let result = 0 //idevicebackup2_main(Int32(restoreArgs.count), &argv)
            print("idevicebackup2 exited with code \(result)")
            
            print()
            let log = GLOBAL_LOG.text
            if log.contains("Domain name cannot contain a slash") {
                print("Result: this iOS version is not supported.")
            } else if log.contains("crash_on_purpose") || result == 0 {
                print("Result: restore successful.")
                if reboot {
                    //MobileDevice.rebootDevice(udid: Utils.udid)
                }
            }
            
            logPipe.fileHandleForReading.readabilityHandler = nil
        } catch {
            print(error.localizedDescription)
            return
        }
         */
    }
    
    func ready() -> Bool {
        heartbeatReady
    }
}
