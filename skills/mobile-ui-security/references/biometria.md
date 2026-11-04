# Biometria: erros, fallbacks e código de referência

## Tabela de exceções

| Situação | iOS (LAError) | Android (BiometricPrompt) | UI recomendada |
| --- | --- | --- | --- |
| Configurar fallback | `.deviceOwnerAuthentication` cai no código do iOS; `.deviceOwnerAuthenticationWithBiometrics` mostra botão de fallback (`userFallback = -3`) | `setAllowedAuthenticators(BIOMETRIC_STRONG or DEVICE_CREDENTIAL)`; **proibido** `setNegativeButtonText()` com `DEVICE_CREDENTIAL` | `DEVICE_CREDENTIAL` para fallback do sistema, ou botão negativo para senha própria do app |
| Biometria não cadastrada / sem hardware | `biometryNotEnrolled (-7)` / `biometryNotAvailable (-6)` | `BIOMETRIC_ERROR_NONE_ENROLLED` / `BIOMETRIC_ERROR_NO_HARDWARE` | Android 30+: `Intent(Settings.ACTION_BIOMETRIC_ENROLL)` com `EXTRA_BIOMETRIC_AUTHENTICATORS_ALLOWED`; senão, login por senha |
| Falhas e lockout (~5) | `authenticationFailed (-1)`; depois `biometryLockout (-8)` | callback de falha repetível; depois lockout temporário/permanente | Sem loop de prompts; no lockout, código do aparelho ou senha da conta |
| Nova biometria cadastrada | Falha ao ler item com `BiometryCurrentSet` | `KeyPermanentlyInvalidatedException` ao iniciar o `Cipher` | Explicar a mudança, pedir senha, gerar nova chave; nunca crash |

## Android (Kotlin) — chave ligada a biometria forte

```kotlin
val spec = KeyGenParameterSpec.Builder("chave_login", KeyProperties.PURPOSE_SIGN)
    .setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1"))
    .setDigests(KeyProperties.DIGEST_SHA256)
    .setUserAuthenticationRequired(true)
    .setUserAuthenticationParameters(0, KeyProperties.AUTH_BIOMETRIC_STRONG) // auth por uso (API 30+)
    .setInvalidatedByBiometricEnrollment(true) // API 24+
    .build()
KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, "AndroidKeyStore")
    .apply { initialize(spec) }.generateKeyPair()

val keyStore = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
val signature = Signature.getInstance("SHA256withECDSA").apply {
    initSign(keyStore.getKey("chave_login", null) as PrivateKey) // pode lançar KeyPermanentlyInvalidatedException
}
val promptInfo = BiometricPrompt.PromptInfo.Builder()
    .setTitle("Confirmar acesso")
    .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG)
    .setNegativeButtonText("Usar senha")
    .build()
biometricPrompt.authenticate(promptInfo, BiometricPrompt.CryptoObject(signature))
// onAuthenticationSucceeded: result.cryptoObject?.signature?.apply { update(nonceDoServidor); val assinatura = sign() }
```

Para cifrar token: `PURPOSE_ENCRYPT | PURPOSE_DECRYPT`, AES em CBC/PKCS7 ou GCM, `Cipher` no `CryptoObject`.

## iOS (Swift) — chave no Secure Enclave

```swift
let acesso = SecAccessControlCreateWithFlags(nil,
    kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
    [.privateKeyUsage, .biometryCurrentSet], nil)!
let atributos: [String: Any] = [
    kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
    kSecAttrKeySizeInBits as String: 256,
    kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
    kSecPrivateKeyAttrs as String: [
        kSecAttrIsPermanent as String: true,
        kSecAttrApplicationTag as String: "chave_login".data(using: .utf8)!,
        kSecAttrAccessControl as String: acesso,
    ],
]
let privada = SecKeyCreateRandomKey(atributos as CFDictionary, nil)
// Assinar o nonce: SecKeyCreateSignature(privada, .ecdsaSignatureMessageX962SHA256, nonce, &erro)
// — o sistema exibe o Face ID/Touch ID; o servidor valida com a chave pública registrada.
```

Verificar disponibilidade: `LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &erro)`.

## Expo / React Native

```ts
import * as SecureStore from 'expo-secure-store';
await SecureStore.setItemAsync('token', valor, {
  requireAuthentication: true,           // leitura exige biometria (Android 6.0+ / API 23+; build nativo com NSFaceIDUsageDescription no iOS)
  keychainAccessible: SecureStore.WHEN_UNLOCKED_THIS_DEVICE_ONLY, // iOS (kSecAttrAccessible)
});
// Ler pode falhar se a biometria mudou: tratar como "pedir senha e regravar".
```

`expo-local-authentication.authenticateAsync()` sozinho é gate de UI (útil para conveniência, não para
proteger segredo). Em app com SQLCipher/chaves locais, a chave deve ficar no SecureStore, nunca em
AsyncStorage.
