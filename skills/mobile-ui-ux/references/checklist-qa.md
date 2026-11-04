# Checklist de validação de design e QA (auditoria pré-release)

Use na revisão de uma tela, de um fluxo ou do app inteiro. Para cada item: marque OK / achado / não se aplica;
num achado, registre a tela, o critério violado, a severidade (bloqueia / alta / média / baixa) e a correção.
A skill especializada de cada pilar tem o detalhe para corrigir.

## 1. Fundamentos e adaptação — `mobile-layout-navigation`

- [ ] **Breakpoints e navegação.** < 600dp (Compact): 1 painel, margens 16dp/pt, Navigation Bar / Tab Bar
  (máx. 5 abas no iPhone). 600–839dp (Medium): margens 24dp/pt, Navigation Rail / Flexible Nav Bar, ou
  Sidebar recolhida (iPad retrato). ≥ 840dp: 2 painéis (lista 360dp + espaçador 24dp), Sidebar expandida 320pt
  (iPad paisagem; ou Tab Bar flutuante adaptativa) / Extended Rail 256dp.
  *Verificação:* redimensionar janela no iPadOS 26, emulador dobrável, preview multi-dispositivo.
- [ ] **Thumb zone e gesto de voltar.** Ação primária na metade inferior; destrutiva longe do polegar, com
  confirmação e sem papel de primária. Predictive Back (habilitado por padrão; `android:enableOnBackInvokedCallback="false"` apenas para sair; exige Activity 1.6.0+ / `OnBackPressedCallback` ou `PredictiveBackHandler`/`BackHandler` no Compose 1.8.0+, sem interceptar `onBackPressed`/`KEYCODE_BACK`; no Android 13/14 dependia de opção de desenvolvedor e do Android 15 em diante aparece para os apps que suportam) e back swipe (iOS) funcionando;
  `systemGestureExclusion()` em carrosséis horizontais.
  *Verificação:* uso com uma mão no maior telefone suportado; cancelar o gesto de voltar no meio.

## 2. Componentes e layout — `mobile-layout-navigation`

- [ ] **Grid, raios concêntricos e largura máxima.** Espaçamentos múltiplos de 4/8dp. Raio interno = externo −
  padding (48 − 16 = 32dp). Formulário ≤ 560dp; corpo de leitura 840–1040dp; 40–60 caracteres por linha.
  *Verificação:* inspeção em tablet (1024pt+ / 1200dp+); tipos de espaçamento validados em compilação.
- [ ] **Edge-to-edge, SafeArea e teclado.** `enableEdgeToEdge()` antes de `setContent`; `adjustResize`;
  `safeDrawing` + `consumeWindowInsets` + `imePadding()`. Nenhum campo focado coberto por teclado ou barra
  fixa (WCAG 2.4.11).
  *Verificação:* teclado externo; abrir o teclado no último campo de cada tela.

## 3. Cores e tokens — `mobile-design-tokens`

- [ ] **Semântica, elevação tonal e modo escuro.** Zero hex/RGB hardcoded na UI. 5 níveis de
  surface-container e pares `on-*` corretos. `outline` em campos, `outline-variant` em divisores. Elevação
  comunicada pelos 5 `surface-containers` (ou `surfaceTint` +5% a +14% primary de 1 a 12dp onde aplicável).
  *Verificação:* preview em modo noturno, dynamic color ligado (Android 12+), contraste médio e alto.
- [ ] **Liquid Glass (iOS 26).** Vidro só na camada de navegação/controles; nada em conteúdo; nada de vidro
  sobre vidro; agrupar elementos próximos em `GlassEffectContainer`; camada escura de 35% sob a variante clear em mídia clara.
  *Verificação:* Instruments (GPU), Reduce Transparency, Increase Contrast, modos de aparência Clear e Tinted.

## 4. Motion e haptics — `mobile-motion-haptics`

- [ ] **Molas, assimetria e Reduce Motion.** Molas spatial (ζ 0.6–0.9) para geometria; effects (ζ = 1.0, sem
  overshoot) para cor/opacidade. Saída = 50–60% da entrada (ex.: 200 vs. 400ms), curva accelerate, sem
  bounce. Reduce Motion: 0ms espacial ou cross-fade.
  *Verificação:* ligar Reduce Motion no sistema; animações em câmera lenta (escala de tempo 10×).
- [ ] **Háptico.** `HapticFeedbackConstants` (sem permissão VIBRATE à toa) e `UIFeedbackGenerator` / Core
  Haptics; ≥ 100ms entre pulsos; indicador visual alternativo em modo silencioso.
  *Verificação:* aparelho físico iOS e Android (simulador não vibra).

## 5. Acessibilidade — `mobile-accessibility`

- [ ] **Contraste, alvos e gestos.** Texto ≥ 4.5:1; texto grande, ícones e foco ≥ 3:1 — em claro, escuro e
  sobre vidro. Alvos ≥ 44×44pt (iOS), ≥ 48×48dp (Android), ≥ 60×60pt (visionOS). Alternativa de toque
  simples para todo arrasto (WCAG 2.5.7).
  *Verificação:* Accessibility Inspector (Xcode), Stark (Figma), Accessibility Scanner (Android), em aparelho.
- [ ] **Escala extrema e leitores de tela.** Sem cortes até AX5 (Body 53pt, Large Title 60pt) e 200%
  não linear no Android 14+; linhas viram pilhas. Rótulo descritivo em todo controle; ordem lógica no
  VoiceOver e TalkBack.
  *Verificação:* texto no máximo; navegação completa com VoiceOver e TalkBack.

## 6. Segurança e privacidade — `mobile-ui-security`

- [ ] **Biometria, telas sensíveis e permissões.** BIOMETRIC_STRONG com `CryptoObject` (Keystore) e chave EC
  no Secure Enclave. `KeyPermanentlyInvalidatedException` e lockout tratados sem crash. FLAG_SECURE (inclusive
  em Dialogs) ou `setRecentsScreenshotEnabled(false)` (Android 13+); máscara no iOS. Colar permitido no login
  (WCAG 3.3.8). Photo Picker / PHPicker; funciona com localização aproximada.
  *Verificação:* OWASP MASTG-TEST-0292; cadastrar nova digital/rosto para testar invalidação; revogar
  permissões com o app aberto.

## Formato do relatório

```
## Revisão de UI — <tela/fluxo>, <plataformas>
Resumo: N achados (x bloqueiam, y altos…)

### <Pilar>
- [Severidade] <Tela> — <o que está errado> — viola <critério> — corrigir: <como>
```
