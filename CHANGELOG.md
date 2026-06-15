## 0.0.3

* Updated example names across files for demo.

## 0.0.2

* Updated repository and issue tracker links in `pubspec.yaml` to point to the correct GitHub repository.


## 0.0.1

* Initial release of `ui_masked_text`.
* Added the `MaskedText` declarative UI widget for safely displaying sensitive read-only data.
* Included out-of-the-box support for 7 standard PII formats: `MaskType.email`, `MaskType.phone`, `MaskType.creditCard`, `MaskType.bankAccount`, `MaskType.ssn`, `MaskType.token`, and `MaskType.name`.
* Added `MaskType.custom` with a `customMasker` parameter to allow developers to build infinite domain-specific masking rules.
* Configured customizable parameters for `maskChar`, `visibleEndChars`, and `style`.
* Included a comprehensive `/example` application demonstrating all standard and custom use cases.
* Built entirely with pure Dart string manipulation, ensuring 0 transient dependencies for a lightweight footprint.