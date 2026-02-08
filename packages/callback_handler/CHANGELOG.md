## 0.0.2

* Added `clear()` method to remove all registered callbacks at once
* Added support for `CallbackHandler<void, void>` specialization for void callbacks
* Added `call()` method to invoke handler as a function (recommended over deprecated `invoke()`)
* Deprecated `invoke()` method in favor of callable syntax
* Improved API documentation with comprehensive dartdoc comments
* Enhanced FastMap documentation with complexity analysis
* Added library-level documentation
* Added analysis_options.yaml with strict linting rules

## 0.0.1

* Initial release
* CallbackHandler implementation with generic type support
* FastMap utility for O(1) operations
* Register, unregister, invoke, and clear functionality
* ICallbackHandler interface
* Full test coverage
* Comprehensive documentation and examples
