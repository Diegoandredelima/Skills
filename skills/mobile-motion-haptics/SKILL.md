---
name: mobile-motion-haptics
description: Motion design, microinterações e feedback háptico em apps mobile — física de molas (stiffness, damping ratio), tokens de movimento M3 Expressive (spatial vs. effects, fast/default/slow) e fallbacks cubic-bezier, springs do SwiftUI (.spring(duration:bounce:), .smooth, .snappy), Reanimated withSpring, limiares de 100/300/1000ms, transições de tela assimétricas (saída 50–60% da entrada), container transform / shared element, Reduce Motion, e mapeamento de haptics (UIImpactFeedbackGenerator, Core Haptics, HapticFeedbackConstants, expo-haptics). Use sempre que for criar, ajustar ou revisar animação, transição, microinteração, loading/progresso ou vibração em app — mesmo quando o pedido for só "deixar mais fluido", "animação estranha" ou "dar um feedback ao tocar".
---

# Motion e haptics mobile

Parte do conjunto `mobile-ui-ux`. Tabelas completas (tokens M3, presets SwiftUI, haptics por evento):
`references/tabelas-motion.md`.

## Limiares de percepção

- **≤ 100ms** — instantâneo, sensação de manipulação direta: switch, checkbox, radio.
- **≤ 300ms** — conectado: a maioria das transições de UI termina aqui (cards, campos ~250ms).
- **> 1000ms** — perde o fluxo: mostre indicador de progresso (e skeleton/placeholder antes disso, se o
  conteúdo tem forma conhecida).

## Molas em vez de duração fixa

Apple (desde iOS 7) e Google (M3 Expressive, mai/2025) usam **física de molas** como motor principal. Molas
reagem a velocidade e posição a cada frame, então gestos, interrupções no meio e mudança de alvo saem
naturais — uma curva de duração fixa precisa recomeçar.

Parâmetros: **stiffness (k)** — maior resolve mais rápido; **damping ratio (ζ)** — 1.0 = amortecimento
crítico, sem bounce; < 1.0 passa do alvo e oscila; **velocidade inicial** — herde a do gesto.

### Regra dos dois tipos (M3)

- **Spatial** (posição, tamanho, escala, rotação, cantos, morphing): pode ter overshoot.
- **Effects** (cor, opacidade, elevação): **sem overshoot**, ζ = 1.0 — cor que "passa do ponto" parece defeito.

Velocidades: **fast** para elementos pequenos (botão, switch), **default** para a maioria, **slow** para
elementos grandes/tela cheia (sheet, drawer). Esquema **Expressive** (padrão, com bounce) ou **Standard**
(funcional, bounce mínimo) — escolha um por produto e mantenha.

Valores mais usados (massa 1):

| Token | Expressive ζ / k | Standard ζ / k | Fallback bezier (Expressive) |
| --- | --- | --- | --- |
| fast-spatial | 0.6 / 800 | 0.9 / 1400 | `cubic-bezier(0.42, 1.67, 0.21, 0.90)` 350ms |
| default-spatial | 0.8 / 380 | 0.9 / 700 | `cubic-bezier(0.38, 1.21, 0.22, 1.00)` 500ms |
| slow-spatial | 0.8 / 200 | 0.9 / 300 | `cubic-bezier(0.39, 1.29, 0.35, 0.98)` 650ms |
| fast-effects | 1.0 / 3800 | igual | `cubic-bezier(0.31, 0.94, 0.34, 1.00)` 150ms |
| default-effects | 1.0 / 1600 | igual | `cubic-bezier(0.34, 0.80, 0.34, 1.00)` 200ms |
| slow-effects | 1.0 / 800 | igual | `cubic-bezier(0.34, 0.88, 0.34, 1.00)` 300ms |

### Por plataforma

- **Compose:** `MotionScheme.expressive()` / `standard()` (API Expressive experimental, opt-in);
  `spring(dampingRatio = 0.8f, stiffness = 380f)`. O `spring()` padrão do Compose (fora do M3) é
  stiffness 1500 / damping crítico (~240ms, sem overshoot).
- **SwiftUI:** `Spring(duration:bounce:)` — bounce 0 = crítico; até 1.0 mais elástico (≥ 0.3 = exagerado);
  negativo = sobreamortecido. Presets: `.spring()` (~690ms, 1% overshoot), `.smooth` (sem overshoot),
  `.snappy` (0.6%). Arrasto: `.interactiveSpring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25)`.
- **React Native (Reanimated 3+):** `withSpring(v, { dampingRatio: 0.8, stiffness: 380 })` (spatial default
  expressive); `withTiming(v, { duration: 200, easing: Easing.bezier(0.34, 0.8, 0.34, 1) })` para effects.
  Rode no UI thread (worklets); nunca anime layout pesado por `setState` a cada frame.
- **Flutter:** `SpringDescription.withDampingRatio(mass: 1, stiffness: 380, ratio: 0.8)`.

