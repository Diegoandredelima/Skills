---
name: mobile-layout-navigation
description: Layout, navegação e componentes de apps mobile e tablet (Material 3 e Apple HIG / iOS 26) — tab bar vs. navigation bar vs. rail vs. sidebar, thumb zone, window size classes e breakpoints (600/840/1200/1600dp), master-detail/split view, specs numéricas de botões, campos, cards, sheets, FAB e barras, grid 4/8dp, margens, largura máxima de leitura, raio concêntrico, SafeArea, notch/Dynamic Island, edge-to-edge e teclado virtual (IME). Use sempre que for montar ou revisar a estrutura de uma tela de app, migrar ou atualizar navegação por abas para o iOS 26 / Liquid Glass ou Android, escolher ou dimensionar um componente, adaptar para tablet/dobrável/paisagem, ou corrigir conteúdo cortado por barra de sistema ou escondido pelo teclado — inclusive em SwiftUI, Compose, React Native/Expo e Flutter.
---

# Layout, navegação e componentes mobile

Parte do conjunto `mobile-ui-ux` (skill central com mapeamento por framework e checklist de QA).
Specs numéricas completas por componente: `references/componentes.md`.

## 1. Escolha da navegação

**Regra geral:** use o padrão nativo de cada plataforma; não importe o da outra (abas no topo no iOS, botão
de voltar desenhado onde o gesto do sistema já resolve).

| Contexto | Android (M3) | iOS / iPadOS (HIG 26) |
| --- | --- | --- |
| Telefone, 3–5 destinos de mesmo peso | **Navigation Bar** (sem sombra, indicador em pílula `secondary-container`, ícone contorno→preenchido). No M3 Expressive prefira a **Flexible Navigation Bar** (mais baixa; ícone e rótulo lado a lado em Medium). | **Tab Bar** — só para seções de topo, nunca para ações (ações vão na Toolbar). Máx. **5** abas no iPhone, SF Symbols preenchidos, rótulo de uma palavra; barra padrão de 49pt (~83pt somando a safe area inferior em iPhones com Face ID). |
| Tablet / janela larga | Medium (600–839) e Expanded (840–1199): **Navigation Rail** na borda inicial. Large (1200+) / XL (1600+): rail estendido (**220–360dp**, usual **256dp**, com rótulos) ou **PermanentNavigationDrawer**. | **Sidebar** em Liquid Glass (`.tabViewStyle(.sidebarAdaptable)`, iOS 18+), recolhida em retrato e expandida (~**320pt**) em paisagem; no iPadOS 18+ a Tab Bar flutua no topo e converte-se em Sidebar. |
| Voltar | **Predictive Back** (prévia da tela anterior durante o gesto; habilitado por padrão, com `android:enableOnBackInvokedCallback="false"` apenas para sair por app/activity; no Android 13/14 a animação do sistema dependia da opção de desenvolvedor "Predictive back animations", removida no Android 15, onde aparece para os apps que suportam — exige AndroidX Activity 1.6.0+ com `OnBackPressedCallback` ou `PredictiveBackHandler`/`BackHandler` no Compose, activity-compose 1.8.0+, sem interceptar `onBackPressed`/`KEYCODE_BACK`). | **Back swipe** pela borda — nunca bloquear. |

Regras do HIG para Tab Bar: não esconder nem desabilitar abas dinamicamente (a interface fica
imprevisível); evitar a aba "More"; badge vermelho só para o que é realmente crítico. No SwiftUI:
`.tabBarMinimizeBehavior(.onScrollDown)` (iOS 26+) e `Tab(role: .search)` (iOS 18+, destacada como pílula separada em Liquid Glass no iOS 26).

Carrossel/lista horizontal no Android: `Modifier.systemGestureExclusion()` para não brigar com o gesto de
voltar nas bordas.

## 2. Ergonomia — thumb zone

