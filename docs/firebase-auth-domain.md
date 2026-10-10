# Firebase phone authentication on meshwar.ws

The Android/iOS app uses `meshwar.ws` as its default custom authentication domain.
The `FIREBASE_AUTH_DOMAIN` compile-time define can override it.

On 2026-10-04, after the Nginx configuration was tested and reloaded, the public
`/__/auth/handler` and `/__/auth/handler.js` routes on `meshwar.ws` each returned
HTTP 200 and matched the original Firebase responses byte for byte. The domain
was also observed in Firebase's authorized domains list on 2026-10-03.
The actual OTP SMS branding still needs a device test.

## Server and Firebase setup

1. In project `meshwar-f665c`, add `meshwar.ws` under Firebase Authentication >
   Settings > Authorized domains.
2. On the existing HTTPS server for `meshwar.ws`, proxy `/__/auth/` to
   `https://meshwar-f665c.firebaseapp.com/__/auth/`. Preserve the path, query string,
   request method, and body. Use a transparent proxy, not an HTTP redirect.
   For Nginx, include the following inside the existing HTTPS `server` block:

   ```nginx
   location ^~ /__/auth/ {
       proxy_pass https://meshwar-f665c.firebaseapp.com;
       proxy_set_header Host meshwar-f665c.firebaseapp.com;
       proxy_ssl_server_name on;
       proxy_ssl_name meshwar-f665c.firebaseapp.com;
   }
   ```

   This is a deployment example; identify the actual web server before applying
   it. Keep the website and API on their existing hosting.
3. If the Firebase API key has HTTP referrer restrictions, allow the custom domain
   as appropriate for Firebase's reCAPTCHA flow.
4. Verify that `/__/auth/handler` and `/__/auth/handler.js` return Firebase's
   handler and JavaScript, not a website fallback page. Check the content as well
   as the HTTP status.

## Enable and verify

The custom domain is enabled for ordinary builds. Restart/rebuild the app:

```sh
flutter run
# For an iOS release:
flutter build ipa
# For an Android release:
flutter build appbundle
```

Use a full restart/rebuild when changing a compile-time define. Confirm that the
reCAPTCHA flow opens `meshwar.ws`, returns to the app, and reaches `codeSent`.
Inspect a real OTP SMS to verify the displayed branding. A custom authentication
domain controls the handler; Firebase still chooses the SMS text and app label
for each verification path. This change does not promise arbitrary SMS content
or a sender ID of `Meshwar`.

To revert to Firebase's default domain, rebuild with
`--dart-define=FIREBASE_AUTH_DOMAIN=` (an empty value).

## References

- [Custom authentication domains](https://docs.cloud.google.com/identity-platform/docs/show-custom-domain)
- [Firebase authentication reverse proxy](https://firebase.google.com/docs/auth/web/redirect-best-practices#option-3)
- [Android phone-auth SMS labels](https://firebase.google.com/docs/auth/android/phone-auth)
