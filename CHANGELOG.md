# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2026-02-04

### Added
- Initial implementation of CallbackHandler with generic type support
- FastMap utility for O(1) callback storage and retrieval
- Register, unregister, and invoke functionality
- ICallbackHandler interface
- CallbackWithReturn type definition
- Comprehensive test suite covering all use cases
- Support for multiple callback registration and invocation

### Fixed
- Fixed invoke method to correctly iterate through all callbacks (was calling index 0 repeatedly)

## [Unreleased]

### Planned
- Add async callback support
- Add callback priority/ordering
- Performance benchmarks
- Additional utility methods (clear, contains, etc.)
