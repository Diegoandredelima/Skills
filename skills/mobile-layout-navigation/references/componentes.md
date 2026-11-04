# Especificações numéricas dos componentes críticos

Valores de referência para construir componentes sem divergência visual. M3 = Android Material 3 / Expressive;
HIG = iOS/iPadOS 26.

## Botões

**M3**
- 5 estilos: Elevated (nível 1 = 1dp; 0dp desabilitado), Filled (fundo `primary`), Tonal (`secondary-container`),
  Outlined (borda `outline` 1dp), Text (sem contêiner, sem modo toggle).
- 5 tamanhos: XS 32dp, S 40dp, adaptativo 48dp (toque) / 32dp (mouse), M 56dp, L/XL maiores.
- Forma: pílula (raio full). Área de toque **≥ 48×48dp** mesmo nos tamanhos visuais 32 e 40.

**HIG**
- Estilos: padrão, proeminente (1–2 por tela, cor de destaque) e Liquid Glass (`.buttonStyle(.glass)`,
  `.buttonStyle(.glassProminent)`).
- Destaque da opção preferida pelo estilo, nunca por tamanhos diferentes lado a lado.
- Toque **≥ 44×44pt** (visionOS 60×60; tamanhos visuais 28 Mini, 32 Small, 44 Regular, 52 Large, 64 XL).
- Texto em *Title Case* (no idioma do app, capitalização equivalente) começando por verbo ("Adicionar ao carrinho").

## Campos de texto

- **M3:** variantes Filled e Outlined; raio small **8dp**; borda 1dp (thin), 2dp (thick), 4dp (extraThick);
  transição de estado **250ms**.
- **HIG:** alvo ≥ 44pt. iOS 26 aumentou altura de linha e padding em listas/formulários; cabeçalhos de seção em
  Title Case, sem caixa-alta automática.
- Ambos: erro = cor `error` + ícone + texto explicativo (nunca só cor).

## Cards

- **M3:** raio medium **12dp**; Elevated = nível 1 (1dp, +5% primary); padding **16dp**; barra de ações com
  padding 8/16/16 e gap **8dp**, alinhada ao fim; mídia **16:9** com `cover`.
- **HIG:** camada de conteúdo — nunca Liquid Glass (evita vidro sobre vidro). Preenchimento sólido ou material
  padrão; em painéis translúcidos, frost 20–25 e depth ≤ 15.

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

- **M3:** App Bar large **152dp**; app bar rolada e Navigation Bar no nível 2 (3dp, +8%). Extended Rail **256dp**.
- **HIG:** barra de navegação 44pt compacta ou 96pt no iPhone (93pt no iPad), sem busca; status bar 54pt
  (iPhone) ou 24pt + 24pt grabber (iPad). Tab Bar 83pt iPhone (máx. 5) / 65pt iPad (máx. 8). Sidebar 320pt
  (iPad) / 200pt (Mac); botão de alternância 31×22pt.

## Listas e ícones

- Item de duas linhas: **72dp**. Ícones: 20, 24, 32, 40, 48dp.
- Anel de foco M3: **3dp** de espessura com **3dp** de offset.

## Elevação tonal M3 (sobreposição de `primary` na superfície)

| Nível | dp | Sobreposição |
| --- | --- | --- |
| 0 | 0 | 0% |
| 1 | 1 | +5% |
| 2 | 3 | +8% |
| 3 | 6 | +11% |
| 4 | 8 | +12% |
| 5 | 12 | +14% |
