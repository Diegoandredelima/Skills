---
name: mobile-accessibility
description: Acessibilidade (a11y) em apps mobile iOS e Android segundo WCAG 2.2 AA/AAA — contraste 4.5:1 e 3:1, alvos de toque 44pt/48dp, foco não encoberto (2.4.11), alternativa a arrasto (2.5.7), autenticação acessível e colar senha (3.3.8), ajuda consistente, entrada redundante, VoiceOver e TalkBack (rótulos, agrupamento, ordem de leitura, decorativos), Dynamic Type até AX5 e escala de fonte não linear 200% do Android 14+, Reduce Motion/Transparency. Use sempre que for implementar, revisar ou auditar acessibilidade de telas de app; adicionar accessibilityLabel/contentDescription; corrigir texto cortado com fonte grande; validar contraste ou tamanho de toque; ou preparar o app para conformidade (EAA/EN 301 549, ADA, LBI) — em SwiftUI, Compose, Flutter ou React Native/Expo.
---

# Acessibilidade mobile (WCAG 2.2)

Parte do conjunto `mobile-ui-ux`. Tabela de Dynamic Type e APIs por framework: `references/dynamic-type-e-apis.md`.

## Meta e contexto

Alvo: **WCAG 2.2 nível AA** (55 critérios A+AA; documento informativo *WCAG2Mobile* para apps). Quadros legais
(European Accessibility Act via EN 301 549, desde 28/06/2025; ADA Title II) ainda citam 2.1 AA como piso —
2.2 AA cobre ambos. Ferramentas automáticas acham só **30–40%** dos problemas: teste manual com VoiceOver e
TalkBack em aparelho real é parte do trabalho, não opcional.

## Contraste

- Texto normal **≥ 4.5:1**; texto grande, ícones, gráficos e contornos funcionais **≥ 3:1**.
- Meça em claro, escuro e **sobre Liquid Glass depois do blur** (o fundo muda com o conteúdo atrás).
- Estado nunca só por cor: erro = cor + ícone + texto; selecionado = cor + forma/ícone/peso.

## Alvos de toque

- **44×44pt** iOS/iPadOS · **48×48dp** Android · **60×60pt** visionOS (centros a 60pt) · 32dp para mouse.
- O mínimo WCAG 2.5.8 (24×24 CSS px) é mais baixo — siga o da plataforma.
- Visual menor é permitido; a área de toque não (`hitSlop` no RN, `minimumInteractiveComponentSize` no
  Compose, `.contentShape` / frame mínimo no SwiftUI).

## Critérios novos do 2.2 que mais afetam mobile

- **2.4.11 Focus Not Obscured (AA)** — o elemento focado não fica totalmente coberto por header fixo, barra
  inferior, banner ou teclado. (2.4.12 AAA: nem parcialmente.)
- **2.4.13 Focus Appearance (AAA)** — indicador de foco com contraste ≥ 3:1; no M3, anel de 3dp com 3dp de offset.
- **2.5.7 Dragging Movements (AA)** — todo arrasto (slider, reordenar lista, fechar painel por swipe) tem
  alternativa de toque simples (botões +/−, "mover para cima", botão fechar).
- **2.5.8 Target Size (AA)** — ver acima.
- **3.2.6 Consistent Help (A)** — ajuda/contato na mesma posição relativa em todas as telas.
- **3.3.7 Redundant Entry (A)** — não pedir de novo o que o usuário já informou no mesmo fluxo (preencha ou
  ofereça seleção).
- **3.3.8 Accessible Authentication (AA)** — login sem teste de memória/quebra-cabeça; **permitir colar**
  senha, gerenciador de senhas e biometria. Não bloqueie paste em campo de senha.

## Leitores de tela (VoiceOver / TalkBack)

- Todo controle e ícone interativo tem rótulo que diz a **finalidade**: "Adicionar ao carrinho, tênis azul",
  não "Botão" nem "ic_add".
- Informe papel e estado (botão, selecionado, desabilitado, expandido) pela API — não no texto do rótulo.
- Decorativo: oculto da tecnologia assistiva.
- A leitura segue a **hierarquia de views**, não a posição visual: agrupe linhas de lista e cards num
  único elemento com rótulo composto e ações customizadas, em vez de 6 paradas soltas.
- Mudanças dinâmicas importantes (erro de envio, "salvo") são anunciadas (live region / announcement).
- Ao abrir modal/sheet, o foco vai para ele e fica preso nele; ao fechar, volta ao gatilho.

## Texto escalável

- **iOS Dynamic Type:** 7 tamanhos padrão (xSmall → xxxLarge, até ~+35%) e 5 de acessibilidade (AX1–AX5).
  Body: 17pt padrão → **33pt em AX2** (~200%) → **53pt em AX5** (3.12×). Títulos crescem menos (Large Title
  60pt em AX5).
- **Android 14+:** escala **não linear até 200%** — texto pequeno cresce pelo fator total, títulos grandes
  crescem menos. `sp` só em texto/altura de linha; contêineres e padding em dp.
- Use os estilos de sistema; fonte própria precisa escalar (`UIFontMetrics`, `sp`, `allowFontScaling`).
- **Nunca** altura fixa em contêiner de texto — corta (clipping). Use altura mínima e deixe crescer.
- Em tamanhos de acessibilidade (`isAccessibilitySize` / AX1+ no iOS; escala ≥ ~1.5 no Android/RN): linhas lado a
  lado viram **pilhas verticais com quebra**, menos colunas, ícones acima do texto. Rótulos de tab bar
  mantêm o tamanho da convenção da plataforma.
- Display Zoom (iOS) é diferente: reduz a resolução lógica da tela inteira — teste os dois.

## Preferências do sistema a respeitar

Reduce Motion (ver `mobile-motion-haptics`), Reduce Transparency e Increase Contrast (ver
`mobile-design-tokens`), Bold Text, modo escuro, Button Shapes.

## Como testar (roteiro curto)

1. Inspetor automático: Accessibility Inspector (Xcode), Accessibility Scanner (Android), Stark (Figma).
2. Navegar o fluxo inteiro só com VoiceOver e depois só com TalkBack: tudo alcançável, rótulos claros,
   ordem lógica, foco correto em modais.
3. Fonte no máximo (AX5 / 200%): nada cortado, nada sobreposto, ação primária alcançável.
4. Teclado externo / switch control: foco visível e nunca encoberto.
5. Contraste dos pares de cor em claro, escuro e sobre vidro.
6. Toda ação de arrasto tem alternativa de toque.

Ao relatar, cite o critério WCAG (número e nível) e a correção concreta por plataforma.
