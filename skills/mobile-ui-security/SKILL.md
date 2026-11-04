---
name: mobile-ui-security
description: Segurança e privacidade no design de apps mobile (UI/UX security) — biometria atrelada a hardware criptográfico (BiometricPrompt + CryptoObject/Keystore/StrongBox, LocalAuthentication + Secure Enclave), classes BIOMETRIC_STRONG/WEAK/DEVICE_CREDENTIAL, fallback, lockout e invalidação de chave por nova biometria, proteção de telas sensíveis (FLAG_SECURE, setRecentsScreenshotEnabled, máscara no app switcher, gravação de tela), permissões just-in-time e granulares (Photo Picker, PHPicker, contatos, localização aproximada, permissões únicas), ATT, Privacy Manifest e Data Safety. Use sempre que for implementar ou revisar login biométrico, desbloqueio do app, telas com dados sensíveis, pedidos de permissão (câmera, galeria, localização, contatos, notificações) ou auditoria OWASP MASVS/MASTG da camada de interface — inclusive com expo-local-authentication, expo-secure-store e expo-screen-capture.
---

# Segurança e privacidade na interface mobile

Parte do conjunto `mobile-ui-ux`. Tabela de erros biométricos e trechos de código: `references/biometria.md`.

## 1. Biometria: gate de UI ≠ segurança

Um diálogo biométrico que só retorna "ok/falhou" é uma **barreira visual** — num aparelho comprometido basta
forçar o retorno. Segurança real encadeia quatro camadas:

1. diálogo nativo (`BiometricPrompt` / `LocalAuthentication`);
2. chave em hardware isolado (Android Keystore/StrongBox; iOS Secure Enclave) que **só é liberada** pela biometria;
3. operação criptográfica com essa chave (assinar um nonce do servidor, decifrar um token);
4. **validação no servidor** da assinatura.

Se o requisito é só conveniência local (ex.: reabrir o app já logado), o gate simples pode bastar — mas diga
isso explicitamente; não chame de "autenticação forte".

**Android:** `BIOMETRIC_STRONG` (classe 3: digital, rosto 3D certificado) é o único que destrava chave do
Keystore; `BIOMETRIC_WEAK` (classe 2, rosto 2D) é conveniência e **não** destrava `CryptoObject`;
`DEVICE_CREDENTIAL` = PIN/padrão/senha. Chave com `setUserAuthenticationRequired(true)`,
`setUserAuthenticationParameters(0, KeyProperties.AUTH_BIOMETRIC_STRONG)` (API 30+; auth por uso em operação de
alto valor, ou timeout curto, ex. 60s) e `setInvalidatedByBiometricEnrollment(true)` (API 24+); passe o
`Cipher`/`Signature` em `BiometricPrompt.CryptoObject`.

**iOS:** `NSFaceIDUsageDescription` no Info.plist; par EC P-256 no Secure Enclave com
`kSecAccessControlBiometryCurrentSet` (invalida ao cadastrar nova biometria) ou `BiometryAny`, e
`kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`. Disponibilidade com `canEvaluatePolicy`:
`.deviceOwnerAuthenticationWithBiometrics` (só biometria) ou `.deviceOwnerAuthentication` (com fallback para o
código do aparelho).

**React Native/Expo:** `expo-local-authentication` sozinho é gate de UI. Para proteger um segredo, guarde-o
com `expo-secure-store` e `requireAuthentication: true` (Keychain/Keystore exigem biometria para ler; requer
Android 6.0+ / API 23+ e build nativo com `NSFaceIDUsageDescription` no iOS, sem suporte no Expo Go) ou use
biblioteca nativa que assine com chave em hardware.

### Fluxos que a UI precisa tratar

- **Sem biometria cadastrada / sem hardware:** ofereça senha; no Android 30+, atalho para cadastro
  (`Settings.ACTION_BIOMETRIC_ENROLL`).
- **Falhas e lockout (~5 tentativas):** nunca prenda o usuário num loop de prompts; no lockout, vá direto para
  código do aparelho ou senha da conta.
