# Assets, densidades, ícones e fontes

## Resolução lógica e escala

- Ferramentas de design trabalham a **@1x** em pt/dp lógicos (ex.: 375×812pt; 402×874pt no iPhone 16 Pro).
  `px = pt × escala`; o total de pixels cresce com o quadrado da escala.
- iOS: @1x só em aparelhos descontinuados; **@2x** em telas LCD (iPhone 11, XR) e iPads; **@3x** nos demais
  iPhones. Ex.: botão de 44pt = 88×88px @2x, 132×132px @3x. iPhone 6/6s/7/8 Plus renderiza @3x virtual
  (1242×2208) e reduz para 1080×1920 (nativeScale ≈ 2.608).
- Android: dp para layout, sp só para texto. Prefira vetores (VectorDrawable/SVG) e fontes de ícone a
  múltiplos PNGs por bucket de densidade.
- **Hairline:** 0.5pt fixo fica borrado em @3x (1.5px). Use `1 / displayScale` (SwiftUI `@Environment(\.displayScale)`,
  RN `StyleSheet.hairlineWidth`) ou 1dp.

## Ícone do app

- iOS: catálogo *Single Size* — um PNG mestre **1024×1024px**; o Xcode gera as variantes.
- iOS 26 / Liquid Glass: ícone em camadas (foreground, middle, background) no **Icon Composer**, formas
  simples, sólidas ou semitransparentes. O sistema aplica máscara, blur e variantes Light / Dark / Clear /
  Tinted. Erros comuns: brilho ou sombra embutidos na imagem; publicar só a versão totalmente transparente.
- Android: ícone adaptativo (foreground + background, e monocromático para themed icons).

## Ícones de interface

- **Material Symbols** (fonte variável de 4 eixos):
  - tamanho/optical size: 20, 24, 32, 40, 48dp (optical size 20–48);
  - peso: 100 (thin) → 400 (regular) → 700 (bold) — iguale ao peso do texto ao lado;
  - grade: −25 (sobre fundo escuro), 0, 200 (ênfase) — muda o traço sem mudar a largura;
  - fill: 0 (contorno) / 1 (preenchido) — anime 0→1 no item selecionado da navegação.
- **SF Symbols:** 9 pesos (ultralight → black) e 3 escalas (small, medium, large), alinhados à altura de
  maiúscula do texto; crescem com Dynamic Type e têm rótulo de VoiceOver.
- Formas SVG personalizadas: coordenadas normalizadas 0..1.

## Fontes

- SF Pro, SF Compact e New York são variáveis com tamanhos ópticos: acesse pelas APIs do sistema
  (`.font(.body)`, `UIFont.preferredFont`), nunca empacote no bundle.
- Roboto Flex é variável; em Android use a do sistema ou declare a família no tema.
- Fonte de marca: forneça os estilos mapeados para os papéis do sistema (Display/Headline/Title/Body/Label ou
  os 11 estilos do Dynamic Type) e garanta que escalam com a preferência do usuário (`UIFontMetrics` no iOS).
