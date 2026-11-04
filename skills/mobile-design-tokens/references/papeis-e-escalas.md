# Papéis de cor e escalas (referência rápida)

## Papéis de sistema M3 (`md.sys.color.*`)

| Grupo | Papéis | Uso |
| --- | --- | --- |
| Primária | `primary`, `on-primary`, `primary-container`, `on-primary-container` | Ação principal, botão filled, FAB (`primary-container`) |
| Secundária | `secondary`, `on-secondary`, `secondary-container`, `on-secondary-container` | Botão tonal, indicador ativo da navegação, chips |
| Terciária | `tertiary`, `on-tertiary`, `tertiary-container`, `on-tertiary-container` | Acentos de contraste, destaques complementares |
| Erro | `error`, `on-error`, `error-container`, `on-error-container` | Validação, estados destrutivos |
| Superfícies | `surface`, `surface-dim`, `surface-bright`, `surface-container-lowest`, `-low`, `surface-container`, `-high`, `-highest` | Fundos e camadas por tom |
| Conteúdo | `on-surface`, `on-surface-variant` | Texto/ícone principal; texto secundário e metadados |
| Contornos | `outline`, `outline-variant` | Borda funcional (campos); divisor decorativo |
| Invertidos | `inverse-surface`, `inverse-on-surface`, `inverse-primary` | Snackbar, tooltips |
| Fixos | `primary-fixed`, `primary-fixed-dim`, `on-primary-fixed`, `on-primary-fixed-variant` (idem secondary/tertiary) | Mesmo tom nos dois temas — cuidado com contraste |
| Outros | `scrim` (32% em sheets), `shadow`, `surface-tint` | Fundo de modal, sombra, tinta de elevação |

Superfícies por tom: claro usa tons ~100 a 90; escuro ~4 a 22.

## Elevação tonal

Na especificação atual do M3, a hierarquia de superfície usa prioritariamente os **5 papéis `surface-container`** (`lowest` a `highest`). A tabela abaixo documenta a escala de `surfaceTint` (sobreposição percentual de `primary`, ainda usada por `Surface(tonalElevation)` no Compose e `ElevationOverlay.applySurfaceTint` no Flutter):

| Nível | dp | Sobreposição de primary | Exemplos |
| --- | --- | --- | --- |
| 0 | 0 | 0% | Superfície base |
| 1 | 1 | +5% | Elevated card, modal sheet, elevated button |
| 2 | 3 | +8% | App bar rolada, Navigation Bar |
| 3 | 6 | +11% | FAB, diálogo |
| 4 | 8 | +12% | Hover/pressed de nível 3 |
| 5 | 12 | +14% | — |

## Escala de raios (10 níveis M3 Expressive)

| Token | Valor |
| --- | --- |
| none | 0dp |
| extraSmall | 4dp (campos de texto M3) |
| small | 8dp |
| medium | 12dp (cards) |
| large | 16dp (FAB) |
| largeIncreased (`large-increased`) | 20dp |
| extraLarge | 28dp (sheets, diálogos) |
| extraLargeIncreased (`extra-large-increased`) | 32dp |
| extraExtraLarge (`extra-extra-large`) | 48dp |
| full | 9999 / pílula (botões) |

## Tipografia M3 (base)

| Papel | Large | Medium | Small |
| --- | --- | --- | --- |
| Display | 57/64 | 45/52 | 36/44 |
| Headline | 32/40 | 28/36 | 24/32 |
| Title | 22/28 | 16/24 | 14/20 |
| Body | 16/24 | 14/20 | 12/16 |
| Label | 14/20 | 12/16 | 11/16 |

(tamanho/altura de linha em sp; Emphasized sobe o peso sem mudar a altura de linha)

## Dynamic Type iOS (tamanho padrão "Large")

Large Title 34 · Title 1 28 · Title 2 22 · Title 3 20 · Headline 17 semibold · Body 17 (linha 22) ·
Callout 16 · Subheadline 15 · Footnote 13 · Caption 1 12 · Caption 2 11 (mínimo).

## Vibrancy iOS (contraste decrescente)

`label` → `secondaryLabel` → `tertiaryLabel` → `quaternaryLabel` (evitar o último sobre `thin`/`ultraThin`).
