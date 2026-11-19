# Southsea Cinema

Southsea Cinema is a Flutter app for browsing films and recording cinema bookings. It supports Android only; browser and desktop versions are not supported.

## Features

- Browse films and view their details.
- Choose 1–5 tickets for the listed screening and add them to your basket.
- Review your basket, remove tickets and place a booking.
- View completed bookings in Past Bookings.
- Save contact details and preferences, including a light or dark theme choice that is remembered when you reopen the app.

Completed bookings are stored locally on the device.

## Screenshots

### Menu

<!-- Add a menu screenshot here -->

### Basket

<!-- Add a basket screenshot here -->

## Install and run

You need the Flutter SDK and an Android emulator configured.

From the project directory, install the dependencies:

```bash
flutter pub get
```

List available emulators and start one:

```bash
flutter emulators
flutter emulators --launch <emulator_id>
```

Then find the emulator's device ID and run the app:

```bash
flutter devices
flutter run -d <device_id>
```

## Tests

Run the automated test suite with:

```bash
flutter test
```

The tests run without an Android emulator.
