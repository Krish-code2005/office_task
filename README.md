# office_task — Mini App

A product-browsing Flutter app built as a Week 1 onboarding task: authentication, paginated lists, local notifications, and push notifications, using a feature-based Clean-ish architecture with Cubit/Bloc.

## Setup

1. Clone the repo and install dependencies:
   ```bash
   flutter pub get
   ```
2. Generate the dependency-injection wiring (required after any change to `@injectable`/`@lazySingleton` classes):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. iOS only — install pods:
   ```bash
   cd ios && pod install && cd ..
   ```
4. Firebase is already configured via `flutterfire configure` (`lib/firebase_options.dart`, `GoogleService-Info.plist`, `google-services.json` are committed). No extra setup needed to run the app.
5. Run the app:
   ```bash
   flutter run
   ```
6. Run tests:
   ```bash
   flutter test
   ```

**Test login:** username `emilys`, password `emilyspass` (DummyJSON test account).

## Architecture decisions

- **Feature-based folder structure** (`lib/features/<feature>/{data,domain,presentation}`) rather than grouping by file type, so each feature owns its own models, repository, and state.
- **Cubit over Bloc** for state management — simpler direct-method-call API, sufficient for this app's needs, and matches the task's Cubit-only requirement.
- **get_it + injectable** for dependency injection. `@lazySingleton` for shared, stateful services (`DioClient`, repositories, `FlutterSecureStorage`); `@injectable` for Cubits, so each screen gets a fresh instance with a clean lifecycle.
- **Typed `Failure` classes** instead of raw exceptions/strings, with a single `mapDioExceptionToFailure()` translating Dio errors into `NetworkFailure` / `ServerFailure` / `UnauthorizedFailure`, so the real API error message (e.g. "Invalid credentials") always reaches the UI instead of a hardcoded string.
- **Repository pattern** — every feature's Cubit talks only to its Repository, never directly to Dio. This keeps API/error-handling logic in one place and makes Cubits mockable in tests.
- **flutter_secure_storage over SharedPreferences** for auth tokens, since it's encrypted at rest.
- **Pagination guarded with a private `_isFetching` flag** inside `ProductListCubit`, checked and set synchronously before any `await`, to prevent duplicate network calls when the user scrolls quickly. `hasReachedMax` is derived from `skip + limit >= total` on every page fetch.
- **Local notifications via `flutter_local_notifications`**, using `zonedSchedule` with `inexactAllowWhileIdle` (see limitations below) so reminders don't require the Android 12+ exact-alarm special permission.
- **Push notifications via Firebase Cloud Messaging**, with foreground messages manually surfaced through the same local-notification service, since FCM does not auto-display foreground notifications.

## Known limitations

- **iOS push notifications are untested on-device.** The Push Notifications capability requires a paid Apple Developer Program membership; the free personal-team account used for local builds cannot provision it. Push notification code (permission request, token retrieval, foreground/background handling) is implemented and was verified working end-to-end on Android — FCM tokens are retrieved successfully, test messages are received and logged (`FLTFireMsgReceiver`), and are displayed via the local notification bridge.
- **Local notification scheduling uses `inexactAllowWhileIdle`** rather than `exactAllowWhileIdle`, so a scheduled reminder may fire a few seconds later than the exact requested delay. This avoids requiring Android's separate "Alarms & reminders" special permission, which is not auto-granted and adds friction for a 10-second demo reminder.
- **Notification display was inconsistent on the Android emulator** despite scheduling completing without error in logs; this appears to be an emulator-specific quirk rather than an app bug, and should be re-verified on a physical device.
- **No refresh-token flow** — `/auth/refresh` is not implemented; when the access token expires, the user needs to log in again rather than being silently re-authenticated.
- **No offline caching** — the product list and detail screens require a live network connection; there is no local persistence (e.g. Hive) for offline-first loading.
- **Search is not implemented** (`/products/search` is a stretch goal in the task spec).
- **No widget tests** for the Login screen — only `bloc_test` unit tests for `AuthCubit` are included (login success, login failure).