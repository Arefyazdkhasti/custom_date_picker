# Changelog
## 1.3.0
### Added
- **Simple Date Picker (Minimal Mode)**:
  - A lightweight, scroll-based picker using three Cupertino-style wheels (Year / Month / Day).
  - Supports both **Jalali** and **Gregorian** calendars.
  - Respects `initialDate` and `lastDate` limits — users can only scroll within the valid date range.
  - Customizable appearance:
    - `selectedItemStyle`, `itemStyle`, and `selectedItemBackgroundColor`
    - Adjustable `itemHeight`
    - Custom select and clear buttons (`selectDateButtonText`, `clearDateButton`)
  - Ideal for compact use cases like **birthdate selection** or simple input modals.
- Improved UI consistency for Cupertino pickers with highlight borders for the selected row.

### Changed
- Internal code cleanup and structure improvements in picker rebuild logic.
- Enhanced scrolling and state synchronization between Year, Month, and Day pickers.

## 1.2.0
- remove [iconsax](https://pub.dev/packages/iconsax) and use [iconsax_flutter](https://pub.dev/packages/iconsax_flutter) instead

## 1.1.0
- fix small bugs

## 1.0.2
- Add needed documents and public_member_api_docs

## 1.0.1 
- Updated README.md to include screenshots.

## 1.0.0

### Added
- Full support for both Jalali and Gregorian calendars.
- Ability to select a **single date** or a **range of dates**.
- Customizable colors for selected, current, and default days.
- Dynamic price support for days, displayed directly on the calendar.
- `onDateSelected` callback for single-date selection.
- `onRangeDateSelected` callback for range selection.
- Support for today navigation with a "Today" button.
- Ability to switch between single and range picker modes dynamically.
- Added customization options for:
  - Primary color
  - Day widget appearance
  - Buttons and icons
- Multi-language support with RTL and LTR compatibility.
- Ensured smooth transitions when switching between Jalali and Gregorian calendars.

### Changed
- Enhanced day rendering to support dynamic content such as prices or labels.

## 1.2.1
- Remove flutter_iconsax package
- Add Icon file locally

---

