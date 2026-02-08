# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

1. **Do NOT** create a public GitHub issue
2. Email details to the maintainer (check package homepage for contact)
3. Include:
   - Type of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Response Timeline

- Acknowledgment: Within 48 hours
- Initial assessment: Within 1 week
- Fix timeline: Depends on severity
- Public disclosure: After fix is released

## Security Best Practices

When using callback_handler:

1. **Memory Management**: Always call `unregister()` or `clear()` when callbacks are no longer needed to prevent memory leaks

2. **Exception Handling**: Wrap callback invocations in try-catch if callbacks may throw exceptions:
   ```dart
   final results = <int, CallbackReturnType>{};
   for (var callback in callbacks) {
     try {
       results[callback.hashCode] = callback(input);
     } catch (e) {
       // Handle exception
     }
   }
   ```

3. **Input Validation**: Validate inputs before passing to callbacks to prevent unexpected behavior

4. **Async Safety**: Be careful with async callbacks to avoid race conditions or unintended behavior

## Known Limitations

- Callback identification via `hashCode` may have rare collisions (extremely unlikely in practice)
- No built-in protection against infinite recursion in callbacks (developers must ensure callbacks don't recursively invoke the same handler)
- Callbacks are invoked synchronously; long-running callbacks will block the invoking thread
