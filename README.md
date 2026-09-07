# MEDICAMENTO

App de agenda e controle de horários de medicamentos — PWA single-file (HTML/CSS/JS puro, sem build).

## Como funciona
- Cadastra o medicamento (nome, forma, dose, intervalo, estoque, duração do tratamento, foto opcional).
- A tela inicial mostra a **próxima dose em destaque** (estilo CEAG) com contagem regressiva.
- Ao tocar em **"Tomei"**: registra o horário, desconta do estoque, calcula a próxima dose (agora + intervalo) e reordena a lista — o item confirmado desce, o próximo sobe.
- Alerta local (Notification API + vibração) quando a hora da próxima dose chega, com o app aberto/em segundo plano.
- Aviso de estoque baixo: quando faltam ≤2 dias de estoque, ou quando o estoque vai acabar antes do fim do tratamento.
- Dados salvos em `localStorage` (100% local, sem backend).

## Deploy (GitHub Pages)
1. Crie um repositório novo no GitHub (ex: `medicamento`).
2. Suba todos os arquivos desta pasta para a raiz do repositório.
3. Em **Settings → Pages**, selecione a branch `main` e pasta `/ (root)`.
4. O app fica disponível em `https://<usuario>.github.io/<repo>/`.
5. Gere o APK com o **PWABuilder** (pwabuilder.com) apontando para essa URL, como nos outros apps.

## Estrutura
```
index.html      → app completo (UI + lógica)
manifest.json   → manifest do PWA
sw.js           → service worker (cache offline)
icons/          → ícones do app (192, 512, apple-touch, favicon)
```

## Próximos passos sugeridos
- Trocar alerta local por push real (backend leve) para notificar mesmo com o app fechado/matado pelo sistema.
- Tela de histórico/aderência ao tratamento.
- Múltiplos perfis (mais de uma pessoa usando o mesmo aparelho).
