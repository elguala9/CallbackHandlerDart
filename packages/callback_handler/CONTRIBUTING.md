# Contributing to callback_handler

Thank you for your interest in contributing! We welcome contributions from the community.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check the [issue tracker](https://github.com/elguala9/CallbackHandlerDart/issues) to avoid duplicates.

When creating a bug report, include:
- Dart/Flutter version
- Package version (`callback_handler: ^x.x.x`)
- Minimal reproducible code example
- Expected vs actual behavior
- Stack trace (if applicable)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating one, include:
- Clear use case description
- Why this enhancement would be useful
- Example code showing how it would work

### Pull Requests

1. Fork the repo and create your branch from `develop`
2. Add tests for any new code
3. Ensure all tests pass: `melos run test`
4. Follow code style: `dart format .`
5. Run static analysis: `dart analyze`
6. Update CHANGELOG.md with your changes
7. Update documentation if needed

## Development Setup

```bash
# Clone the repository
git clone https://github.com/elguala9/CallbackHandlerDart.git
cd CallbackHandlerDart

# Install Melos
dart pub global activate melos

# Bootstrap dependencies
melos bootstrap

# Run tests
melos run test

# Run analysis
melos run analyze
```

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` before committing
- Document all public APIs with dartdoc comments
- Write tests for new features and bug fixes
- Keep changes focused and atomic

## Commit Messages

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters or less
- Reference issues and pull requests when applicable

## Code of Conduct

Be respectful and inclusive. We're here to build great software together.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
