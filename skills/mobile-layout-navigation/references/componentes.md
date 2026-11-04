# Especificações numéricas dos componentes críticos

Valores de referência para construir componentes sem divergência visual. M3 = Android Material 3 / Expressive;
HIG = iOS/iPadOS 26.

## Botões

**M3**
- 5 estilos: Elevated (nível 1 = 1dp; 0dp desabilitado), Filled (fundo `primary`), Tonal (`secondary-container`),
  Outlined (borda `outline` 1dp), Text (sem contêiner, sem modo toggle).
- 5 tamanhos (M3 Expressive): XS **32dp**, S **40dp** (padrão), M **56dp**, L **96dp**, XL **136dp** (para mouse/desktop, alvo mínimo 32dp).
- Forma: pílula (raio full; ou quadrado com morphing ao pressionar no M3 Expressive). Área de toque **≥ 48×48dp** mesmo nos tamanhos visuais 32 e 40.

**HIG**
- Estilos: padrão, proeminente (1–2 por tela, cor de destaque) e Liquid Glass (`.buttonStyle(.glass)`,
  `.buttonStyle(.glassProminent)`).
- Destaque da opção preferida pelo estilo, nunca por tamanhos diferentes lado a lado.
- Toque **≥ 44×44pt** (visionOS 60×60; tamanhos visuais 28 Mini, 32 Small, 44 Regular, 52 Large, 64 XL).
- Texto em *Title Case* (no idioma do app, capitalização equivalente) começando por verbo ("Adicionar ao carrinho").

## Campos de texto

- **M3:** variantes Filled e Outlined; raio extra-small **4dp** (no topo do Filled e nos 4 cantos do Outlined); borda **1dp** em repouso (`outline`) e **2dp** focado (`primary`);
  transição de estado **250ms**.
- **HIG:** alvo ≥ 44pt. iOS 26 aumentou altura de linha e padding em listas/formulários; cabeçalhos de seção em
  Title Case, sem caixa-alta automática.
- Ambos: erro = cor `error` + ícone + texto explicativo (nunca só cor).

## Cards

- **M3:** raio medium **12dp**; Elevated = nível 1 (1dp, +5% primary); padding **16dp**; barra de ações com
  padding 8/16/16 e gap **8dp**, alinhada ao fim; mídia **16:9** com `cover`.
- **HIG:** camada de conteúdo — nunca Liquid Glass (evita vidro sobre vidro). Preenchimento sólido ou material
  padrão do sistema.

## Bottom sheets e modais

- **M3:** raio extra-large **28dp**; modal sheet nível 1 (1dp, +5%); diálogo nível 3 (6dp, +11%). Scrim =
  `scrim` a **32%**, fade próprio de **300ms**.
- **HIG 26:** detents `.medium` (~50%) e `.large`; Liquid Glass com raio maior; half sheet **recuada das bordas**
  (deixa ver o conteúdo atrás), mais opaca ao expandir para altura total.

## FAB

- **M3:** padrão **56dp**; Small, Medium, Large e Extended (altura 56dp). Raio large **16dp**, nível 3 (6dp,
  +11%), `primary-container` com ícone `on-primary-container`.
- **HIG:** sem FAB nativo; se precisar de ação flutuante sobre conteúdo, botão em vidro (`.glass` /
  `.glassProminent`) com parcimônia.

## Barras

- **M3:** App Bar large **152dp** (small 64dp, medium 112dp); app bar rolada e Navigation Bar no nível 2 (3dp, +8%). Extended Rail **220–360dp** (usual **256dp**).
- **HIG:** barra de navegação 44pt compacta ou 96pt com título grande no iPhone, sem busca; a altura da status bar e da safe area inferior varia por aparelho (use `safeAreaInsets` em vez de valores fixos). Tab Bar no iPhone: máx. 5 abas, barra de 49pt (~83pt com a safe area inferior em aparelhos com Face ID); no iPadOS 18+, pílula flutuante adaptativa que se converte em Sidebar (~320pt no iPad / ~200pt no Mac).

## Listas e ícones

- Item de duas linhas: **72dp**. Ícones: 20, 24, 32, 40, 48dp.
- Anel de foco M3: **3dp** de espessura com **3dp** de offset.

## Elevação tonal M3

Na revisão atual do M3, prefira os **5 papéis fixos de superfície** (`surface-container-lowest`, `-low`, `surface-container`, `-high`, `-highest`). A tabela abaixo documenta a correspondência de `surfaceTint` (sobreposição de `primary` ainda usada por `Surface(tonalElevation)` no Compose e `ElevationOverlay.applySurfaceTint` no Flutter):

| Nível | dp | Sobreposição |
| --- | --- | --- |
| 0 | 0 | 0% |
| 1 | 1 | +5% |
| 2 | 3 | +8% |
| 3 | 6 | +11% |
| 4 | 8 | +12% |
| 5 | 12 | +14% |