## Transições de tela

**Assimetria:** entrar e sair com a mesma duração deixa o fechamento lento — o usuário já terminou
mentalmente. Saída ≈ **50–60%** da entrada (razão ~1.5:1), curva *accelerate*, **sem** bounce.

| Par M3 (legado/fallback) | Entrada | Saída | Em tela |
| --- | --- | --- | --- |
| Emphasized (tela cheia, hero) | 400ms `cubic-bezier(0.05, 0.7, 0.1, 1)` | 200ms `cubic-bezier(0.3, 0, 0.8, 0.15)` | 500ms `cubic-bezier(0.2, 0, 0, 1)` |
| Standard (utilitárias) | 250ms `cubic-bezier(0, 0, 0, 1)` | 200ms `cubic-bezier(0.3, 0, 1, 1)` | 300ms `cubic-bezier(0.2, 0, 0, 1)` |

Duração por distância: `base + distância_px × 0.8` ms, entre 100 e 500ms.

**Scrim de sheet/modal — derive da posição, não anime à parte.** Em vez de uma segunda animação de
opacidade, calcule a opacidade do scrim a partir da posição do sheet (`interpolate(translateY, [fechado,
aberto], [0, 0.32], Extrapolation.CLAMP)` no Reanimated; `lerp` sobre a fração de abertura no Compose/SwiftUI).
Assim o scrim acompanha abrir, fechar e o arrasto do dedo automaticamente, nunca dessincroniza e não tem como
quicar, mesmo que a mola do sheet tenha overshoot (o clamp corta). Opacidade máxima: 32% (`scrim` do M3).
Só anime o scrim separadamente quando não houver uma posição contínua para derivar (ex.: diálogo central que
aparece por fade) — e então com effects (sem overshoot).

**Container transform / shared element:** o card se expande no detalhe enquanto o scrim faz fade-in nos
primeiros **150ms**; se o usuário arrastar para baixo no meio, reverta do estado atual com mola (não
recomece). No iOS 26 com vidro, use `.glassEffectID("id", in: ns)` dentro de `GlassEffectContainer` no lugar
de `.matchedGeometryEffect()`.

## Reduce Motion (obrigatório)

Com Reduce Motion ligado (`UIAccessibility.isReduceMotionEnabled`, `prefers-reduced-motion`,
`AccessibilityInfo.isReduceMotionEnabled()` / `useReducedMotion()` no Reanimated, `ANIMATOR_DURATION_SCALE`
no Android): movimento espacial vira **0ms** (snap) ou **cross-fade** com fast-effects (150ms). Effects simples
podem continuar.

## Haptics

Háptico confirma ação, não decora. Mapeamento semântico:

| Evento | iOS | Android | Expo |
| --- | --- | --- | --- |
| Tick, seleção, alinhamento a guia | `UISelectionFeedbackGenerator`, impact `.light`/`.soft` | `CLOCK_TICK`, `SEGMENT_TICK`, `TEXT_HANDLE_MOVE` | `selectionAsync()` |
| Ativar controle (toggle, tap) | impact `.medium` | `CONFIRM` / `EFFECT_CLICK` | `impactAsync(Medium)` |
| Long press, impacto firme | impact `.heavy` / `.rigid` | `LONG_PRESS`, `GESTURE_START`, `EFFECT_HEAVY_CLICK` | `impactAsync(Heavy)` |
| Sucesso / aviso / erro | `UINotificationFeedbackGenerator` `.success/.warning/.error` | `CONFIRM` / `REJECT` | `notificationAsync(Success/Warning/Error)` |
| Padrão contínuo/textura | Core Haptics (`CHHapticEngine`) | `VibrationEffect` composição (API 31+) | — |

Regras:
- **≥ 100ms** entre pulsos (senão vira zumbido). Padrões compostos: pausas de 250 / 500 / 1000ms.
- Android: prefira `View.performHapticFeedback(HapticFeedbackConstants.*)` — **não exige permissão**.
  `VibrationEffect` exige `VIBRATE`.
- iOS: sem permissão; chame `prepare()` antes de momentos sensíveis à latência.
- Sempre um feedback visual equivalente (aparelho em modo silencioso ou háptico desligado).
- Teste em aparelho físico — simulador iOS não reproduz Core Haptics.

## Checklist rápido de revisão

- [ ] Geometria com mola; cor/opacidade sem overshoot.
- [ ] Saída mais curta que entrada, sem bounce.
- [ ] Animações de UI ≤ 300ms; > 1s tem progresso.
- [ ] Interromper no meio funciona (gesto reverte do ponto atual).
- [ ] Scrim derivado da posição do sheet (ou, se separado, sem overshoot), máx. 32%.
- [ ] Reduce Motion respeitado.
- [ ] Háptico só em eventos com significado, ≥ 100ms de intervalo, com equivalente visual.
