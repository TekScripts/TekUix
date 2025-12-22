# Tekscripts UIX: Documentação Oficial

Bem-vindo à documentação da Tekscripts UIX. Abaixo você encontrará todos os métodos para inicialização e criação de componentes da biblioteca.

---

## Inicialização: init
Insira este trecho no início do seu código para carregar os componentes necessários da biblioteca.

```lua
-- > Inicialização da UI
local Tekscripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/TekScripts/TekUix/refs/heads/main/src/main.lua"))()
```

---

## Gerenciamento da Janela

### Tekscripts:FloatButtonEdit
Edição abrangente do Float Button (botão flutuante para abrir/fechar a interface).

```lua
Tekscripts:FloatButtonEdit({
    Text = "Abrir Menu", -- > String | Nome que aparece no FloatButton
    Icon = "menu"        -- > String | Ícone exibido ao lado esquerdo
})
```

### Tekscripts.new
Criação da janela principal (Window). Essencial para hospedar todos os outros componentes.

```lua
local gui = Tekscripts.new({
    Name = "MeuPainel",                  -- > String  | Título do painel
    FloatText = "Abrir Painel",          -- > String  | Texto do botão flutuante
    startTab = "auto",                   -- > String  | Tab selecionada inicialmente
    iconId = "rbxassetid://105089076803454", -- > String  | ID do ícone da interface
    Transparent = true,                  -- > Boolean | Define se o painel é transparente
    WindowTransparency = 0.5,            -- > Number  | Nível de transparência (0 a 1)
    LoadScreen = true,                   -- > Boolean | Ativa sistema de carregamento
    Loading = { 
        Title = "TekScripts", 
        Desc = "By: Kauam"
    },                                   -- > Array   | Configuração da tela de load
})
```

---

## Gerenciamento de Abas (Tabs)

### Tekscripts:CreateTab
Cria uma nova seção lateral na interface.

```lua
local MinhaAba = Tekscripts:CreateTab({
    Title = "Minha Aba" -- > String
})
```

#### Métodos da Aba
* **Destruir Aba:** `MinhaAba:Destroy()` (Remove a aba e limpa conexões).
* **Alternar Aba:** `Tekscripts:SetActiveTab(MinhaAba)` (Força a visualização via script).

---

## Componente: Toggle

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Text | string | Nome principal exibido no Toggle. |
| Desc | string? | Descrição detalhada abaixo do título (opcional). |
| Callback | function | Função executada ao alternar (state: boolean). |
| Type | string? | Estilo visual: "Toggle" (Padrão) ou "CheckBox". |
| FeedbackDebug| boolean?| Se true, exibe tremor e borda vermelha em erros. |

### Exemplo de Uso
```lua
local meuToggle = Tekscripts:CreateToggle(MinhaAba, {
    Text = "Velocidade Máxima",
    Desc = "Aumenta a velocidade do personagem",
    Type = "Toggle",
    FeedbackDebug = true,
    Callback = function(state)
        print("Estado do Toggle:", state)
    end
})

-- Definir estado manualmente
meuToggle:SetState(true)
```

### API do Toggle (Métodos)
| Método | Descrição |
| :--- | :--- |
| :SetState(bool) | Altera o estado visual sem disparar o Callback. |
| :GetState() | Retorna o valor atual (true/false). |
| :SetLocked(bool) | Bloqueio Administrativo (ex: para funções VIP). |
| :SetBlocked(bool) | Bloqueio de Segurança (impede spam). |
| :PulseError() | Dispara efeito visual de erro (tremor). |
| :Destroy() | Remove o componente da memória. |

> [!IMPORTANT]
> **Locked vs Blocked:** Use SetLocked para travar itens que o usuário não comprou. Use SetBlocked para evitar que o usuário clique repetidamente enquanto uma função pesada está processando.

---

## Componente: Slider

### Exemplo de Criação
```lua
local MeuSlider = Tekscripts:CreateSlider(MinhaAba, {
    Text = "WalkSpeed",
    Min = 16,
    Max = 100,
    Step = 1,
    Value = 16,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})
```

### API do Slider
| Método | Descrição |
| :--- | :--- |
| :Get() | Retorna o valor atual do Slider. |
| :Set(val) | Define um novo valor para o Slider. |
| :GetPercent() | Retorna o percentual (0 a 1). |
| :SetRange(min, max, step) | Altera os limites dinamicamente. |
| :AnimateTo(val, time) | Move o slider suavemente até um valor. |
| :OnChanged(fn) | Escuta mudanças sem alterar o Callback inicial. |
| :Update(table) | Atualiza propriedades como Texto e Valor de uma vez. |

---

## Componente: TextBox (Log/Input)

### Exemplo de Criação
```lua
local logBox = Tekscripts:CreateTextBox(MinhaAba, {
    Text = "Console de Logs",
    Desc = "Histórico de eventos",
    Default = "Iniciando sistema...\n",
    ReadOnly = true -- Se true, o usuário não pode digitar dentro.
})
```

### API do TextBox
| Método | Descrição |
| :--- | :--- |
| :SetText(string) | Substitui todo o conteúdo do box. |
| :GetText() | Retorna o texto atual. |
| :Append(string) | Adiciona uma nova linha/texto ao final do log. |
| :Clear() | Limpa todo o conteúdo do box. |
| :Destroy() | Remove o componente. |
