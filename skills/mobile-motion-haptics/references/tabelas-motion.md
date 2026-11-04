# Tabelas de motion e haptics

## Tokens de mola M3 Expressive (massa = 1)

| Token | Expressive ζ / k | Expressive: settle / overshoot | Fallback Expressive | Standard ζ / k | Standard: settle / overshoot | Fallback Standard |
| --- | --- | --- | --- | --- | --- | --- |
| fast-spatial | 0.6 / 800 | 420ms (360ms a 0.1%) / 9.4–9.5% | `cubic-bezier(0.42, 1.67, 0.21, 0.90)` 350ms | 0.9 / 1400 | 229ms | `cubic-bezier(0.27, 1.06, 0.18, 1.00)` 350ms |
| default-spatial | 0.8 / 380 | 475ms (435ms a 0.1%) / 1.5% | `cubic-bezier(0.38, 1.21, 0.22, 1.00)` 500ms | 0.9 / 700 | 324ms / 0.2% | `cubic-bezier(0.27, 1.06, 0.18, 1.00)` 500ms |
| slow-spatial | 0.8 / 200 | 655ms (600ms a 0.1%) / 1.5% | `cubic-bezier(0.39, 1.29, 0.35, 0.98)` 650ms | 0.9 / 300 | 496ms | `cubic-bezier(0.27, 1.06, 0.18, 1.00)` 750ms |
| fast-effects | 1.0 / 3800 | 149ms / 0% | `cubic-bezier(0.31, 0.94, 0.34, 1.00)` 150ms | 1.0 / 3800 | 149ms / 0% | idem |
| default-effects | 1.0 / 1600 | 230ms / 0% | `cubic-bezier(0.34, 0.80, 0.34, 1.00)` 200ms | 1.0 / 1600 | 230ms / 0% | idem |
| slow-effects | 1.0 / 800 | 326ms / 0% | `cubic-bezier(0.34, 0.88, 0.34, 1.00)` 300ms | 1.0 / 800 | 326ms / 0% | idem |

Os componentes M3 usam principalmente expressive fast-spatial e expressive fast-effects internamente (tempos de settle e percentuais de overshoot acima são valores analíticos derivados da equação da mola para massa = 1).
Para web/motores sem mola: os fallbacks acima, ou a mola amostrada na função CSS `linear()` (até 40 pontos).

## SwiftUI: duração/bounce ↔ parâmetros físicos

Para massa 1:
- `stiffness = (2π / duration)²`
- `damping = 4π × (1 − bounce) / duration` (bounce ≥ 0)
- `damping = 4π / (duration × (1 + bounce))` (bounce < 0, sobreamortecida)

Ex.: `Spring(duration: 0.5, bounce: 0.3)` → stiffness ≈ 157.9.

| Preset | Equivalente físico | Assentamento / overshoot |
| --- | --- | --- |
| `.spring()` (response 0.5–0.55, dampingFraction 0.825) | k = 157.91, c = 20.73 | ~690ms / 1% |
| `.smooth` | k = 157.91, c = 25.13 | ~735ms / 0% |
| `.snappy` | k = 157.91, c = 21.36 | ~700ms / 0.6% |
| `.interactiveSpring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25)` | — | arrasto acoplado ao dedo |
| `.interpolatingSpring(mass: 1, stiffness: 170, damping: 15)` | — | inércia clássica (damping 5 = mais elástico) |

Compose `spring()` padrão (fora dos tokens M3): stiffness 1500, damping crítico → ~240ms, 0% overshoot.

## Conversão para Reanimated (3.x / 4.x)

No `react-native-reanimated`, `withSpring` opera em dois modos **mutuamente exclusivos** (não combine `dampingRatio` com `stiffness`/`damping`, pois `duration` e `dampingRatio` sobrescrevem os parâmetros físicos):
- **Modo físico (fiel aos tokens M3 `k` e `ζ`):** `withSpring(target, { mass: 1, stiffness: k, damping: 2 * ζ * Math.sqrt(k * 1) })` (passe `mass: 1` explicitamente, pois o `mass` padrão do `withSpring` na doc 4.x é **4**). Ex.: `default-spatial` expressive (`ζ = 0.8`, `k = 380`) → `damping = 2 × 0.8 × √380 ≈ 31.2`.
- **Modo baseado em duração (Reanimated 3.2+):** `withSpring(target, { duration: 475, dampingRatio: 0.8 })`.

## Transições M3 (pares legados/fallback)

| Tipo | Duração | Curva |
| --- | --- | --- |
| Emphasized (começa e termina em tela) | 500ms | `cubic-bezier(0.2, 0, 0, 1)` |
| Emphasized decelerate (entrada) | 400ms | `cubic-bezier(0.05, 0.7, 0.1, 1)` |
| Emphasized accelerate (saída) | 200ms | `cubic-bezier(0.3, 0, 0.8, 0.15)` |
| Standard | 300ms | `cubic-bezier(0.2, 0, 0, 1)` |
| Standard decelerate (entrada) | 250ms | `cubic-bezier(0, 0, 0, 1)` |
| Standard accelerate (saída) | 200ms | `cubic-bezier(0.3, 0, 1, 1)` |

Fade do scrim: 300ms independente (sheets); 150ms iniciais no container transform.

## Haptics — detalhamento

| Contexto | iOS | Android |
| --- | --- | --- |
| Toque leve, alinhamento, tick de roleta | `UIImpactFeedbackGenerator(style: .light)` / `.soft`; `UISelectionFeedbackGenerator`; `UICanvasFeedbackGenerator` (iOS 17.5+) | `performHapticFeedback` com `CLOCK_TICK` (API 21+), `TEXT_HANDLE_MOVE` (API 27+), `SEGMENT_TICK` / `SEGMENT_FREQUENT_TICK` (API 34+) |
| Ativar controle padrão | `.medium` | `CONFIRM` (API 30+), `VibrationEffect.EFFECT_CLICK` / `EFFECT_DOUBLE_CLICK` (API 29+) |
| Impacto firme, long press, colisão | `.heavy` / `.rigid` | `LONG_PRESS` (API 3+), `GESTURE_START` (API 30+), `EFFECT_HEAVY_CLICK` (API 29+) |
| Sucesso / erro de validação | `UINotificationFeedbackGenerator` `.success/.warning/.error` | `CONFIRM` / `REJECT` (API 30+) |
| Padrões e texturas | Core Haptics (iOS 13+, iPhone 8+): intensidade e sharpness | `VibrationEffect` (API 26+; predefinidos API 29+; composição API 31+) |
| Permissão / ciclo de vida | Nenhuma; `prepare()`/liberar; simulador não suporta Core Haptics | `HapticFeedbackConstants` sem permissão; `VibrationEffect` exige `android.permission.VIBRATE` |

Na literatura da indústria, háptico bem aplicado aumenta precisão de tarefa em até ~20% e reduz o tempo de
resposta percebido — use isso para justificar, não para espalhar vibração em todo toque.
