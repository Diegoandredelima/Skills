# Skills

Repositório de skills do Claude Code e das pesquisas que as originaram.

Cada skill é uma pasta com um `SKILL.md` (instruções que o Claude carrega quando o assunto aparece) e, quando
precisa, `references/` (material consultado sob demanda) e `evals/` (casos de teste).

## Skills disponíveis

### Conjunto mobile-ui-ux — design e engenharia de interface mobile (iOS e Android)

Origem: [`pesquisas/guia-ui-ux-engenharia-mobile.md`](pesquisas/guia-ui-ux-engenharia-mobile.md).
A skill central encaminha para as especializadas; cada uma também é ativada sozinha quando o tema aparece.

| Skill | Cobre |
| --- | --- |
| [`mobile-ui-ux`](skills/mobile-ui-ux/SKILL.md) | Central: Material 3 × HIG/Liquid Glass, princípios, mapeamento Compose/SwiftUI/Flutter/React Native-Expo, assets, checklist de QA pré-release |
| [`mobile-layout-navigation`](skills/mobile-layout-navigation/SKILL.md) | Tab bar/rail/sidebar, thumb zone, breakpoints, master-detail, grid, SafeArea, teclado, specs de componentes |
| [`mobile-design-tokens`](skills/mobile-design-tokens/SKILL.md) | Tokens em 3 camadas, papéis de cor, modo escuro, dynamic color, Liquid Glass, tipografia, raios |
| [`mobile-motion-haptics`](skills/mobile-motion-haptics/SKILL.md) | Molas M3/SwiftUI/Reanimated, transições assimétricas, scrim, Reduce Motion, haptics |
| [`mobile-accessibility`](skills/mobile-accessibility/SKILL.md) | WCAG 2.2, contraste, alvos de toque, VoiceOver/TalkBack, Dynamic Type AX5, fonte a 200% |
| [`mobile-ui-security`](skills/mobile-ui-security/SKILL.md) | Biometria presa a chave em hardware, telas sensíveis, permissões just-in-time |

## Instalação

### Opção 1 — script (copia as pastas)

Global (todas as sessões do Claude Code):

```powershell
.\scripts\install.ps1
```

```bash
./scripts/install.sh
```

Num projeto específico (vai para `<projeto>/.claude/skills`):

```powershell
.\scripts\install.ps1 -Destino "C:\caminho\do\projeto\.claude\skills"
```

```bash
./scripts/install.sh /caminho/do/projeto/.claude/skills
```

Só algumas skills: `.\scripts\install.ps1 -Skills mobile-ui-ux,mobile-accessibility` ou
`./scripts/install.sh ~/.claude/skills mobile-ui-ux mobile-accessibility`.

O script sobrescreve as pastas das skills com o mesmo nome no destino. Rode de novo depois de um `git pull`
para atualizar.

### Opção 2 — plugin do Claude Code

O repositório também é um marketplace de plugin (`.claude-plugin/`). Num terminal com Claude Code:

```
/plugin marketplace add Diegoandredelima/Skills
/plugin install skills-diego@skills-diego
```

Instalado como plugin, as skills ganham o prefixo do plugin (`skills-diego:mobile-ui-ux`). Não instale pelas
duas opções ao mesmo tempo, ou cada skill aparece duas vezes.

## Estrutura

```
Skills/
├── skills/                  uma pasta por skill
│   └── <nome>/
│       ├── SKILL.md         frontmatter (name, description) + instruções
│       ├── references/      material lido sob demanda
│       └── evals/           casos de teste (formato skill-creator / claude plugin eval)
├── pesquisas/               pesquisas-fonte de cada conjunto de skills
├── auditoria/               verificação das APIs contra a documentação oficial (fontes, correções, relatório)
│                            e pedidos de teste de ativação (gatilhos/)
├── scripts/                 install.ps1 / install.sh
└── .claude-plugin/          manifesto de plugin e marketplace
```

## Como adicionar uma skill

1. Coloque a pesquisa em `pesquisas/` (se houver).
2. Crie `skills/<nome-em-kebab-case>/SKILL.md` com `name` igual ao nome da pasta e uma `description` que diga
   o que faz **e** quando usar (é ela que decide a ativação). Mantenha o `SKILL.md` abaixo de ~500 linhas e
   mova tabelas grandes para `references/`.
3. Escreva 2–3 casos em `evals/` e compare com e sem a skill (skill-creator), rodando numa pasta vazia, fora
   de projetos com CLAUDE.md.
4. Atualize a tabela acima e, ao mudar o conteúdo, a versão em `.claude-plugin/plugin.json` e `marketplace.json`.

## Testes

Primeira rodada do conjunto mobile-ui-ux (3 casos, 1 execução cada, nov/2026): 100% dos critérios básicos com e
sem skill; a diferença apareceu na precisão (valores do M3, critério citado por achado), com ~16% a mais de
tokens. Os critérios mais exigentes adicionados depois estão em
[`skills/mobile-ui-ux/evals/`](skills/mobile-ui-ux/evals/README.md).

## Auditoria

Em nov/2026 os 118 nomes de API, versões, normas e valores citados no conjunto mobile-ui-ux foram conferidos
contra a documentação oficial: 91 confirmados, 25 corrigidos, 1 não confirmado e 1 removido. Fontes e detalhes em
[`auditoria/RELATORIO.md`](auditoria/RELATORIO.md). O texto integral da pesquisa não foi editado; a errata no topo
de `skills/mobile-ui-ux/references/guia-completo.md` lista as divergências.
