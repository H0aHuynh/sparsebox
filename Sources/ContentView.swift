import SwiftUI
import UniformTypeIdentifiers
import Foundation
import UIKit


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
                        Text("Trậng thái Heartbeat:")
                        Spacer()
                        Text(heartbeatReady ? AttributedString("Đang chạy", attributes: .init([.foregroundColor: UIColor.systemGreen])) : AttributedString("Chưa bắt đầu", attributes: .init([.foregroundColor: UIColor.systemRed])))
                    }
                    HStack {
                        Text("Nhà phát triển:")
                        Spacer()
                        Text(ddiMounted ? AttributedString("Đã có", attributes: .init([.foregroundColor: UIColor.systemGreen])) : AttributedString("Chưa có", attributes: .init([.foregroundColor: UIColor.systemRed])))
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
                        Text("Chọn hoặc kéo và thả tệp ghép nối để tiếp tục")
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
                } footer: {
                    Text(
                        "Ẩn các ứng dụng dành cho nhà phát triển miễn phí khỏi cài đặt, để bạn có thể cài đặt nhiều hơn 3 ứng dụng. Bạn cần áp dụng điều này cho mỗi 3 ứng dụng bạn cài đặt hoặc cập nhật." +
                        "\nTính năng này hiện không khả dụng khi sử dụng thư viện idevice." +
                        (Restore.supportedExploitLevel() == .dotAndSlashes ? "" : "\nPhiên bản iOS của bạn (\(UIDevice.current.systemVersion)) sắp được hộ trợ")
                    )
                }

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
            .alert("Lỗi", isPresented: $showErrorAlert) {
                Button("OK") {}
            } message: {
                Text(lastError ?? "???")
            }
            .navigationDestination(for: String.self) { view in
                if view == "Apply3AppLimitBypass" {
                    Text("TODO")
                } else {
                    Text("Không xác định: \(view)")
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
                    print("Không thể khởi động tác vụ nền.")
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
            lastError = "Phiên bản iOS không được hỗ trợ. Phải đang sử dụng iOS 18.1b4 trở xuống."
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
            print("Heartbeat: bắt đầu...")
            let completionHandler: @convention(block) (Int32, String?) -> Void = { result, message in
                if result == 0 {
                    heartbeatReady = true
                    print("Heartbeat đã bắt đầu thành công: \(message ?? "")")
                    
                    // quick way to check if DDI is mounted
                    let ddiPath: String
                    if #available(iOS 17.0, *) {
                        ddiPath = "/System/Developer/Library"
                    } else {
                        ddiPath = "/Developer/Library"
                    }
                    ddiMounted = FileManager.default.fileExists(atPath: ddiPath)

                } else {
                    print("Lỗi: \(message ?? "") (Code: \(result))")
                    DispatchQueue.main.async {
                        if result == -9 {
                            do {
                                try FileManager.default.removeItem(at: URL.documentsDirectory.appendingPathComponent("pairingFile.plist"))
                                print("Đã xóa tệp ghép nối không hợp lệ")
                            } catch {
                                print("Lỗi khi xóa tệp ghép nối không hợp lệ: \(error)")
                            }
                            
                            lastError = "Tệp ghép nối không hợp lệ hoặc đã hết hạn. Vui lòng chọn tệp ghép nối mới.."
                            showErrorAlert.toggle()
                        } else {
                            lastError = "Không thể kết nối đến Heartbeat (\(result)). Bạn có đang kết nối với WiFi hay Chế độ máy bay đã được bật chưa? Dữ liệu di động không được hỗ trợ. Vui lòng mở ứng dụng ít nhất một lần khi đã bật WiFi. Sau đó, bạn có thể chuyển sang dữ liệu di động để bật VPN, và khi VPN được kích hoạt, bạn có thể sử dụng Chế độ máy bay."
                            showErrorAlert.toggle()
                        }
                    }
                }
            }
            JITEnableContext.shared.startHeartbeat(completionHandler: completionHandler, logger: nil)
        }
    }
    
    func performApply3AppLimitBypass() {
        lastError = "Chức năng bỏ qua giới hạn 3 ứng dụng hiện đang tạm thời bị vô hiệu hóa."
        showErrorAlert.toggle()
    }
    
    func ready() -> Bool {
        heartbeatReady
    }
}
