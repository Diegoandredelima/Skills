# Mapeamento por framework

Como cada decisão do design system aparece em Jetpack Compose, SwiftUI, Flutter e React Native/Expo.
As linhas de React Native/Expo acrescentam as bibliotecas usuais do ecossistema; confirme versões no
`package.json` do projeto antes de sugerir dependência nova (e prefira o que já está instalado).

## Theming e cores dinâmicas

| Framework | Como fazer |
| --- | --- |
| Compose | `MaterialTheme(colorScheme, typography, shapes)`; `dynamicLightColorScheme(ctx)` / `dynamicDarkColorScheme(ctx)` no Android 12+, com fallback `lightColorScheme()` / `darkColorScheme()` via `isSystemInDarkTheme()`. |
| SwiftUI | Cores semânticas do sistema (`label` … `quaternaryLabel`, `.primary`, `.secondary`); Liquid Glass via `.glassEffect()` (regular por padrão, em cápsula; variante clear) coordenado por `GlassEffectContainer`. |
| Flutter | `ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(...))`; superfície por elevação (`surfaceAtElevation`); harmonizar cor de marca com o primary em HCT. |
| React Native/Expo | Tokens exportados (`md.sys.*` ou JSON W3C Design Tokens) num objeto de tema; `useColorScheme()` para claro/escuro; nenhum hex no componente — sempre `theme.color.surface` etc. |

## Tipografia e escala dinâmica

| Framework | Como fazer |
| --- | --- |
| Compose | `MaterialTheme.typography` (15 estilos: `titleLarge` = 22.sp/28.sp, `bodyLarge` = 16.sp/24.sp, + variantes Emphasized). `sp` só em texto/altura de linha. |
| SwiftUI | `.font(.body)`, `.font(.headline)` etc. — Dynamic Type automático (xSmall → AX5); `@Environment(\.dynamicTypeSize)` e `.isAccessibilitySize` para trocar layout. |
| Flutter | `Theme.of(context).textTheme.bodyLarge` (16/24); Emphasized sobe o peso 400→500 ou 500→700 sem mudar a altura de linha; respeitar `MediaQuery.textScalerOf`. |
| React Native/Expo | Escala tipográfica tokenizada; manter `allowFontScaling` (padrão true); limitar com `maxFontSizeMultiplier` só em casos justificados (ex.: rótulos de tab bar); `PixelRatio.getFontScale()` para decidir trocar linha → pilha. |

## Formas e cantos

| Framework | Como fazer |
| --- | --- |
| Compose | `Shapes(extraSmall = 4.dp, small = 8.dp, medium = 12.dp, large = 16.dp, extraLarge = 28.dp)` + `MaterialShapes` (35 formas). |
| SwiftUI | `ConcentricRectangle`, `Capsule`, `.glassEffectID("id", in: ns)` para metamorfose de vidro. |
| Flutter | Escala 0/4/8/12/16/28/full; bordas 0/1/2/4dp. |
| React Native/Expo | Tokens de raio (0–48 e 9999 para pílula); raio interno = externo − padding. |

## Layout adaptativo e navegação

| Framework | Como fazer |
| --- | --- |
| Compose | `WindowSizeClass` (Compact/Medium/Expanded) alternando `NavigationBar` → `NavigationRail` → `PermanentNavigationDrawer`; `NavigationSuiteScaffold` / `ListDetailPaneScaffold` (material3-adaptive). |
| SwiftUI | `TabView` com `.tabViewStyle(.sidebarAdaptable)`, `.tabBarMinimizeBehavior(.onScrollDown)`, `Tab(role: .search)`; `NavigationSplitView` para colunas. |
| Flutter | Breakpoints 0/600/840/1200/1600; `NavigationBar` ↔ `NavigationRail`; `flutter_adaptive_scaffold` (SlotLayout). |
| React Native/Expo | `useWindowDimensions()` + breakpoints 600/840/1200; tabs embaixo < 600dp, rail/sidebar acima; `react-native-safe-area-context` (`useSafeAreaInsets`, `SafeAreaView`) para áreas do sistema; coluna central com `maxWidth` em tablet. |

## SafeArea e teclado

| Framework | Como fazer |
| --- | --- |
| Compose | `enableEdgeToEdge()` antes de `setContent`; `adjustResize`; `WindowInsets.safeDrawing`, `consumeWindowInsets`, `imePadding()`, `imeNestedScroll()`. |
| SwiftUI | Respeitar safe areas e layout guides; `.scrollEdgeEffectStyle(_:for:)`; o campo focado sobe acima do teclado. |
| Flutter | `SafeArea`, `MediaQuery.viewInsetsOf(context).bottom`, `Scaffold(resizeToAvoidBottomInset: true)`. |
| React Native/Expo | `KeyboardAvoidingView` (behavior `padding` no iOS) ou `react-native-keyboard-controller`; `ScrollView` com `keyboardShouldPersistTaps="handled"`; edge-to-edge é padrão no Android 15+ (SDK 35) — trate insets explicitamente. |

## Motion e haptics

| Framework | Como fazer |
| --- | --- |
| Compose | `MotionScheme.expressive()` / `standard()` (`@OptIn(ExperimentalMaterial3ExpressiveApi::class)`); `spring(dampingRatio, stiffness)`; `HapticFeedbackConstants` / `LocalHapticFeedback`. |
| SwiftUI | `.spring(duration:bounce:)`, `.smooth`, `.snappy`, `.interactiveSpring()`; `UIImpactFeedbackGenerator`, `UINotificationFeedbackGenerator`, `.sensoryFeedback(...)`, Core Haptics. |
| Flutter | `SpringDescription` / `SpringSimulation`; `HapticFeedback.lightImpact()` etc. |
| React Native/Expo | `react-native-reanimated` (`withSpring({ dampingRatio, stiffness })` / `withTiming` com `Easing.bezier`); `useReducedMotion()` ou `AccessibilityInfo.isReduceMotionEnabled()`; `expo-haptics` (`impactAsync`, `notificationAsync`, `selectionAsync`). |

## Acessibilidade

| Framework | Como fazer |
| --- | --- |
| Compose | `Modifier.semantics { contentDescription = … }`, `mergeDescendants = true` para agrupar; `Modifier.minimumInteractiveComponentSize()` (48dp). |
| SwiftUI | `.accessibilityLabel`, `.accessibilityElement(children: .combine)`, `.accessibilityHidden(true)` em decorativos. |
| Flutter | `Semantics(label:, button: true)`, `MergeSemantics`, `ExcludeSemantics`. |
| React Native/Expo | `accessibilityLabel`, `accessibilityRole`, `accessibilityState`, `accessible` no contêiner para agrupar, `hitSlop` para ampliar alvo, `importantForAccessibility="no-hide-descendants"` em decorativos. |

## Telas sensíveis e biometria

| Framework | Como fazer |
| --- | --- |
| Android nativo | `FLAG_SECURE` (também em Dialogs) ou `setRecentsScreenshotEnabled(false)` (API 33+); `BiometricPrompt` + `CryptoObject` com chave do Keystore. |
| iOS nativo | Máscara ao ir para background; detectar gravação/espelhamento; `LAContext` + chave EC no Secure Enclave. |
| React Native/Expo | `expo-screen-capture` (`preventScreenCaptureAsync`) ou ponte nativa própria; `expo-local-authentication` é só gate de UI — para proteger segredo, use `expo-secure-store` com `requireAuthentication` ou biblioteca que amarre a chave ao hardware. |