Em telefones grandes (6,7"+) o conforto do polegar é a **metade inferior**.
- Ação primária ("Salvar", "Concluir", "Enviar") embaixo: botão largo no rodapé, FAB ou barra inferior.
  Colocá-la no canto superior direito obriga a trocar a pega a cada uso.
- Ação destrutiva ("Excluir") fora do caminho natural do polegar, com confirmação, e **nunca** com papel/estilo
  de primária.
- Em tablet a pega vai para as laterais: navegação e ações migram para a borda inicial (Reposition).

## 3. Layout adaptativo

Classes de janela (M3): Compact < 600dp · Medium 600–839 · Expanded 840–1199 · Large 1200–1599 · XL ≥ 1600.
Decida por **largura da janela**, não por modelo de aparelho — multi-window, dobráveis e o redimensionamento
contínuo do iPadOS 26 tornam "é tablet?" uma pergunta errada.

Cinco operações adaptativas do M3:
1. **Reveal** — mostrar o que estava oculto (2º painel, rail expandido).
2. **Divide** — dividir em painéis.
3. **Resize** — redimensionar cards e texto mantendo 40–60 caracteres por linha.
4. **Reposition** — levar ações e navegação da base (Compact) para a borda inicial (Medium+).
5. **Swap** — trocar componentes funcionalmente equivalentes (Navigation Bar ↔ Rail). Não troque coisas que
   não são equivalentes (botão ↔ menu).

**Master-detail / split view:**
- Compact/Medium: 1 painel; listas-detalhe podem dividir já em Medium (≥ 600), padrão em ≥ 840; 3 painéis só
  em XL (≥ 1600).
- Em 1 painel, um estado explícito de foco (lista vs. detalhe) decide o que aparece — não acople isso ao
  roteamento.
- Em 2 painéis: lista **360dp** + espaçador **24dp** + detalhe flexível.
- iPadOS: `NavigationSplitView` / `UISplitViewController`, colunas que se ajustam continuamente, sem larguras
  fixas por aparelho.

## 4. Grid, espaçamento e largura máxima

- Tudo em múltiplos de **4** (grid) com ritmo de **8** dp/pt.
- Margens laterais: **16** em Compact (iPhone retrato); **24** em Medium+ e no iPad (20 no macOS).
- Entre botões de ação adjacentes: **8** (barras de ação de card/formulário) ou **12** — documente a escolha.
- Item de lista de duas linhas: **72dp**. Ícones: 20 / 24 / 32 / 40 / 48dp.
- Formulário (referência de projeto): `maxWidth` **560dp**, 16dp entre campos.
- Corpo de leitura em Large/XL (referência de projeto): **840–1040dp** de largura máxima (ultrawide 1920); `readableContentGuide` no
  iPadOS. Texto: 40–60 caracteres por linha (30–75 aceitável), altura de linha 1.4–1.5× no corpo, ~1.2× em
  títulos grandes.
- **Raio concêntrico:** filho arredondado dentro de pai arredondado → `interno = externo − padding`
  (card 48dp com padding 16dp → filho 32dp). No iOS 26, `ConcentricRectangle`.
- Camadas de z-index (convenção de referência sem inteiros arbitrários): background 0 · content 1 · floating 10 · drawer 100 ·
  modal 1000 · snackbar 2000 · tooltip 9999.

## 5. SafeArea, recortes e teclado

Sintomas de erro: botão atrás da barra de gestos, título cortado pelo notch/Dynamic Island, campo coberto
pelo teclado.

**Android 15/16+ (edge-to-edge é o padrão):**
- `enableEdgeToEdge()` no `onCreate()` **antes** de `setContent`; `android:windowSoftInputMode="adjustResize"`.
- Compose: `WindowInsets.systemBars`, `.ime`, `.safeDrawing`. Padrão para lista com campos:

```kotlin
Scaffold(contentWindowInsets = WindowInsets.systemBars) { innerPadding ->
    LazyColumn(
        modifier = Modifier
            .padding(innerPadding)
            .consumeWindowInsets(innerPadding)
            .windowInsetsPadding(WindowInsets.safeDrawing.only(WindowInsetsSides.Horizontal))
            .imePadding(),
    ) { /* campos */ }
}
```
- Sem Scaffold: `Modifier.safeDrawingPadding()` na raiz, ou espaçadores com
  `windowInsetsTopHeight(WindowInsets.systemBars)` / `windowInsetsBottomHeight(WindowInsets.ime)` e
  `imeNestedScroll()` para o teclado acompanhar o gesto.

**iOS/iPadOS 26:** use safe areas e layout guides (o sistema posiciona controles de janela, Dynamic Island e
home indicator). `.scrollEdgeEffectStyle(_:for:)` mantém controles flutuantes legíveis sobre conteúdo em
scroll. O campo focado deve subir acima do teclado (WCAG 2.4.11 Focus Not Obscured).

**React Native/Expo:** `react-native-safe-area-context` (`useSafeAreaInsets` para padding de cabeçalho e
rodapé fixos), `KeyboardAvoidingView` (iOS `behavior="padding"`) ou `react-native-keyboard-controller`,
`keyboardShouldPersistTaps="handled"` nos scrolls com formulário. Rodapé com ação primária soma
`insets.bottom`.

**Flutter:** `SafeArea`, `Scaffold(resizeToAvoidBottomInset: true)`, `MediaQuery.viewInsetsOf(context)`.

Teste: abrir o teclado no **último** campo de cada tela; navegar com teclado externo; girar o aparelho.

## 6. Componentes — o essencial

Detalhe numérico em `references/componentes.md`. O que mais costuma dar errado:
- **Alvo de toque** ≥ 48×48dp (Android) / 44×44pt (iOS) mesmo quando o visual é menor (botão de 32 ou 40dp).
- **Hierarquia de botões:** distinga a ação preferida pelo **estilo** (filled/proeminente), não por tamanhos
  diferentes lado a lado. No iOS, no máximo 1–2 botões proeminentes por tela; rótulo começando por verbo.
- **Cards** são camada de conteúdo: no iOS nunca em Liquid Glass.
- **Sheets:** M3 raio 28dp, scrim 32%; iOS 26 detents `.medium`/`.large`, half sheet com inset das bordas.
- **FAB** (M3) 56dp, raio 16dp, `primary-container`; no iOS use botão em vidro com parcimônia.
