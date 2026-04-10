--- cargo-crates/wry-0.53.5/src/webkitgtk/mod.rs.orig	2026-04-10 11:57:25 UTC
+++ cargo-crates/wry-0.53.5/src/webkitgtk/mod.rs
@@ -419,12 +419,24 @@ impl InnerWebView {
       context.set_use_system_appearance_for_scrollbars(false);
     }
 
+    // allow all permission requests
+    use webkit2gtk::PermissionRequestExt;
+    webview.connect_permission_request(move |_, request| {
+      request.allow();
+      true
+    });
+
+
     if let Some(settings) = WebViewExt::settings(webview) {
       // Enable webgl, webaudio, canvas features as default.
       settings.set_enable_webgl(true);
       settings.set_enable_webaudio(true);
       settings
         .set_enable_back_forward_navigation_gestures(attributes.back_forward_navigation_gestures);
+
+      // Enable WebRTC
+      settings.set_enable_webrtc(true);
+      settings.set_enable_media_stream(true);
 
       // Enable clipboard
       if attributes.clipboard {
