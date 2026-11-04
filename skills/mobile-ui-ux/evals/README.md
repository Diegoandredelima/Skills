# Casos de teste do conjunto mobile-ui-ux

Três casos no formato do `claude plugin eval` / skill-creator: cada pasta tem `prompt.md`, `case.yaml`,
`graders/` (um critério por arquivo) e, quando precisa, `files/` + `place-files.sh`.

| Caso | O que testa |
| --- | --- |
| `revisao-formulario-expo` | Revisão de uma tela Expo com ~10 problemas plantados (layout, a11y, tokens, teclado) |
| `ajuste-animacao-sheet` | Parâmetros de mola/timing de um bottom sheet em Reanimated 3 |
| `desbloqueio-biometrico-expo` | Desbloqueio por digital protegendo o refresh token |

Os critérios 01–05/09 checam se os problemas conhecidos foram encontrados (o modelo base costuma passar).
Os seguintes checam valores e práticas específicos da pesquisa — são os que discriminam o efeito da skill.

**Rode fora de qualquer projeto.** Dentro de um repositório com CLAUDE.md, o agente sem skill herda as
convenções do projeto e a comparação fica contaminada. Use uma pasta vazia como diretório de trabalho.

Com Claude Code (v2.1.269+), a partir de `skills/mobile-ui-ux`:

```bash
claude plugin eval . --allow-tools Write,Edit,Bash --scaffold
```
