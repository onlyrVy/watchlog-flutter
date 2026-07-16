# WatchLog

A personal movie journal app — search real movies via TMDb, save them to your
library, rate and review, and track stats. Flutter frontend, Laravel/MySQL
backend.

## Status: Phase 1 (Flutter project setup) — auth UI + navigation complete

## Folder Structure

```
lib/
  core/                        Cross-cutting code shared by every feature.
    theme/                     Colors, text styles, ThemeData — one place to
                                restyle the whole app.
    routes/                    go_router config + route name constants.
    widgets/                   Reusable UI (buttons, text fields, loaders)
                                used across 2+ features, so no feature owns
                                widgets other features depend on.
    utils/                     Pure helper functions (validators, formatters)
                                with no Flutter/UI dependency.
    constants/                 App-wide constants (spacing scale, app name).

  features/                    One folder per user-facing feature. Each is
                                self-contained: a feature's internals never
                                reach into another feature's folder directly.
    auth/
      presentation/
        pages/                 Screens (Login, Register, Splash).
        providers/             Riverpod state for this feature (AuthNotifier).
      data/
        models/                Plain Dart classes + JSON (de)serialization.
        repositories/          Abstracts "how data is fetched" behind an
                                interface, so UI never talks to dio/http
                                directly. Phase 1 uses FakeAuthRepository;
                                Phase 2 adds RemoteAuthRepository — no UI
                                changes required to swap them.
    home/                      Dashboard + the shell that hosts bottom nav.
    search/                    TMDb movie search (wired in Phase 3).
    movie/                     Movie detail page (wired in Phase 3/4).
    watchlist/                 Library (Watchlist/Watching/Watched) (Phase 4).
    profile/                   User profile + logout (functional now).
    statistics/                Stats dashboard (wired in Phase 5).
```

**Why feature-based instead of type-based (all models/, all pages/ etc.)?**
Type-based folders (`lib/pages/`, `lib/models/`, `lib/providers/`) scale
badly — every feature's files land in every folder, so nothing is
self-contained and diffs/PRs touch unrelated directories. Feature-based
folders keep each feature's UI, state, and data together, mirroring how the
app is actually reasoned about and making it trivial to find or delete a
whole feature.

## Why the repository pattern for auth (and future features)

`AuthRepository` is an abstract interface. `LoginPage`/`RegisterPage` and
`AuthNotifier` depend only on that interface, never on `dio` or HTTP status
codes directly. Phase 1 ships `FakeAuthRepository` (in-memory, simulated
latency) so the UI, loading states, and validation are fully testable before
the Laravel backend exists. Phase 2 adds `RemoteAuthRepository` calling the
Sanctum endpoints — swapped in at `authRepositoryProvider`, with zero changes
to any page. This is the Dependency Inversion half of SOLID applied
concretely.

## Getting started

```bash
flutter pub get
flutter run
```

No backend is required yet — Phase 1 auth uses an in-memory fake, so
login accepts any email + password of 8+ characters, and registration always
succeeds.
