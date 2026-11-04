---
name: mobile-ui-ux
description: Guia central de product design e engenharia de interface mobile (iOS e Android) — Material Design 3 / M3 Expressive vs. Apple HIG / Liquid Glass, mapeamento para Jetpack Compose, SwiftUI, Flutter e React Native/Expo, organização de assets e checklist de QA pré-release. Use esta skill sempre que o trabalho envolver telas de app mobile ou tablet (desenhar, implementar, revisar ou auditar UI/UX de app, escolher componentes nativos, adaptar layout para tablet/dobrável, preparar handoff design→dev, ou fazer revisão visual antes de publicar) — mesmo que o usuário não cite "Material" ou "HIG". Ela encaminha para as skills especializadas (mobile-layout-navigation, mobile-design-tokens, mobile-motion-haptics, mobile-accessibility, mobile-ui-security).
---

# Mobile UI/UX — guia central

Base: pesquisa "Guia Arquitetural de Product Design e Engenharia de Interface Mobile (iOS e Android)", nov/2026.
Esta skill é o ponto de entrada. Ela dá a visão comparativa das plataformas, o mapeamento por framework e o
checklist de auditoria; o detalhe de cada domínio está numa skill própria.

## Como usar este conjunto de skills

| Se a tarefa envolve… | Use a skill |
| --- | --- |
| Navegação (tab bar, rail, sidebar), thumb zone, tablet/dobrável, master-detail, specs numéricas de componentes, grid, SafeArea, teclado (IME) | `mobile-layout-navigation` |
| Cores, tema claro/escuro, dynamic color, tokens, tipografia, raios/formas, elevação | `mobile-design-tokens` |
| Animações, transições, molas (springs), Reduce Motion, feedback háptico | `mobile-motion-haptics` |
| Contraste, alvos de toque, VoiceOver/TalkBack, Dynamic Type/escala de fonte, WCAG 2.2 | `mobile-accessibility` |
| Biometria, telas sensíveis (captura/app switcher), permissões, privacidade | `mobile-ui-security` |
| Visão geral, mapeamento entre frameworks, assets/ícones, auditoria pré-release | esta skill |

Numa revisão ampla de uma tela ou de um app, percorra o checklist de `references/checklist-qa.md` e abra a
skill especializada só do pilar em que houver achado. Não é preciso carregar todas.

## Princípios que atravessam tudo

1. **Respeite o modelo mental de cada plataforma.** Não importe padrões de uma para outra (abas no topo no iOS,
   botão "voltar" explícito onde o gesto do sistema já opera). Em app multiplataforma, compartilhe tokens e
   lógica, não a aparência literal dos controles de sistema.
2. **Nada de valor solto.** Cores, espaçamentos, raios, durações e tipografia vêm de tokens (três camadas:
   reference → system → component). Hex hardcoded quebra modo escuro, dynamic color e alto contraste.
3. **Ação primária no alcance do polegar** (metade inferior); destrutiva longe dele e sempre com confirmação.
4. **Adapte por classe de janela, não por aparelho.** Breakpoints 600 / 840 / 1200 / 1600 dp; janelas do
   iPadOS 26 redimensionam continuamente.
5. **Acessibilidade é requisito, não polimento:** alvos 44pt/48dp, contraste 4.5:1, escala até AX5/200%,
   leitor de tela testado em aparelho físico.
6. **Movimento com física e propósito:** molas para geometria, sem overshoot em cor/opacidade, saída mais
   curta que a entrada, Reduce Motion respeitado.
7. **Segurança de UI é criptográfica, não visual:** biometria só vale atrelada a chave em hardware.
8. **Parta do que o projeto já tem.** Antes de propor componente, tema ou padrão novo, procure no código os
   componentes base, o arquivo de tema/tokens e as convenções (ex.: wrapper de tela com SafeArea, alerta
   próprio, largura máxima de coluna) e reaproveite. As regras destas skills dizem *o que* garantir; o projeto
   diz *com o quê*. Se uma convenção do projeto contrariar uma regra daqui, siga o projeto e aponte a divergência.

