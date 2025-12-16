import SwiftUI

struct AppItemView: View {
    let appDetails: [String : Any]
    let bundleID: String
    var body: some View {
        Form {
            NavigationLink {
                List {
                    ForEach(Array(appDetails.keys), id: \.self) { k in
                        let v = appDetails[k] as? String
                        VStack(alignment: .leading) {
                            Text(k)
                            Text(v ?? "(không phải là String)")
                                .font(Font.footnote)
                                .textSelection(.enabled)
                        }
                    }
                }
            } label: {
                Text("Xem chi tiết ứng dụng")
            }
            Section {
                if let bundlePath = appDetails["Path"] {
                    Button("Sao chép thư mục gói ứng dụng") {
                        UIPasteboard.general.string = "file://a\(bundlePath)"
                    }
                }
                if let containerPath = appDetails["Container"] {
                    Button("Sao chép thư mục dữ liệu ứng dụng") {
                        UIPasteboard.general.string = "file://a\(containerPath)"
                    }
                }
            } header: {
                Text("Khai thác đọc tùy ý")
            } footer: {
                Text("Sau khi sao chép đường dẫn, mở Cài đặt, dán vào thanh tìm kiếm, chọn tất cả một lần nữa và nhấn Chia sẻ.\n\nChỉ hỗ trợ trên iOS ≤ 18.2b1 và iOS 26.x. Với lỗ hổng này, thư mục chỉ có thể được chia sẻ qua AirDrop.\nNếu bạn đang chia sẻ ứng dụng từ App Store, xin lưu ý rằng ứng dụng vẫn sẽ được mã hóa.")
            }
        }
        .navigationTitle((appDetails["CFBundleName"] as? String) ?? bundleID)
    }

    init(bundleID: String) {
        self.bundleID = bundleID
        self.appDetails = ["Đang tải": AnyCodable("...")]
    }

    init(appDetails: [String: Any]) {
        self.appDetails = appDetails
        self.bundleID = (appDetails["CFBundleIdentifier"] as? String) ?? ""
    }
}

struct AppListView: View {
    @State var apps: [String : [String : Any]] = [:]
    @State var appIcons: [String : UIImage] = [:]
    @State var searchString: String = ""

    var results: [String] {
        let filtered: [String]
        if searchString.isEmpty {
            filtered = Array(apps.keys)
        } else {
            filtered = apps.compactMap { key, appDetails in
                let appName = appDetails["CFBundleName"] as? String
                let appPath = appDetails["Path"] as? String
                return (appName!.contains(searchString) ||
                        appPath!.contains(searchString)) ? key : nil
            }
        }
        return filtered.sorted { a, b in
            let nameA = apps[a]!["CFBundleName"] as! String
            let nameB = apps[b]!["CFBundleName"] as! String
            return nameA < nameB
        }
    }

    var body: some View {
        List {
            ForEach(results, id: \.self) { bundleID in
                let appDetails = apps[bundleID]
                let appName = (appDetails?["CFBundleName"] as? String) ?? ""
                let appBundleID = (appDetails?["CFBundleIdentifier"] as? String) ?? ""
                NavigationLink {
                    if let details = appDetails {
                        AppItemView(appDetails: details)
                    } else {
                        AppItemView(bundleID: bundleID)
                    }
                } label: {
                    Image(uiImage: appIcons[bundleID] ?? UIImage(systemName: "app")!)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .task(id: bundleID) {
                            guard appIcons[bundleID] == nil else { return }
                            await MainActor.run {
                                appIcons[bundleID] = UIImage(systemName: "app")
                            }
                            let icon = await Task.detached(priority: .background) {
                                try? JITEnableContext.shared.getAppIcon(withBundleId: bundleID)
                            }.value
                            await MainActor.run {
                                if let icon { appIcons[bundleID] = icon }
                            }
                        }
                    VStack(alignment: .leading) {
                        Text(appName)
                        Text(appBundleID).font(Font.footnote)
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    apps = try JITEnableContext.shared.getAllAppsInfo() as! [String : [String : Any]]
                } catch {
                    apps = ["Không thể lấy danh sách ứng dụng: \(error)": [:]]
                }
            }
        }
        .searchable(text: $searchString)
        .navigationTitle("Danh sách ứng dụng")
    }
    
    init() {
        apps = ["Đang tải": [:]]
    }

}
