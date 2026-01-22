# NOTIFY_AT Feature Design

## Overview

Added support for absolute notification times via the `WILD_NOTIFIER_NOTIFY_AT` property. This allows scheduling notifications at specific times that are not relative to an event's scheduled/deadline time.

## Usage

```org
* TODO Important meeting
  SCHEDULED: <2024-01-25 10:00>
  :PROPERTIES:
  :WILD_NOTIFIER_NOTIFY_AT: <2024-01-24 17:00> <2024-01-25 08:00>
  :END:
```

This notifies you:
- At 17:00 on Jan 24 (evening before)
- At 08:00 on Jan 25 (morning of)

Regardless of when the meeting is scheduled.

### Repeating Timestamps

Repeating timestamps are supported:

```org
:WILD_NOTIFIER_NOTIFY_AT: <2024-01-21 09:00 +1d>
```

This notifies every day at 09:00.

## Implementation

### New Components

1. **`org-wild-notifier-notify-at-property`** (defcustom)
   - Default: `"WILD_NOTIFIER_NOTIFY_AT"`
   - Customizable property name

2. **`org-wild-notifier--parse-notify-at-timestamp`** (function)
   - Parses timestamps for NOTIFY_AT, handling both one-time and repeating
   - Uses `current-time` as reference (important for testing)

3. **`org-wild-notifier--extract-notify-at-times`** (function)
   - Extracts all timestamps from the property
   - Returns list of parsed time values

4. **`org-wild-notifier--check-notify-at`** (function)
   - Checks if any notify-at times match current time
   - Returns notification messages

### Modified Components

1. **`org-wild-notifier--gather-info`**
   - Now includes `notify-at` key in event alist

2. **`org-wild-notifier--check-event`**
   - Calls `org-wild-notifier--check-notify-at` and appends results

3. **`org-wild-notifier-default-environment-regex`**
   - Added `org-wild-notifier-notify-at-property` for async subprocess

## Testing

Added tests:
- `notify-at-single-time`: Single absolute timestamp
- `notify-at-multiple-times`: Multiple timestamps in one property
- `notify-at-multiple-times-second`: Verifies second timestamp triggers
- `notify-at-repeating`: Repeating timestamp support
- `notify-at-custom-property`: Customized property name

## Notes

- Notification message format: `"{title} (scheduled reminder)"`
- Consistent with existing `org-wild-notifier-schedule-at-point-at-time`
