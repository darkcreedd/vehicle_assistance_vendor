class EmergencyRequest {
  final String id;
  final String userId;
  final String providerId;
  final String description;

  final String createdAt;

  final EmergencyStatus status;

  final String providerName;

  final String providerImageUrl;

  final String providerPhone;

  EmergencyRequest({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.description,
    required this.createdAt,
    required this.status,
    required this.providerName,
    required this.providerImageUrl,
    required this.providerPhone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'providerId': providerId,
      'description': description,
      'createdAt': createdAt,
      'status': status.name,
      'providerName': providerName,
      'providerImageUrl': providerImageUrl,
      'providerPhone': providerPhone
    };
  }

  factory EmergencyRequest.fromMap(Map<String, dynamic> map) {
    return EmergencyRequest(
        providerPhone: map['providerPhone'],
        id: map['id'],
        userId: map['userId'],
        providerId: map['providerId'],
        description: map['description'],
        createdAt: map['createdAt'],
        status: EmergencyStatus.values.byName(map['status']),
        providerName: map['providerName'],
        providerImageUrl: map['providerImageUrl']);
  }

  EmergencyRequest copyWith({
    String? id,
    String? userId,
    String? providerId,
    String? description,
    String? createdAt,
    EmergencyStatus? status,
    String? providerName,
    String? providerImageUrl,
    String? providerPhone,
  }) {
    return EmergencyRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      providerId: providerId ?? this.providerId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      providerName: providerName ?? this.providerName,
      providerImageUrl: providerImageUrl ?? this.providerImageUrl,
      providerPhone: providerPhone ?? this.providerPhone,
    );
  }
}

enum EmergencyStatus {
  pending,
  accepted,
  rejected,
}
