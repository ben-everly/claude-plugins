# Calibration

The bundled calibration for the `estimate` skill. To use your own, write a file
with these same sections and either save it as `.claude/estimation.md` in the
repository or name its path in the project instructions. Your file replaces this
one whole.

## Scheme

T-shirt, XS–XL

## Adjustment points

| Tier      | Points |
| --------- | ------ |
| none      | 0      |
| contained | 1      |
| rework    | 2      |

## Size examples

Each example is sized as its base, before adjustments.

### 1 — XS

- Correct the wording of an existing error message and the test that asserts it.
  _One localized edit._
- Raise a configured timeout from 30s to 60s. _One value in existing config._
- Reword one sentence in a skill's or runbook's instructions. _Existing content,
  no new behavior._

### 2 — S

- Add a maximum-length rule to an existing form field's validation, with a test.
  _One behavior in one file, using the existing validation pattern._
- Add a sort option to a list endpoint that already sorts by other fields. _One
  behavior, following the existing sorts._
- Add one rule, with an example, to an existing section of a skill or runbook.
  _One behavior in one file, following the rules already there._

### 3 — M

- Add a create/read/update/delete endpoint set for an existing model, following
  the existing endpoints, with tests and API docs. _One component modeled on
  existing ones._
- Add CSV export to an existing report screen: the button, the export action,
  and tests. _Several files in one module._
- Add a skill modeled on an existing one in the same plugin, with a reference
  file. _One component modeled on an existing one._

### 5 — L

- Send email notifications for three existing events: a notification mechanism,
  one template per event, and a user opt-out setting. _A new mechanism other
  code will build on._
- Add soft delete to a model read in several modules: the column and migration,
  query scoping everywhere the model is read, and a restore action. _Spans
  several modules._
- Change a convention every plugin's skills follow, such as a frontmatter field,
  and update each plugin. _Several modules._

### 8 — XL

- Add single sign-on alongside password login: the login flow, account linking,
  session handling, and admin configuration. _A new subsystem._
- Move file storage from local disk to object storage across the upload,
  download, and processing paths, migrating existing files. _Cuts across most of
  the system._
- Restructure a documentation set into a new layout, moving and relinking every
  page. _Most modules._

## Adjustment examples

### none

- The work changes a label on the billing screen. The billing logic sits in the
  same module, but nothing in the change reaches it.
- The work adds a database column. The table is small and nothing points to a
  slow migration.

### contained

- The function being changed has 14 call sites. A missed one fails a test and is
  fixed in place.
- The work doesn't say whether the new field is required. Either answer is one
  validation rule.

### rework

- The work depends on a third-party API whose rate limit it doesn't state. If
  the limit is below the expected volume, the design needs a queue.
- The work leaves open whether the data belongs to a user or a team. Per-team
  ownership changes the data model.
