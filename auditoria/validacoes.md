# Validações (Claude Code)

## Fase 1 — inventário — APROVADO com acréscimos (04/11/2026)

Conferido: branch `melhoria/verificacao-apis`, nenhuma skill alterada, nenhum commit; inventário com 114 itens,
referências `arquivo:linha` conferidas por amostragem (corretas). Bom trabalho na consolidação por item.

Acrescente na Fase 2 estes itens que ficaram fora (numere a partir de 115):

| # | Item | Arquivo | Por quê |
| --- | --- | --- | --- |
| 115 | ⚠ Exemplo de código Android de chave biométrica: `KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, "AndroidKeyStore")`, `ECGenParameterSpec("secp256r1")`, `KeyProperties.PURPOSE_SIGN`, `DIGEST_SHA256`, `Signature.getInstance("SHA256withECDSA")`, `keyStore.getKey(...)`, `result.cryptoObject.signature` | `skills/mobile-ui-security/references/biometria.md` | É código que o usuário copia; verifique que compila conceitualmente (nomes, ordem `initSign` antes do prompt, `CryptoObject(Signature)`) |
| 116 | ⚠ Afirmação: no Android, o `Alert` do React Native abre janela separada que pode não herdar `FLAG_SECURE` | `skills/mobile-ui-security/SKILL.md` (seção React Native/Expo de telas sensíveis) | Comportamento afirmado sem API; confirme na documentação de `FLAG_SECURE`/janelas de diálogo ou reescreva como precaução |
| 117 | Predictive Back (gesto de voltar preditivo): versão do Android e opt-in (`android:enableOnBackInvokedCallback`) | `skills/mobile-layout-navigation/SKILL.md`; `skills/mobile-ui-ux/references/checklist-qa.md` | Citado sem versão; se o opt-in for necessário para a versão-alvo, deixe explícito |
| 118 | Harmonização de cor em HCT (função de harmonizar cor de marca com o primary) | `skills/mobile-design-tokens/SKILL.md`; `skills/mobile-ui-ux/references/mapeamento-frameworks.md` | Se existir API oficial (ex.: Material Color Utilities / `MaterialColors.harmonize...`), cite o nome correto; se não, mantenha só o conceito |

Lembretes para a Fase 2:
- Os itens #1 e #2 só existem em `guia-completo.md`: **não edite esse arquivo**; o resultado vai apenas para a
  seção "Divergências no texto original" do relatório.
- O item #70 (Reanimated `dampingRatio`) e o #109 (`expo-secure-store`) precisam da **versão mínima** escrita na
  skill, não só "confirmado".
