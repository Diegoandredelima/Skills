---
name: mobile-design-tokens
description: Design tokens, cores e tipografia para apps mobile (Material 3 / HCT e Apple semantic colors / Liquid Glass) — arquitetura de tokens em três camadas (reference, system, component), papéis semânticos (primary/on-primary, surface-container, outline vs. outline-variant), modo escuro, dynamic color, alto contraste, harmonização de cor de marca, elevação tonal, vibrancy, variantes regular/clear do Liquid Glass, escala tipográfica e de raios. Use sempre que for criar ou revisar um tema, paleta, design system ou tokens de app; trocar cores hardcoded por tokens; implementar dark mode; escolher cor de texto/borda/divisor; ou decidir onde usar vidro/translucidez no iOS — em Compose, SwiftUI, Flutter ou React Native/Expo.
---

# Design tokens, cores e tipografia mobile

Parte do conjunto `mobile-ui-ux`. Tabela de papéis e escalas completas: `references/papeis-e-escalas.md`.

## Por que tokens

Hex/RGB direto no componente (`#FFFFFF`, `Color(0xFF4CAF50)`) quebra modo escuro, dynamic color e os
ajustes de contraste do usuário — cada tela vira um caso especial. Com tokens, trocar de tema é trocar
ponteiros, e o design system vira um **contrato de tipos** que o compilador verifica.

## Três camadas

1. **Reference (`md.ref.*`)** — valores brutos. Uma cor semente (ou cinco cores-chave extraídas do wallpaper)
   gera em HCT seis paletas tonais — primary, secondary, tertiary, neutral, neutral-variant e error — com
   13 tons (0–100) cada, mais tons de superfície (4, 6, 12, 17, 22, 24, 87, 92, 94, 96).
   Ex.: `md.ref.palette.primary40`.
2. **System (`md.sys.*`)** — papéis semânticos (`primary`, `on-surface`, `outline`…) por tema: Light, Dark e
   contraste Standard/Medium/High. Cada papel aponta para um tom; claro↔escuro é só trocar o tom apontado.
3. **Component (`md.comp.*`)** — propriedades de cada componente ligadas a tokens de sistema
   (`md.comp.filled-button.container.color → md.sys.color.primary`).

Componente consome **component** ou **system**, nunca **reference** nem valor literal.

## Regras de uso de cor (M3)

- **Pares tonais fixos:** `primary` ↔ `on-primary`; `primary-container` ↔ `on-primary-container`;
  `secondary-container` (botão tonal, indicador ativo da navegação) ↔ `on-secondary-container`;
  qualquer `surface` / `surface-container-*` ↔ `on-surface` (texto principal) ou `on-surface-variant`
  (secundário, metadados). Não misture pares — o contraste só é garantido dentro do par.
- **Bordas:** `outline` para fronteiras importantes (campo de texto); `outline-variant` para divisores
  decorativos.
- **Invertidos** (snackbar): `inverse-surface`, `inverse-on-surface`, `inverse-primary`.
- **Fixos** (`primary-fixed`, `primary-fixed-dim`, `on-primary-fixed`…) não mudam entre claro e escuro — evite
  onde o contraste adaptativo importa.
- **Profundidade por tom, não por sombra:** 5 surface-containers (lowest → highest). Sombra só para FAB,
  diálogo ou elemento sobre fundo ruidoso. Superfície padrão do tema claro = tom **98**; chroma neutro **6**.
- **Cor de marca/semântica com dynamic color** (Android 12+, `dynamicLightColorScheme`/`dynamicDarkColorScheme`):
  harmonize em HCT com o `primary` do esquema (`MaterialColors.harmonize` / `MaterialColors.harmonizeWithPrimary` em `com.google.android.material.color.MaterialColors` no Android; `Blend.harmonize` em `material_color_utilities` no Flutter/Dart e Web — desloca o matiz um pouco, preserva a identidade) em vez de
  usar o valor cru.
- **Estado nunca só por cor:** erro = cor `error` + ícone + texto.

## Cor no iOS / iPadOS 26

- Use cores semânticas e de sistema (`label`, `secondaryLabel`, `tertiaryLabel`, `quaternaryLabel`,
  `systemBackground`…). Sobre materiais translúcidos o valor final é decidido em tempo real (vibrancy).
  Evite `quaternaryLabel` sobre materiais `thin`/`ultraThin` (contraste baixo demais).
- **Liquid Glass** — duas variantes:
  - **regular** (padrão de `.glassEffect()`): desfoca e ajusta luminosidade; para barras, alertas, sidebars,
    popovers e qualquer vidro com texto;
  - **clear**: muito translúcido, só para controles sobre foto/vídeo. Sobre mídia clara (fora dos controles
    padrão do AVKit) adicione camada escura de **35%**.
- Vidro só na camada de controle/navegação. Nunca em listas, cards, células ou fundo; nunca vidro sobre vidro;
  agrupe elementos próximos com `GlassEffectContainer` e valide o custo de GPU no Xcode Instruments.
- Teste com os modos de aparência do sistema (`Light`, `Dark`, `Clear`, `Tinted`), **Reduce Transparency** (vira
  fundo sólido) e **Increase Contrast**.

## Tipografia

- **Android:** 15 estilos em 5 papéis — Display, Headline, Title, Body, Label (L/M/S) — + 15 Emphasized
  (peso 400→500 ou 500→700, mesma altura de linha). `sp` só para tamanho de texto e altura de linha; resto em dp.
  Ex.: `titleLarge` 22/28sp, `bodyLarge` 16/24sp, `bodyMedium` 14/20sp.
- **iOS:** 11 estilos Dynamic Type (Large Title 34pt … Caption 2 11pt; Body 17/22pt). Sempre via estilo de
  sistema para escalar com a preferência do usuário. Tamanhos completos em `mobile-accessibility`.
- Fonte de marca: mapeie para os papéis acima e faça escalar (`UIFontMetrics`, `sp`, `allowFontScaling`).

## Formas

- Escala M3 (10 níveis): none 0 · extraSmall 4 · small 8 · medium 12 · large 16 · (large-increased 20) · extraLarge 28 · (extra-large-increased 32,
  extra-extra-large 48) · full (pílula). Contornos M3: 1dp (repouso) e 2dp (foco) — ou convenção 0/1/2/4dp no projeto.
- iOS 26: `ConcentricRectangle` (acompanha o raio do hardware), `Capsule`.
- Aninhado: `raio interno = raio externo − padding`.

## Como entregar um tema

1. Defina a semente (ou importe o esquema do Material Theme Builder) e gere as paletas.
2. Mapeie papéis de sistema para claro, escuro e alto contraste.
3. Exporte tokens (JSON W3C Design Tokens ou `md.sys.*`) para cada plataforma.
4. Substitua todo literal de cor/raio/espaço por token; um lint ou busca por `#[0-9a-fA-F]{3,8}` e `rgb(` nos
   componentes ajuda a achar sobras.
5. Valide em claro, escuro, dynamic color e alto contraste, e o contraste de cada par (≥ 4.5:1 texto,
   ≥ 3:1 ícones/bordas funcionais).

No React Native/Expo: objeto de tema tipado (ex.: `theme.color.onSurfaceVariant`), escolhido por
`useColorScheme()`; componentes recebem tokens, não strings de cor.
