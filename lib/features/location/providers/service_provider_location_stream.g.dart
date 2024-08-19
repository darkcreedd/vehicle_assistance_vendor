// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider_location_stream.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$serviceProviderLocationStreamHash() =>
    r'2d57c4d9c6047d4d48c2d458c2cc743aaae10692';

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

abstract class _$ServiceProviderLocationStream
    extends BuildlessAutoDisposeStreamNotifier<LatLng> {
  late final String userId;

  Stream<LatLng> build(
    String userId,
  );
}

/// See also [ServiceProviderLocationStream].
@ProviderFor(ServiceProviderLocationStream)
const serviceProviderLocationStreamProvider =
    ServiceProviderLocationStreamFamily();

/// See also [ServiceProviderLocationStream].
class ServiceProviderLocationStreamFamily extends Family<AsyncValue<LatLng>> {
  /// See also [ServiceProviderLocationStream].
  const ServiceProviderLocationStreamFamily();

  /// See also [ServiceProviderLocationStream].
  ServiceProviderLocationStreamProvider call(
    String userId,
  ) {
    return ServiceProviderLocationStreamProvider(
      userId,
    );
  }

  @override
  ServiceProviderLocationStreamProvider getProviderOverride(
    covariant ServiceProviderLocationStreamProvider provider,
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
  String? get name => r'serviceProviderLocationStreamProvider';
}

/// See also [ServiceProviderLocationStream].
class ServiceProviderLocationStreamProvider
    extends AutoDisposeStreamNotifierProviderImpl<ServiceProviderLocationStream,
        LatLng> {
  /// See also [ServiceProviderLocationStream].
  ServiceProviderLocationStreamProvider(
    String userId,
  ) : this._internal(
          () => ServiceProviderLocationStream()..userId = userId,
          from: serviceProviderLocationStreamProvider,
          name: r'serviceProviderLocationStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$serviceProviderLocationStreamHash,
          dependencies: ServiceProviderLocationStreamFamily._dependencies,
          allTransitiveDependencies:
              ServiceProviderLocationStreamFamily._allTransitiveDependencies,
          userId: userId,
        );

  ServiceProviderLocationStreamProvider._internal(
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
  Stream<LatLng> runNotifierBuild(
    covariant ServiceProviderLocationStream notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(ServiceProviderLocationStream Function() create) {
    return ProviderOverride(
      origin: this,
      override: ServiceProviderLocationStreamProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<ServiceProviderLocationStream,
      LatLng> createElement() {
    return _ServiceProviderLocationStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceProviderLocationStreamProvider &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ServiceProviderLocationStreamRef
    on AutoDisposeStreamNotifierProviderRef<LatLng> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _ServiceProviderLocationStreamProviderElement
    extends AutoDisposeStreamNotifierProviderElement<
        ServiceProviderLocationStream,
        LatLng> with ServiceProviderLocationStreamRef {
  _ServiceProviderLocationStreamProviderElement(super.provider);

  @override
  String get userId => (origin as ServiceProviderLocationStreamProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