- Valores numéricos densos (#52, #54, #62, #66, #93): se a fonte oficial confirmar só parte, marque item a item
  na observação; não marque a linha inteira como "confirmado" por amostragem.

Pode seguir para a Fase 2.

## Fase 2 — verificação e correção — CORRIGIR ANTES DE SEGUIR (04/11/2026)

Conferido e ok: 6 commits, um por skill, só em `skills/*`; pesquisa e `guia-completo.md` intactos; os seis
`SKILL.md` passam no validador do skill-creator e o `claude plugin validate .` passa. Boas correções, entre elas:
campo de texto M3 com raio extra-small 4dp, tamanhos XS–XL dos botões, Tab Bar 49pt (+ safe area), escala de
raios com `large-increased` 20dp, os dois modos do `withSpring` (que corrigiu um erro meu: eu combinava
`dampingRatio` com `stiffness`), remoção do "iOS 27" e do orçamento de vidro sem fonte, exemplo Keystore completo.

Mas 4 itens ficaram **errados** após a fase. Conferi nas fontes oficiais:

| # | Onde | O que está errado | Correto (fonte) |
| --- | --- | --- | --- |
| 93 | `skills/mobile-accessibility/references/dynamic-type-e-apis.md` | 5 células da tabela do Dynamic Type | **AX2:** Large Title **48 (57)**, Title 2 **39 (47)**. **AX5:** Footnote **44 (52)**, Caption 1 **43 (51)**, Caption 2 **40 (48)**. Demais células conferem. Fonte: HIG Typography, seção "iOS, iPadOS larger accessibility type sizes" (`developer.apple.com/design/human-interface-guidelines/typography`) |
| 100 | `skills/mobile-accessibility/references/dynamic-type-e-apis.md` | Diz que `SemanticsService.announce` está depreciado | Não está. A página da API lista `announce(message, textDirection, {assertiveness})` **e** `sendAnnouncement(FlutterView view, message, textDirection, {assertiveness})` (variante por view, para multi-view), sem nota de depreciação. Cite os dois. Fonte: `api.flutter.dev/flutter/semantics/SemanticsService-class.html` |
| 117 | `skills/mobile-layout-navigation/SKILL.md` e `skills/mobile-ui-ux/references/checklist-qa.md` | "opt-in `enableOnBackInvokedCallback=true` no Android 13/14, padrão no Android 15+ / API 35+" | A doc atual diz que o predictive back **é habilitado por padrão** e o `android:enableOnBackInvokedCallback="false"` serve para **sair** (app ou activity). No Android 13/14 a animação de sistema só aparece com a opção de desenvolvedor "Predictive back animations"; a partir do Android 15 essa opção deixou de existir e as animações aparecem para os apps que suportam. Requisitos: AndroidX Activity 1.6.0+ com `OnBackPressedCallback` (ou `PredictiveBackHandler`/`BackHandler` no Compose, activity-compose 1.8.0+) e não interceptar `onBackPressed`/`KEYCODE_BACK`. Não afirme nível de API para o "padrão". Fonte: `developer.android.com/guide/navigation/custom-back/predictive-back-gesture` |
| 70 | `skills/mobile-motion-haptics/SKILL.md`, `references/tabelas-motion.md`, `skills/mobile-ui-ux/references/mapeamento-frameworks.md` | "modo por duração (Reanimated 3.0+)" | `duration` + `dampingRatio` existem **a partir do Reanimated 3.2** (a doc 3.x marca "3.2.x"). Troque "3.0+" por "3.2+" no modo por duração. Acrescente também, junto do modo físico, que o `mass` padrão do `withSpring` na doc 4.x é **4** — por isso os exemplos devem passar `mass: 1` explicitamente (já passam; diga o porquê em meia frase). Fonte: `docs.swmansion.com/react-native-reanimated/docs/animations/withSpring/` e `/docs/3.x/animations/withSpring` |

Como fazer:
1. Corrija os 4 itens e atualize as linhas correspondentes em `auditoria/verificacao.md` (resultado, fonte e
   observação).
2. Um commit de correção por skill afetada (`fix(<skill>): ...`), sem reescrever os commits anteriores.
3. Rode de novo as checagens de frontmatter e o `git diff --stat main...HEAD`.

**Pare** ao terminar e responda com os commits novos. A Fase 3 só começa depois dessa nova validação.

### Fase 2 — revalidação — APROVADO (04/11/2026)

Os 4 itens foram corrigidos e conferidos no diff (`f059ffc`, `94b5cf2`, `837d0a3`, `b7c1aca`):
- #93: as 5 células do Dynamic Type batem com o HIG (AX2 Large Title 48/57, Title 2 39/47; AX5 Footnote 44/52,
  Caption 1 43/51, Caption 2 40/48).
- #100: `announce` e `sendAnnouncement` citados, sem depreciação.
- #117: predictive back habilitado por padrão, `false` como opt-out, opção de desenvolvedor no 13/14, requisitos
  AndroidX — na skill de layout e no checklist.
- #70: modo por duração como Reanimated 3.2+, `mass` padrão 4 no 4.x explicado nas três ocorrências.

Validadores: os seis `SKILL.md` válidos; pesquisa e `guia-completo.md` intactos; nenhuma alteração fora de
`skills/*`. (Observação sem ação: o `--stat` informado é o mesmo da rodada anterior porque as correções
trocaram linhas já alteradas; confere.)

Pode seguir para a Fase 3.

## Fase 3 — pedidos de ativação — APROVADO (04/11/2026)

Conferido: seis arquivos JSON válidos, 16 pedidos cada (8/8), só as chaves `query` e `should_trigger`; nenhum
arquivo em `skills/*` alterado. Os positivos variam bem (Compose, SwiftUI, Flutter, Expo; formal e informal; com
caminho de arquivo e sintoma) e vários não citam "Material" nem "HIG". Os quase acertos são difíceis de verdade:
web com o mesmo vocabulário (axe/ARIA, GSAP, Navbar Tailwind), colisões de palavra ("tokens" de OAuth e de LLM,
"vibração" de sensor, `AccessibilityService` de automação) e segurança mobile fora da UI (pinning, R8).

Ponto positivo a manter: cada especialista tem negativos que pertencem a uma skill irmã (ex.: AX5 em
`mobile-ui-security`, troca de hex por papéis em `mobile-layout-navigation`) — isso testa a separação entre elas.

Pode gerar `auditoria/RELATORIO.md` e encerrar. Não faça push nem merge.
