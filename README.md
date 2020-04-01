App, that demonstrates one of the many ways to handle deep linking user into the specific screen of
your app. More info in this [Medium post](https://medium.com/@tair.rzayev/taking-the-right-route-with-flutter-6c402820aff4).

## Building / testing

1. Configure firebase project for this app (see https://firebase.google.com/docs/flutter/setup)
2. In your firebase project, go Grow -> Dynamic Links. Create new `*.page.link` domain for this app.
3. Press `New dynamic link`, in `Set up your dynamic link` step set the `Deep link URL` to something like `https://dynamiclinks.com/details?id=11` (this link will open the details screen for item with ID `11`
4. Go through the remaining steps, making sure the link behavior is set to `Open deep link in your Android/iOS app`.
5. Install the app, paste the generated dynamic link in text editor or messenger on your phone and then tap it.