## Como entregar uma revisão ou recomendação

Cite em cada achado o critério concreto (número WCAG, regra do M3/HIG, valor de token) e a correção na stack do
projeto. Prefira números da pesquisa (ex.: "48×48dp", "saída ≈ 60% da entrada", "scrim 32%") a adjetivos
("maior", "mais rápido") — é o que torna a recomendação verificável.

## M3 vs. HIG em uma tabela

| Dimensão | Android — Material 3 / M3 Expressive | iOS/iPadOS 26 — HIG / Liquid Glass |
| --- | --- | --- |
| Filosofia | Personal, Adaptive, Expressive | Hierarchy, Harmony, Consistency |
| Profundidade (eixo Z) | Tom de superfície (5 surface-containers); sombra só em FAB/diálogo/fundo ruidoso | Camada de controle em Liquid Glass sobre camada de conteúdo opaca |
| Cor dinâmica | Extraída do wallpaper em HCT → 5 paletas de 13 tons | Cores semânticas + vibrancy; modo Clear/Tinted |
| Tipografia | Roboto/Roboto Flex: 15 estilos + 15 Emphasized (Display, Headline, Title, Body, Label) | SF Pro / New York: 11 estilos Dynamic Type (Caption 2 11pt → Large Title 34pt) |
| Formas | 10 raios (0 → pílula) + 35 formas com shape morphing | Geometria concêntrica (ConcentricRectangle), cápsulas, sheets com inset |
| Unidade | dp (layout), sp (só texto) | pt (layout e texto), @2x/@3x |

**Regra crítica do Liquid Glass:** vidro só na camada funcional (tab bar, toolbar, sidebar, sheet, popover).
Nunca em listas, cards, células ou fundo — e nunca vidro sobre vidro.

## Mapeamento por framework

Para traduzir uma decisão de design em código, consulte `references/mapeamento-frameworks.md` (Compose,
SwiftUI, Flutter, React Native/Expo) — theming, tipografia, formas, layout adaptativo, motion e haptics.

## Assets e ícones

Resumo; detalhe em `references/assets-icones.md`:
- Desenhe a @1x em pt/dp lógicos; px = pt × escala. iOS moderno é @3x (exceto LCD @2x).
- Hairline = `1 / displayScale` (ou 1dp), não 0.5pt fixo.
- Ícone iOS: PNG mestre 1024×1024; no iOS 26, em camadas no Icon Composer, sem brilho/sombra embutidos.
- Ícones: Material Symbols (fonte variável: tamanho, peso, grade, fill) e SF Symbols (9 pesos, 3 escalas,
  acompanham Dynamic Type). Não empacote SF Pro no bundle — use as APIs de sistema.

## Handoff design → dev

Trate o design system como **contrato de tipos**: componentes aceitam tipos de token (espaçamento, raio,
cor semântica), não números arbitrários. Ferramentas de leitura direta da especificação (ex.: Figma Dev Mode
MCP) reduzem tradução manual. Ao entregar uma tela, documente: estados (repouso, pressionado, foco,
desabilitado, erro, carregando, vazio), comportamento por classe de janela, tokens usados e textos de
acessibilidade.

## Auditoria pré-release

Use `references/checklist-qa.md`: seis pilares (fundamentos/adaptação, componentes/layout, cores/tokens,
motion/haptics, acessibilidade, segurança/privacidade), cada item com critério de aceitação e método de
verificação. Ao relatar uma revisão, organize os achados por pilar, com severidade e o critério violado.

## Fonte completa

`references/guia-completo.md` é o texto integral da pesquisa (sem imagens). Consulte quando precisar de um
número ou nuance que as skills resumiram. Os números de citação colados às frases são referências da
pesquisa original. Se uma API citada divergir da documentação oficial atual, a documentação oficial prevalece —
avise o usuário da divergência.
