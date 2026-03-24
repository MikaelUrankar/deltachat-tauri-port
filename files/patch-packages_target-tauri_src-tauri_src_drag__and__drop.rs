--- packages/target-tauri/src-tauri/src/drag_and_drop.rs.orig	2026-03-24 10:44:30 UTC
+++ packages/target-tauri/src-tauri/src/drag_and_drop.rs
@@ -18,7 +18,7 @@ pub(crate) async fn drag_file_out(
         drag::Image::Raw(include_bytes!("../../../../images/electron-file-drag-out.png").to_vec());
 
     app.run_on_main_thread(move || {
-        #[cfg(target_os = "linux")]
+        #[cfg(any(target_os = "linux", target_os = "freebsd"))]
         let gtk_window = match window
             .gtk_window()
             .map_err(|err| format!("failed to get window.gtk_window: {err:?}"))
@@ -31,9 +31,9 @@ pub(crate) async fn drag_file_out(
         };
 
         if let Err(error) = drag::start_drag(
-            #[cfg(target_os = "linux")]
+            #[cfg(any(target_os = "linux", target_os = "freebsd"))]
             &gtk_window,
-            #[cfg(not(target_os = "linux"))]
+            #[cfg(not(any(target_os = "linux", target_os = "freebsd")))]
             &window,
             DragItem::Files(vec![file]),
             preview_icon,
