/// Why a generation failed, as far as callers need to react differently.
enum CcAiFailureKind {
  /// The device failed app attestation (emulator, rooted, not genuine);
  /// retrying will not help and the UI can say so.
  deviceAttestation,

  /// Any other failure (network, quota, server, invalid response).
  unknown,
}