- **Chave invalidada** (nova digital/rosto — `KeyPermanentlyInvalidatedException` / falha no item do
  Keychain): sem crash e sem erro genérico. Explique que a biometria do aparelho mudou, peça login por senha e
  gere chave nova.
- **Fallback:** com `DEVICE_CREDENTIAL` é **proibido** `setNegativeButtonText()`; para fluxo de senha próprio,
  use botão negativo e não inclua `DEVICE_CREDENTIAL`.

## 2. Telas sensíveis

**Android**
- `FLAG_SECURE` antes de `setContentView()` em cada Activity sensível: bloqueia print, gravação
  (MediaProjection) e a miniatura em Recentes.
- Dialog, Spinner, AutoComplete têm **janela própria** — aplique `FLAG_SECURE` em cada uma.
- Android 13+ (API 33): para esconder só a miniatura de Recentes e **ainda permitir print manual**, use
  `setRecentsScreenshotEnabled(false)` no `onCreate()` (OWASP MASTG-TEST-0292).

**iOS**
- Ao ir para background, cubra com máscara opaca/desfocada (o snapshot do app switcher é tirado nesse momento).
- Detecte gravação/espelhamento ativo e mascare o conteúdo enquanto durar.
- Campo de senha: nunca bloqueie colar nem gerenciador de senhas (WCAG 3.3.8).

**React Native/Expo:** `expo-screen-capture` (`preventScreenCaptureAsync`/`usePreventScreenCapture`) ou ponte
nativa própria. Confirmações de dados sensíveis devem ficar dentro da árvore React protegida — no Android,
janelas nativas separadas (`Alert.alert`, `Dialog` e `<Modal>` antes do React Native 0.78) criam um `Window`
próprio (`dialog.getWindow()`) que pode não herdar `FLAG_SECURE` da `Activity`.

## 3. Permissões just-in-time e granulares

Princípio: peça **no momento** em que a funcionalidade é usada, explique o valor em contexto antes do prompt
do sistema, e prefira APIs que **não precisam** de permissão.

- **Fotos/arquivos:** Photo Picker (`ActivityResultContracts.PickVisualMedia()`) e Storage Access Framework no
  Android; `PHPickerViewController` no iOS — devolvem só o que o usuário escolheu, sem permissão.
  Expo: `expo-image-picker` usa o seletor do sistema.
- **Contatos:** `CNContactPickerViewController` (iOS) / intent de seleção (Android) em vez de ler a agenda toda.
- **Acesso limitado** (fotos; contatos desde iOS 18): um conjunto reduzido é escolha válida, não erro — não
  insista nem trate como falha.
- **Localização:** desenhe para funcionar com **aproximada** (`ACCESS_COARSE_LOCATION`); peça precisa só
  quando a tarefa exige; ofereça entrada manual se recusar. Android 11+ tem permissão única (localização,
  câmera, microfone) e auto-reset em apps sem uso — o app deve pedir de novo com naturalidade.
- **Recusa:** a funcionalidade degrada com explicação e caminho para Ajustes; o resto do app continua.
- **Notificações e rastreamento:** prompt ATT obrigatório no iOS para rastrear; recusa não pode ser
  contornada com outro identificador. Badge vermelho só para o crítico.
- **Dados:** nada sensível em logs ou crash reports; Privacy Manifest de cada SDK coerente com App Store
  Privacy Details e Google Play Data Safety.

## Checklist de revisão

- [ ] Biometria protege uma chave em hardware e o servidor valida (ou está documentado que é só conveniência).
- [ ] Android usa BIOMETRIC_STRONG para operações sensíveis; nenhuma combinação proibida de fallback.
- [ ] Lockout, sem cadastro e chave invalidada têm saída clara, sem crash.
- [ ] Telas sensíveis protegidas (incluindo diálogos) e mascaradas no app switcher.
- [ ] Colar permitido em senha; gerenciador de senhas funciona.
- [ ] Seletores do sistema no lugar de permissões amplas; app funciona com acesso limitado e localização aproximada.
- [ ] Permissões pedidas em contexto, com degradação graciosa na recusa.
- [ ] Logs sem dados sensíveis; declarações de privacidade coerentes.
