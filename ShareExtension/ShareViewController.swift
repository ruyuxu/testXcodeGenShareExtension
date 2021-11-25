import MobileCoreServices
import Social
import UIKit

class ShareViewController: SLComposeServiceViewController {
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        let contentType = "com.app.xyz" // kUTTypeImage as String
        if let item = extensionContext?.inputItems.first as? NSExtensionItem,
           let itemProvider = item.attachments?.first,
           itemProvider.hasItemConformingToTypeIdentifier(contentType) {
            itemProvider.loadItem(forTypeIdentifier: contentType, options: nil) { url, _ in
                if let shareURL = url as? URL {
                    // do what you want to do with shareURL
                    let defaults = UserDefaults(suiteName: "group.app.pointCloudDemo")
                    if defaults != nil {
                        if var values = defaults!.array(forKey: "Share") {
                            let duplicateIndex = values.firstIndex(where: { $0 as! String == shareURL.path }) ?? -1
                            if duplicateIndex >= 0 {
                                values[duplicateIndex] = shareURL.path
                            } else {
                                values.append(shareURL.path)
                            }
                            defaults!.setValue(values, forKey: "Share")
                        } else {
                            defaults!.setValue([shareURL.path], forKey: "Share")
                        }
                    }
                }
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
        extensionContext!.completeRequest(returningItems: [], completionHandler: { _ in
            print("Success!!")
        })
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        []
    }
}
