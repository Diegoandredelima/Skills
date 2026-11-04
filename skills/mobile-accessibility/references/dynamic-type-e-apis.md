# Dynamic Type e APIs de acessibilidade por framework

## iOS Dynamic Type — tamanhos (pt; altura de linha entre parênteses quando conhecida)

| Estilo | Large (padrão) | AX2 | AX5 |
| --- | --- | --- | --- |
| Large Title | 34 | — | 60 (70) |
| Title 1 | 28 | — | 58 (68) |
| Title 2 | 22 | — | 56 (66) |
| Title 3 | 20 | — | 55 (65) |
| Headline | 17 semibold | — | 53 (62) |
| Body | 17 (22) | 33 | 53 (62) |
| Callout | 16 | — | 51 |
| Subheadline | 15 | — | — |
| Footnote | 13 | — | — |
| Caption 1 | 12 | — | — |
| Caption 2 | 11 (mínimo) | — | — |

Escala: xSmall, Small, Medium, **Large (padrão)**, xLarge, xxLarge, xxxLarge (+33–36%), AX1…AX5.

## Android — exemplos sob escala não linear (Android 14+, até 200%)

| Estilo | Base | Comportamento |
| --- | --- | --- |
| Body Medium | 14sp / 20sp | cresce pelo fator total |
| Body Large | 16sp / 24sp | cresce pelo fator total |
| Title Large | 22sp / 28sp | cresce menos |

## APIs

### SwiftUI / UIKit
- Rótulo/valor/dica: `.accessibilityLabel`, `.accessibilityValue`, `.accessibilityHint`.
- Agrupar: `.accessibilityElement(children: .combine)`; ações: `.accessibilityAction(named:)`.
- Decorativo: `.accessibilityHidden(true)`; `Image(decorative:)`.
- Papel/estado: `.accessibilityAddTraits(.isButton / .isSelected / .isHeader)`.
- Fonte: `.font(.body)`; `@Environment(\.dynamicTypeSize)`, `dynamicTypeSize.isAccessibilitySize`;
  `UIFontMetrics(forTextStyle:).scaledFont(for:)` para fonte própria; `@ScaledMetric` para espaçamentos/ícones.
- Anúncio: `AccessibilityNotification.Announcement("Salvo").post()`.
- Preferências: `accessibilityReduceMotion`, `accessibilityReduceTransparency`, `colorSchemeContrast`.

### Jetpack Compose
- `Modifier.semantics { contentDescription = "…"; stateDescription = "…"; role = Role.Button }`.
- Agrupar: `Modifier.semantics(mergeDescendants = true) {}` / `clearAndSetSemantics`.
- Decorativo: `contentDescription = null` em `Image`/`Icon`.
- Cabeçalho: `semantics { heading() }`; live region: `liveRegion = LiveRegionMode.Polite`.
- Alvo: `Modifier.minimumInteractiveComponentSize()` (48dp).
- Ações customizadas: `customActions = listOf(CustomAccessibilityAction("Mover para cima") { … })`.

### Flutter
- `Semantics(label:, button: true, selected:, header:)`, `MergeSemantics`, `ExcludeSemantics`.
- `MediaQuery.textScalerOf(context)`; `SemanticsService.announce`.

### React Native / Expo
- `accessibilityLabel`, `accessibilityHint`, `accessibilityRole` ("button", "header", "switch"…),
  `accessibilityState={{ selected, disabled, checked, expanded }}`, `accessibilityValue`.
- Agrupar: `accessible` no contêiner (filhos lidos juntos); ações: `accessibilityActions` + `onAccessibilityAction`.
- Decorativo: `accessible={false}`, `importantForAccessibility="no-hide-descendants"` (Android),
  `accessibilityElementsHidden` (iOS).
- Alvo: `hitSlop` / `minHeight: 48`.
- Fonte: `allowFontScaling` (padrão true), `maxFontSizeMultiplier` só onde a plataforma fixa (tab bar);
  `useWindowDimensions().fontScale` para trocar linha → coluna.
- Anúncio: `AccessibilityInfo.announceForAccessibility("Salvo")`.
- Preferências: `AccessibilityInfo.isReduceMotionEnabled()`, `isScreenReaderEnabled()`, `isBoldTextEnabled()`.
- Foco: `AccessibilityInfo.setAccessibilityFocus(findNodeHandle(ref))` ao abrir modal.
