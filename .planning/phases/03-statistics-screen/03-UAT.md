---
status: complete
phase: 03-statistics-screen
source:
  - .planning/phases/03-statistics-screen/03-01-SUMMARY.md
  - .planning/phases/03-statistics-screen/03-02-SUMMARY.md
  - .planning/phases/03-statistics-screen/03-03-SUMMARY.md
started: 2026-04-10T18:30:00Z
updated: 2026-04-10T18:45:00Z
---

## Current Test

[testing complete]

## Tests

### 1. Annual vs Monthly card label switching
expected: |
  On the Statistics screen with "All Months" selected, the three summary cards
  at the top read "Annual Income", "Annual Expenses", and "Annual Balance".
  When you tap any specific month chip, all three titles switch to
  "Monthly Income", "Monthly Expenses", "Monthly Balance".
result: pass

### 2. Percentage badge context label
expected: |
  The small percentage badge below the Income and Expenses card amounts
  shows "vs last year" when "All Months" is selected, and "vs last month"
  when a specific month is selected.
result: pass

### 3. Annual evolution covers all 12 months
expected: |
  In the Annual Evolution tab with "All Months" selected, the monthly breakdown
  list can show entries for all 12 months of the year (Jan–Dec).
  If you have expense/income data in more than 6 months of the selected year,
  all months with data appear — the old 6-month cap is gone.
result: pass

### 4. Currency shown as MDL everywhere — no RON or lei
expected: |
  All monetary amounts on the Statistics screen use the MDL currency symbol/format.
  Check: summary cards, category breakdown percentages and amounts, monthly list bar rows,
  and the balance text in the monthly list. None should show "RON" or "lei".
result: pass

### 5. English labels in monthly list
expected: |
  In the Annual Evolution monthly list, the income/expense row labels read
  "Income" and "Expenses" (not Romanian "Venit" / "Cheltuieli").
  The section card header reads "Monthly Breakdown"
  (not "Total cheltuieli pe lună").
result: pass

### 6. Balance text format
expected: |
  In the Annual Evolution monthly list, each month's balance text reads
  "Balance: +X MDL" for a positive balance, or "Balance: -X MDL" for
  a negative balance. It should NOT show "Sold: +X lei".
result: pass

### 7. Positive savings balance shows green color
expected: |
  On the Statistics screen, the "Annual Balance" (or "Monthly Balance") card
  at the bottom of the summary section shows the balance amount in green
  when the balance is positive (income > expenses).
  Previously it showed in a neutral grey regardless of sign.
result: pass

### 8. Stats screen refreshes after expense edit
expected: |
  After editing an expense on the home screen, the Statistics screen should
  show updated totals — "Monthly Balance", "Monthly Expenses", and
  "Monthly Income" should reflect the edited amount immediately.
result: issue
reported: "when I edit an expense on home screen the stat 'Monthly Balance' does not immediately change it"
severity: major

## Summary

total: 8
passed: 7
issues: 1
pending: 0
skipped: 0

## Gaps

- truth: "Stats screen totals update immediately after an expense is edited from the home screen"
  status: failed
  reason: "User reported: editing an expense on home screen does not immediately update Monthly Balance on Stats screen"
  severity: major
  test: 8
  artifacts: []
  missing: []
