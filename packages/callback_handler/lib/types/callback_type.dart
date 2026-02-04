/// A function type for callbacks that accept an input and return a value.
///
/// Type parameters:
/// * [I] - The input type
/// * [R] - The return type
///
/// Example:
/// ```dart
/// CallbackWithReturn<String, int> callback = (input) => input.length;
/// ```
typedef CallbackWithReturn<I, R> = R Function(I);
