# Sedan map markers

The home and ride maps use an original pearl-white sedan with dark glass, visible wheels, a crimson sill and a soft contact shadow. The production artwork is a simplified 3D mesh inspired by the concept in `previews/meshwar-sedan-3d.png`.

`tools/render_sedan.swift` renders the same mesh at 120 headings, three degrees apart, and 16 camera tilts from 0° to 75° in five-degree steps. The 1,920 views live in `assets/sedan_sprites/`. Rebuild on macOS with:

```sh
xcrun swift tools/render_sedan.swift assets/sedan_sprites docs/previews/meshwar-sedan-marker.png
```

SceneKit is an asset-generation tool only. Both Android and iOS bundle the same transparent PNG frames; no SceneKit runtime or new Flutter dependency is required. Frames are 192 pixels square and display at 64 logical pixels on Google Maps. Flutter Map uses the same assets at 64 logical pixels.

Source markers retain their world heading during driver movement. At presentation time, the map chooses the view for `vehicleHeading - cameraBearing` and the actual native camera tilt. Google Maps uses centered billboard markers so map rotation changes the visible side of the sedan. A small projected rotation correction preserves continuous turning between the rendered heading frames. Flutter Map counter-rotates the marker container and chooses the camera-relative overhead view (Flutter Map has no tilt). The contact shadow is included in every view, and the renderer points at the ground anchor so tilting does not move the car off its coordinate.

The native SDK loads only displayed views; Dart caches small bitmap descriptors rather than decoding the full atlas at startup. This uses views rendered from a 3D mesh, rather than embedding a live SceneKit model. Existing bike and van assets remain in use; car categories share the new sedan as they previously shared the car sprites.

Vehicle turns use the shortest angular path through north. New GPS updates resume from the displayed position and heading, rather than the previous animation target. Heading-only updates also animate on the home map, and the active driver stream prioritizes compass heading over movement bearing.

Validation: 15 targeted tests passed, covering camera tilt/rotation selection, ground anchoring, precise source heading, shortest turns, safe tilt clamping, untouched pickup markers, all 1,920 bundled frames, alpha corners, soft shadow pixels and route framing. The iOS simulator app built successfully. Analysis found no errors or warnings; 13 existing informational lints remain in the two blocs. Android checks include platform-specific bitmap sizing and exact initial headings. The Android arm64 debug APK built successfully and includes all 1,920 camera-pose frames. A native Google Maps preview passed on the connected Infinix X6728 (320 dpi): actual map bearings 0°, 90°, 180° and 270°, tilts 0°, 45° and 60°, continuous car rotation, visible contact shadows and stable ground anchoring. The regular Meshwar app was restored after testing. The first build needed an NDK download and retried after a dependency download timeout; the retry succeeded.

## Native Android preview

Use the production marker helper on a real Google map without authenticating or booking a ride:

```sh
flutter run -t tools/sedan_map_preview.dart -d <android-device-id>
```

The preview provides map rotation, camera tilt and continuous car-turn controls. For a repeatable sequence of 0°, 90°, 180° and 270° map bearings at 0°, 45° and 60° requested tilts, add `--dart-define=SEDAN_AUTO_CHECK=true`. The native camera reports its actual bearing and tilt on screen. The preview uses fictional vehicle positions in Kuwait and never enables device location. Restore the regular `lib/main.dart` app after the check.

The native-device check is recorded in [sedan-android-check.mp4](previews/sedan-android-check.mp4), with a [270° bearing / 45° tilt screenshot](previews/sedan-android-270-45.png). These checks use simulated vehicle positions; they do not create or request a ride.
