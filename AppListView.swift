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
                            Text(v ?? "(not a String)")
                                .font(Font.footnote)
                                .textSelection(.enabled)
                        }
                    }
                }
            } label: {
                Text("View app details")
            }
            Section {
                if let bundlePath = appDetails["Path"] {
                    Button("Copy app bundle folder") {
                        UIPasteboard.general.string = "file://a\(bundlePath)"
                    }
                }
                if let containerPath = appDetails["Container"] {
                    Button("Copy app data folder") {
                        UIPasteboard.general.string = "file://a\(containerPath)"
                    }
                }
            } header: {
                Text("Arbitrary read exploit")
            } footer: {
                Text("After copying path, open Settings, paste it in search bar, select all again and tap Share.\n\nOnly supported on iOS ≤ 18.2b1 and iOS 26.x. For this exploit, folders can only be shared via AirDrop.\nIf you're sharing App Store apps, please note that it will still remain encrypted.")
            }
        }
        .navigationTitle((appDetails["CFBundleName"] as? String) ?? bundleID)
    }

    init(bundleID: String) {
        self.bundleID = bundleID
        self.appDetails = ["Loading": AnyCodable("...")]
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
                    apps = ["Failed to get app list: \(error)": [:]]
                }
            }
        }
        .searchable(text: $searchString)
        .navigationTitle("App list")
    }
    
    init() {
        apps = ["Loading": [:]]
    }

}
