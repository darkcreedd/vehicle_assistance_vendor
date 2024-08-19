// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_user_stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$emergencyUserStreamHash() =>
    r'128ed993db7197e08d78c5b60dc27092899df895';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$EmergencyUserStream
    extends BuildlessAutoDisposeStreamNotifier<AUser> {
  late final String userId;

  Stream<AUser> build(
    String userId,
  );
}

/// See also [EmergencyUserStream].
@ProviderFor(EmergencyUserStream)
const emergencyUserStreamProvider = EmergencyUserStreamFamily();

/// See also [EmergencyUserStream].
class EmergencyUserStreamFamily extends Family<AsyncValue<AUser>> {
  /// See also [EmergencyUserStream].
  const EmergencyUserStreamFamily();

  /// See also [EmergencyUserStream].
  EmergencyUserStreamProvider call(
    String userId,
  ) {
    return EmergencyUserStreamProvider(
      userId,
    );
  }

  @override
  EmergencyUserStreamProvider getProviderOverride(
    covariant EmergencyUserStreamProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'emergencyUserStreamProvider';
}

/// See also [EmergencyUserStream].
class EmergencyUserStreamProvider
    extends AutoDisposeStreamNotifierProviderImpl<EmergencyUserStream, AUser> {
  /// See also [EmergencyUserStream].
  EmergencyUserStreamProvider(
    String userId,
  ) : this._internal(
          () => EmergencyUserStream()..userId = userId,
          from: emergencyUserStreamProvider,
          name: r'emergencyUserStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$emergencyUserStreamHash,
          dependencies: EmergencyUserStreamFamily._dependencies,
          allTransitiveDependencies:
              EmergencyUserStreamFamily._allTransitiveDependencies,
          userId: userId,
        );

  EmergencyUserStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Stream<AUser> runNotifierBuild(
    covariant EmergencyUserStream notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(EmergencyUserStream Function() create) {
    return ProviderOverride(
      origin: this,
      override: EmergencyUserStreamProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<EmergencyUserStream, AUser>
      createElement() {
    return _EmergencyUserStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmergencyUserStreamProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin EmergencyUserStreamRef on AutoDisposeStreamNotifierProviderRef<AUser> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _EmergencyUserStreamProviderElement
    extends AutoDisposeStreamNotifierProviderElement<EmergencyUserStream, AUser>
    with EmergencyUserStreamRef {
  _EmergencyUserStreamProviderElement(super.provider);

  @override
  String get userId => (origin as EmergencyUserStreamProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
