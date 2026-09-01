# AGENTS.md — cc_sdk_data

Package-scoped addendum to the repo root `AGENTS.md` (read that first — this file only covers what's
distinctive about this package).

- Core, cross-app data entities/models (e.g. `CcDeviceEntity`). Only put something here if it's genuinely
  reusable across any app built on this template — app-specific models belong in `modules/data_config` or the
  owning feature's `data/models/` instead.
- State-management agnostic, same as the rest of `cc_core_sdk`.
